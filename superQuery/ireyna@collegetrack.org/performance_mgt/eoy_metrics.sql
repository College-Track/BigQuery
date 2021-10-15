#This compiles EOY metrics across the organization, including: Org Scorecard data, FY21 IF


WITH
--first gather HS data for Org Scorecard
--Org Scoreard: 9th grade low-income + first-gen; 3.25 CGPA+ & composite ready
gather_some_hs_data AS (
    SELECT
            COUNT(DISTINCT contact_id) AS hs_student_served_2020_21_count,
            site_short,
            region_short,
            CASE
                WHEN site_short = 'East Palo Alto' THEN 1
                WHEN site_short = 'Oakland' THEN 2
                WHEN site_short = 'San Francisco' THEN 3
                WHEN site_short = 'New Orleans' THEN 4
                WHEN site_short = 'Aurora' THEN 5
                WHEN site_short = 'Boyle Heights' THEN 6
                WHEN site_short = 'Sacramento' THEN 7
                WHEN site_short = 'Watts' THEN 8
                WHEN site_short = 'Denver' THEN 9
                WHEN site_short = 'The Durant Center' THEN 10
                WHEN site_short = 'Ward 8' THEN 11
                WHEN site_short = 'Crenshaw' THEN 12
            END AS org_scorecard_site_sort,

    --% of entering 9th grade students who are low-income AND first-gen
        SUM(CASE
            WHEN (at_grade_c = '9th Grade' AND indicator_low_income_c = 'Yes' AND indicator_first_generation_c = TRUE)
            THEN 1
            ELSE NULL
        END) AS ninth_grade_low_income_first_gen_numerator,

    --9th grade students denom for % of entering 9th grade students who are low-income AND first-gen
        SUM(CASE
            WHEN at_grade_c = '9th Grade'
            THEN 1
            ELSE NULL
        END) AS ninth_grade_low_income_first_gen_denominator,

    --% of seniors with GPA 3.25+ AND Composite Ready
        SUM(CASE
            WHEN  (at_grade_c = '12th Grade' AND AT_Cumulative_GPA >= 3.25 AND readiness_composite_off_c = '1. Ready')
            THEN 1
            ELSE NULL
        END) AS seniors_above_3_25_gpa_numerator,

    --denominator for seniors with GPA 3.25+ AND Composite Ready
        SUM(CASE
            WHEN at_grade_c = '12th Grade'
            THEN 1
            ELSE NULL
        END) AS seniors_above_3_25_gpa_denom

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`

    WHERE
        AY_Name = 'AY 2020-21'
        AND Term_c = 'Spring' --to pull in GPA data
        AND AT_Record_Type_Name = 'High School Semester'
        AND AY_2020_21_student_served_c = 'High School Student'

    GROUP BY
        site_short,
        region_short
),

--Org Scoreard & Impact Framework: Most recent Summer 2020-21
meaningful_summer_experiences AS (
    SELECT
        COUNT(DISTINCT contact_id) AS mse_denom,
        site_short,
        region_short,

        SUM(CASE
            WHEN summer_experiences_previous_summer_c > 0 #Summer Experience
                THEN 1
                ELSE NULL
            END) AS mse_completed_numerator,

    FROM `data-warehouse-289815.salesforce_clean.contact_template` AS c

    WHERE
        c.Contact_Id IN (SELECT DISTINCT(contact_id)
                        FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
                        WHERE
                            (AY_2020_21_student_served_c = 'High School Student'
                            AND (term_c='Summer' AND AY_Name = 'AY 2020-21' AND student_audit_status_c='Current CT HS Student')))

    GROUP BY
        site_short,
        region_short
),

--Org Scoreard: Student has attended at least 1 workshop session b/w Fall & Spring (except NSO), and is still active
annual_retention AS (
        SELECT
            site_short,
            region_short,
            SUM(AY_annual_retention_numerator) as annual_retention_numerator, --LOA and Current as of Spring CT Status (AT)
            SUM(AY_annual_retention_denom) as annual_retention_denominator


        FROM `data-warehouse-289815.salesforce_clean.contact_template` AS C
        LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_ay_template` AS AY
            ON C.contact_id = ay.contact_id
        WHERE ay_name = 'AY 2020-21'

        GROUP BY
            site_short,
            region_short
),

