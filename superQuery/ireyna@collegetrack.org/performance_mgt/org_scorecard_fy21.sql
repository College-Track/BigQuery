SELECT --gather org scorecard metrics to calculate outcomes in main SELECT statement, account for ZEROs
        eoy.site_sort,
        eoy.site_short,
        c.site_abrev,
        eoy.region_short,
        c.region_abrev,
        
    --admits: male, first-gen & low-income; San Francsico has 1 student as 9th grade, should be zero - did not recruit
        CASE WHEN male = 0 THEN NULL ELSE male END AS male_numerator,
        CASE WHEN low_income_and_first_gen = 0 THEN NULL ELSE low_income_and_first_gen END AS low_income_first_gen_numerator,
        CASE WHEN ninth_grade_count = 0 THEN NULL ELSE ninth_grade_count END AS ninth_grade_denominator,
    
    --annual retention
        CASE WHEN annual_retention_numerator = 0 THEN NULL ELSE annual_retention_numerator END AS annual_retention_numerator,
        CASE WHEN annual_retention_denominator = 0 THEN NULL ELSE annual_retention_denominator END AS annual_retention_denominator,
        
    --social-emotional growth
        CASE WHEN covi_student_grew = 0 THEN NULL ELSE covi_student_grew END AS social_emotional_growth_numerator,
        CASE WHEN covi_deonominator = 0 THEN NULL ELSE covi_deonominator END AS social_emotional_growth_denominator,
        
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
    
        FROM prep_orgscorecard AS EOY
        LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` AS C ON EOY.site_short=C.site_short