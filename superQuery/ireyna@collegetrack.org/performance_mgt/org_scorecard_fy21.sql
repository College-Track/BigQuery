#Using data-studio-260217.performance_mgt.fy21_eoy_combined_metrics table
CREATE TEMP TABLE social_emotional_growth AS ( --social emotional growth denominator 
WITH
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
)

SELECT
    site_short,
    region_short,
    SUM(covi_student_grew) AS social_emotional_growth_numerator,
    COUNT(contact_name_c) AS social_emotional_growth_denominator
FROM determine_covi_indicators
GROUP BY site_short, region_short
           );  --pull social emotional growth denominator

CREATE OR REPLACE TABLE `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
OPTIONS
    (
    description="This table pulls org scorecard program outcomes for fy21.  Numerator and denominators are included per site. Does not include graduate/employment outcomes, annual fundraising outcomes, hs capacity, or hr-related outcomes." 
    )
    AS
--site breakdown
    SELECT 
        *,
        male_numerator/ninth_grade_denominator AS percent_male_fy21,
        low_income_first_gen_numerator/ninth_grade_denominator AS percent_low_income_first_gen_fy21,
        annual_retention_numerator/annual_retention_denominator AS percent_annual_retention_fy21,
        a.social_emotional_growth_numerator/b.social_emotional_growth_denominator AS percent_social_emotional_growth_fy21,
        above_325_gpa_seniors_numerator/senior_325_gpa_only_denominator AS percent_seniors_above_325_fy21,
        senior_325_gpa_and_test_ready_numerator/senior_325_gpa_and_test_ready_denominator AS percent_seniors_above_325_and_test_ready_fy21,
        matriculated_best_good_situational_numerator/matriculation_senior_denominator AS percent_matriculate_best_good_situational_fy21,
        on_track_numerator/on_track_denominator AS percent_on_track_fy21,
        six_yr_grad_rate_numerator/grade_rate_6_years_current_class_denom AS percent_6_year_grad_rate_fy21,
        mse_numerator/mse_denominator AS percent_mse_fy21
        
    FROM 
        (SELECT --gather org scorecard metrics to calculate outcomes in main SELECT statement, account for ZEROs
        site_sort,
        site_short,
        region_short,
        
    --admits: male, first-gen & low-income
        CASE WHEN male = 0 THEN NULL ELSE male END AS male_numerator,
        CASE WHEN low_income_and_first_gen = 0 THEN NULL ELSE low_income_and_first_gen END AS low_income_first_gen_numerator,
        CASE WHEN ninth_grade_count = 0 THEN NULL ELSE ninth_grade_count END AS ninth_grade_denominator,
    
    --annual retention
        annual_retention_numerator,
        annual_retention_denominator,
        
    --social-emotional growth
        CASE WHEN covi_student_grew = 0 THEN NULL ELSE covi_student_grew END AS social_emotional_growth_numerator,
        high_school_student_count,
        --covi_student_grew/high_school_student_count AS percent_social_emotional_growth_fy21,
        
    --GPA data: seniors 3.25+ and/or composite ready
        CASE WHEN above_325_gpa_seniors = 0 THEN NULL ELSE above_325_gpa_seniors END AS above_325_gpa_seniors_numerator,
        CASE WHEN above_325_gpa_and_test_ready_seniors = 0 THEN NULL ELSE above_325_gpa_and_test_ready_seniors END AS senior_325_gpa_and_test_ready_numerator,
        CASE WHEN twelfth_grade_count = 0 THEN NULL ELSE twelfth_grade_count END AS senior_325_gpa_only_denominator, --all seniors for 3.25 gpa only
        CASE WHEN twelfth_grade_count_valid_test = 0 THEN NULL ELSE twelfth_grade_count_valid_test END AS senior_325_gpa_and_test_ready_denominator, --students that did not opt out of tests for 3.25 gpa & readiness
        
        
    --matriculation data
        CASE WHEN matriculated_best_good_situational = 0 THEN NULL ELSE matriculated_best_good_situational END AS matriculated_best_good_situational_numerator,
        CASE WHEN twelfth_grade_count = 0 THEN NULL ELSE twelfth_grade_count END AS matriculation_senior_denominator,
    
    --on-track data
        CASE WHEN on_track_numerator = 0 THEN NULL ELSE on_track_numerator END AS on_track_numerator,
        CASE WHEN on_track_denominator = 0 THEN NULL ELSE on_track_denominator END AS on_track_denominator,
        
    --6 year graduation rate
        CASE WHEN grade_rate_6_years_current_class_numerator = 0 THEN NULL ELSE grade_rate_6_years_current_class_numerator END AS six_yr_grad_rate_numerator,
        CASE WHEN grade_rate_6_years_current_class_denom = 0 THEN NULL ELSE grade_rate_6_years_current_class_denom END AS grade_rate_6_years_current_class_denom,
    
    --alumni
        alumni_count,
        
    --meaningful summer experiences
        CASE WHEN had_mse_numerator = 0 THEN NULL ELSE had_mse_numerator END AS mse_numerator,
        CASE WHEN had_mse_denominator = 0 THEN NULL ELSE had_mse_denominator END AS mse_denominator
    
        FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics`  
        ) AS A
    LEFT JOIN social_emotional_growth AS B ON a.site_short = b.site_short --to pull in social emotional growth denominator