-- Org Scoreard: Covi - % of students growing toward average or above social-emotional strengths. This KPI is done over four CTEs. The majority of the logic is done in the second CTE.
gather_covi_data AS (
    SELECT
        contact_name_c,
        site_short,
        region_short,
        AY_Name,
        MIN(belief_in_self_raw_score_c + engaged_living_raw_score_c + belief_in_others_raw_score_c + emotional_competence_raw_score_c) AS covi_raw_score
    FROM `data-warehouse-289815.salesforce_clean.test_clean` T
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT
        ON CAT.AT_Id = T.academic_semester_c
    WHERE
        T.record_type_id = '0121M000001cmuDQAQ'
        AND AY_Name IN ('AY 2019-20', 'AY 2020-21')
        AND AY_2020_21_student_served_c = 'High School Student'
    GROUP BY
        site_short,
        region_short,
        contact_name_c,
        AY_Name
    ORDER BY
        site_short,
        region_short,
        contact_name_c,
        AY_Name
),

-- CONT'D: Org Scoreard COVI % of students growing toward average or above social-emotional strengths
calc_covi_growth AS (
    SELECT
        site_short,
        region_short,
        contact_name_c,
        covi_raw_score - LAG(covi_raw_score) OVER (PARTITION BY contact_name_c ORDER BY AY_Name) AS covi_growth --Returns the value of the value_expression on a preceding row.
    FROM gather_covi_data

),

-- CONT'D: Org Scoreard COVI % of students growing toward average or above social-emotional strengths
determine_covi_indicators AS (
    SELECT
        site_short,
        region_short,
        contact_name_c,
        SUM(CASE
            WHEN covi_growth > 0
            THEN 1
            ELSE 0
        END) AS covi_student_grew

    FROM calc_covi_growth
    WHERE
            covi_growth IS NOT NULL

    GROUP BY
        site_short,
        region_short,
    contact_name_c
),

-- CONT'D: % of students growing toward average or above social-emotional strengths
aggregate_covi_data AS (
        SELECT
            site_short,
            region_short,
            SUM(covi_student_grew) AS social_emotional_growth_numerator,
            COUNT(contact_name_c) AS social_emotional_growth_denominator
        FROM
            determine_covi_indicators
        GROUP BY
            site_short,
            region_short
),

--Org Scorecard: HS aggregation
aggregate_hs_orgscorecard_metrics AS (
    SELECT
        base.site_short,
        ninth_grade_low_income_first_gen_numerator,
        ninth_grade_low_income_first_gen_denominator,
        ROUND(((ninth_grade_low_income_first_gen_numerator / ninth_grade_low_income_first_gen_denominator)*100),2) AS ninth_grade_low_income_and_first_gen,
        seniors_above_3_25_gpa_numerator,
        seniors_above_3_25_gpa_denom,
        ROUND(((seniors_above_3_25_gpa_numerator / seniors_above_3_25_gpa_denom)*100),2) AS seniors_above_3_25_composite_ready,
        hs_student_served_2020_21_count,
        mse_completed_numerator,
        mse_denom,
        ROUND (((mse_completed_numerator / mse_denom)*100),2) AS mses_2020_21_summer,
        annual_retention_numerator,
        annual_retention_denominator,
        ROUND(((annual_retention_numerator / annual_retention_denominator )*100),2) AS annual_retention,
        social_emotional_growth_numerator,
        social_emotional_growth_denominator,
        ROUND(((social_emotional_growth_numerator / social_emotional_growth_denominator)*100),2) social_emotional_growth

    FROM gather_some_hs_data AS base
    LEFT JOIN meaningful_summer_experiences AS mse
        ON base.site_short = mse.site_short
    LEFT JOIN annual_retention AS annual_retention
        ON base.site_short = annual_retention.site_short
    LEFT JOIN aggregate_covi_data AS covi
        ON base.site_short = covi.site_short
),

