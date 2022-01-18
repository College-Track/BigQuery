#Link to maintained code in GitHub (DDT_SQL): https://github.com/College-Track/DDT_SQL/blob/main/IF_and_org_scorecard_ps_metrics.sql
#Updating on-track portion of this query - was inaccurate and was inflating rates by double counting students

#This compiles EOY metrics across the organization, including: FY21 Org Scorecard data, FY21 IF
#this query has since been retired - now using the data-studio-260217.performance_mgt.fy21_eoy_combined_metrics table

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
        END) AS seniors_above_3_25_gpa_denom,


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
--Updated on-track logic with Baker support on 1/17/2022

gather_on_track_reporting_group AS (
    SELECT
        Contact_Id,
        region_short,
        site_short,
        indicator_college_matriculation_c,
        high_school_graduating_class_c
     FROM
        `data-warehouse-289815.salesforce_clean.contact_template`
     WHERE
        indicator_college_matriculation_c != 'Approved Gap Year'
        AND CAST(high_school_graduating_class_c AS INT64) > 2015
        AND CAST(high_school_graduating_class_c AS INT64) <= 2020
        AND indicator_completed_ct_hs_program_c = TRUE
),

--Org scorecard: college. CONT'D: on-track. Prep on-track numerator, data from Spring term
spring_on_track_data AS (
  SELECT
    Contact_Id,
    
    -- Indciator is 1 or 0. Graduated or student still in college and on track to graduate in 6 years or less
    CASE
      WHEN Indicator_Graduated_or_On_Track_AT_c IS NOT NULL 
      THEN Indicator_Graduated_or_On_Track_AT_c
      END AS on_track_indicator_spring,
  FROM  `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    AY_Name IN ("AY 2020-21")
    AND term_c = 'Spring' ),

---Org scorecard: college. CONT'D: on-track. Prep on-track data numerator, data from Summer term. If student earned credits and is on track
summer_on_track_data AS (
    SELECT
        Contact_Id,
    
    -- Indciator is 1 or 0. Graduated or student still in college and on track to graduate in 6 years or less
    CASE
        WHEN credits_accumulated_c > 0 AND Indicator_Graduated_or_On_Track_AT_c IS NOT NULL 
        THEN Indicator_Graduated_or_On_Track_AT_c
        END AS on_track_indicator_summer
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE
        AY_Name IN ("AY 2020-21")
        AND term_c = 'Summer' ),
 

--Org scorecard: college. CONT'D: on-track, join Spring and Summer on-track data to on-track reporting group
join_on_track_spring_summer_data AS (
    SELECT
        gather_on_track_reporting_group.Contact_Id,
        gather_on_track_reporting_group.region_short,
        gather_on_track_reporting_group.site_short,
        spring_on_track_data.on_track_indicator_spring,
        summer_on_track_data.on_track_indicator_summer
    FROM gather_on_track_reporting_group
    LEFT JOIN spring_on_track_data
        ON spring_on_track_data.Contact_Id = gather_on_track_reporting_group.Contact_Id
    LEFT JOIN summer_on_track_data
        ON summer_on_track_data.Contact_Id = gather_on_track_reporting_group.Contact_Id 
),

--Org scorecard: college. CONT'D: on-track, create numerator field
create_on_track_numerators AS (
    SELECT
        Contact_Id,
        region_short,
        site_short,
    CASE
        WHEN on_track_indicator_summer IS NOT NULL 
        THEN on_track_indicator_summer --if Summer credits earned and on-track, then use Summer term data
        ELSE on_track_indicator_spring --Else, use Spring term data for on-track determination
        END AS on_track_numerator
    FROM join_on_track_spring_summer_data 
),

--Org scorecard: college. CONT'D: on-track, aggregate numerators and denominators   
on_track AS (
    SELECT
        region_short,
        site_short,
        COUNT(Contact_Id) AS on_track_denominator,
        SUM(on_track_numerator) AS on_track_numerator
    FROM create_on_track_numerators
    GROUP BY
        region_short,
        site_short
     ORDER BY site_short    
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

;
--site breakdown
    SELECT
        if_site_sort,
        site_short,
    --GPA data
        above_3_gpa AS students_above_3_gpa_numerator,
        above_325_gpa_seniors AS above_325_gpa_seniors_numerator,
        above_325_gpa_and_test_ready_seniors AS above_325_gpa_and_test_ready_seniors_numerator,
        high_school_student_count AS hs_students_denominator,
        non_opt_out_seniors AS senior_readiness_gpa_opt_ins_denominator,
        
    --matriculation data
        matriculation_numerator AS num_matriculation,
        matriculated_affordable AS num_matriculation_affordable,
        matriculated_best_good_situational AS num_matriculated_best_good_situational,
        college_first_enrolled_school_type_numerator AS matriculation_4yr,
        twelfth_grade_count AS senior_denominator,
        
    --persistence data
        indicator_persisted_into_2_nd_year_ct_numerator AS num_persistence,
        persistence_denominator,
    
    --on-track data
        on_track_numerator,
        on_track_denominator,
    
    --college students graduating with 1+ internship
        had_1_plus_internship_numerator,
        had_1_plus_internship_denominator,
        
    --6 year graduation rate
        grade_rate_6_years_current_class_numerator AS num_6_yr_grad_rate,
        grade_rate_6_years_current_class_denom,
    
    --alumni
        alumni_count,
        
    --MEMO data
        had_mse_numerator AS mse_numerator,
        had_mse_denominator AS mse_denominator,
        
        above_80_attendance_memo AS above_80_attendance_memo_orig,
        CASE WHEN above_80_attendance = 0 AND above_80_attendance_memo = 1
            THEN above_80_attendance_memo  ELSE above_80_attendance
            END AS attendance_numerator_memo,
        high_school_student_count

    FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics`  
    ;
--region breakdown
SELECT
    
        region_short,
        
        SUM(matriculation_numerator) AS num_matriculation,
        SUM(matriculated_affordable) AS num_matriculation_affordable,
        SUM(matriculated_best_good_situational) AS num_matriculated_best_good_situational,
        SUM(college_first_enrolled_school_type_numerator) AS matriculation_4yr,
        SUM(twelfth_grade_count) AS senior_denominator,
    
    --3.0 & 3.25 GPA data
        SUM(above_3_gpa)AS students_above_3_gpa_numerator,
        SUM(above_325_gpa_seniors) AS above_325_gpa_seniors_numerator,
        SUM(above_325_gpa_and_test_ready_seniors) AS above_325_gpa_and_test_ready_seniors_numerator,
        SUM(high_school_student_count) AS hs_students_denominator,
        SUM(non_opt_out_seniors) AS senior_readiness_gpa_opt_ins_denominator,
        
    --persistence data
        SUM(indicator_persisted_into_2_nd_year_ct_numerator) AS num_persistence,
        SUM(persistence_denominator) AS persistence_denominator,
    
    --on-track data
        SUM(on_track_numerator) AS on_track_numerator,
        SUM(on_track_denominator) AS on_track_denominator,
    
    --college students graduating with 1+ internship
        SUM(had_1_plus_internship_numerator) AS had_1_plus_internship_numerator,
        SUM(had_1_plus_internship_denominator) AS had_1_plus_internship_denominator,
        
    --6 year graduation rate
        SUM(grade_rate_6_years_current_class_numerator) AS num_6_yr_grad_rate,
        SUM(grade_rate_6_years_current_class_denom) AS grade_rate_6_years_current_class_denom,
    
    --alumni
        SUM(alumni_count) AS alumni_count,
    
    --MEMO data
        SUM(had_mse_numerator) AS mse_numerator,
        SUM(had_mse_denominator) AS mse_denominator,
        
        SUM(above_80_attendance_memo) AS above_80_attendance_memo_orig,
        
        SUM(CASE WHEN above_80_attendance = 0 AND above_80_attendance_memo = 1
            THEN above_80_attendance_memo  ELSE above_80_attendance
            END) AS attendance_numerator_memo,
        SUM(high_school_student_count) AS high_school_student_count,

    FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics`
    GROUP BY
        region_short

  