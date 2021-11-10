#Using data-studio-260217.performance_mgt.fy21_eoy_combined_metrics table

--site breakdown
    SELECT
        site_sort,
        site_short,
        region_short,
        
    --admits: male, first-gen & low-income
        male AS male_numerator,
        low_income_and_first_gen AS low_income_first_gen_numerator,
        ninth_grade_count AS ninth_grade_denominator,
        CASE WHEN male = 0 THEN NULL ELSE (male/ninth_grade_count) END AS percent_male_admits_fy21,
        CASE WHEN low_income_and_first_gen = 0 THEN NULL ELSE (low_income_and_first_gen/ninth_grade_count) END AS percent_low_income_first_gen_fy21,
    
    --annual retention
        annual_retention_numerator,
        annual_retention_denominator,
        annual_retention_numerator/annual_retention_denominator AS percent_annual_retention_fy21,
        
    --social-emotional growth
        covi_student_grew AS social_emotional_growth_numerator,
        covi_student_grew/high_school_student_count AS percent_social_emotional_growth_fy21,
        
        
    --GPA data: seniors 3.25+ and/or composite ready
        above_325_gpa_seniors AS above_325_gpa_seniors_numerator,
        above_325_gpa_and_test_ready_seniors AS senior_325_gpa_and_test_ready_numerator,
        twelfth_grade_count AS senior_325_gpa_only_denominator, --all seniors for 3.25 gpa only
        twelfth_grade_count_valid_test AS senior_325_gpa_and_test_ready_denominator, --students that did not opt out of tests for 3.25 gpa & readiness
        above_325_gpa_seniors/twelfth_grade_count AS percent_seniors_above_325_fy21,
        above_325_gpa_and_test_ready_seniors/twelfth_grade_count_valid_test AS percent_seniors_above_325_and_test_ready_fy21,
        
    --matriculation data
        matriculated_best_good_situational AS matriculated_best_good_situational_numerator,
        twelfth_grade_count AS matriculation_senior_denominator,
        matriculated_best_good_situational/twelfth_grade_count AS percent_matriculate_best_good_situational_fy21,
    
    --on-track data
        on_track_numerator,
        on_track_denominator,
        on_track_numerator/on_track_denominator AS percent_on_track_fy21,
        
    --6 year graduation rate
        grade_rate_6_years_current_class_numerator AS six_yr_grad_rate_numerator,
        grade_rate_6_years_current_class_denom,
        grade_rate_6_years_current_class_numerator/grade_rate_6_years_current_class_denom AS percent_6_year_grad_rate_fy21,
    
    --alumni
        alumni_count,
        
    --meaningful summer experiences
        had_mse_numerator AS mse_numerator,
        had_mse_denominator AS mse_denominator,
        had_mse_numerator/had_mse_denominator AS percent_mse_fy21,
        
    

    FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics`  