--Org Scorecard: college metrics
matriculation AS (
    SELECT
        site_short,
        region_short,
        COUNT(DISTINCT contact_id) AS matriculated_denomiantor,
        SUM(CASE
            WHEN fit_type_current_c IN ('Best Fit','Good Fit','Situational')
            THEN 1
            ELSE NULL
        END) AS matriculated_best_good_situational

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` AS term

    WHERE
        indicator_completed_ct_hs_program_c = TRUE
        AND AY_Name = 'AY 2021-22'
        AND AT_record_type_name = 'College/University Semester'
        AND indicator_years_since_hs_grad_to_date_c IN (.25,.33)
        AND enrolled_in_a_4_year_college_c = TRUE

    GROUP BY
        site_short,
        region_short
),

--Org Scorecard: college. prepare students on track to graduate within 6 years. 2 CTEs
--Pull on-track indicator from Spring, and from Summer if credits were earned
prep_on_track_data AS (
  SELECT
    contact_id,
    site_short,
    region_short,
    term_c,

    -- Indciator is 1 or 0. Graduated or student still in college and on track to graduate in 6 years or less

    CASE
        WHEN term_c = 'Spring' AND Indicator_Graduated_or_On_Track_AT_c IS NOT NULL
        THEN Indicator_Graduated_or_On_Track_AT_c
        END AS on_track_indicator_spring,
    CASE
        WHEN term_c = "Summer" AND credits_accumulated_c > 0  AND Indicator_Graduated_or_On_Track_AT_c IS NOT NULL
        THEN Indicator_Graduated_or_On_Track_AT_c
        END AS on_track_indicator_summer,
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`

    WHERE
        contact_id NOT IN ( --students without an Approved Gap Year
                    SELECT DISTINCT contact_id
                    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
                    WHERE AT_Grade_c = 'Year 1'
                    AND AT_Enrollment_Status_c = 'Approved Gap Year'
                    AND indicator_completed_ct_hs_program_c = true
                    )
        AND indicator_completed_ct_hs_program_c = TRUE
        AND AT_Record_Type_Name = 'College/University Semester'
        AND AY_Name IN ("AY 2020-21")
        AND term_c IN ("Spring","Summer")
        AND (Indicator_Years_Since_HS_Grad_to_Date_c < 6 AND Indicator_Years_Since_HS_Grad_to_Date_c > 0)
        AND high_school_class_c <> '2015'

),

--Org scorecard: college. CONT'D: on-track, pulling numerator and denominator
on_track AS (
  SELECT
    COUNT(DISTINCT contact_id) AS on_track_denominator,
    site_short,
    region_short,
    SUM(CASE
        WHEN on_track_indicator_summer IS NOT NULL
        THEN on_track_indicator_summer
        ELSE on_track_indicator_spring
    END) AS on_track_numerator

    FROM
        prep_on_track_data

    GROUP BY
        site_short,
        region_short
),

--Org Scoared: college - 6 year grad rate
grad_rate_6_years AS (
    SELECT
        COUNT(DISTINCT contact_id) AS grade_rate_6_years_denominator,
        site_short,
        region_short,
        SUM(CASE
            WHEN graduated_4_year_degree_6_years_c = TRUE
            THEN 1
            ELSE NULL
        END) AS grade_rate_6_years_numerator

    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE
        indicator_completed_ct_hs_program_c = TRUE
        AND high_school_graduating_class_c = '2015'

    GROUP BY
        site_short,
        region_short
),

--Org Scorecard: aggregate college metrics
aggregate_college_orgscorecard_metrics AS (
    SELECT
        matriculation.site_short,
        matriculation.region_short,
        matriculated_denomiantor,
        matriculated_best_good_situational,
        ROUND(((matriculated_best_good_situational/matriculated_denomiantor)*100),2) AS matriculated_best_good_situational_rate,
        on_track_numerator,
        on_track_denominator,
        ROUND(((on_track_numerator/on_track_denominator)*100),2) AS on_track,
        grade_rate_6_years_numerator,
        grade_rate_6_years_denominator,
        ROUND(((grade_rate_6_years_numerator/grade_rate_6_years_denominator)*100),2) AS grade_rate_6_years_2015


    FROM matriculation
    FULL JOIN on_track
        ON matriculation.site_short = on_track.site_short
    FULL JOIN grad_rate_6_years
        ON matriculation.site_short = grad_rate_6_years.site_short
)
select *
from aggregate_college_orgscorecard_metrics

  