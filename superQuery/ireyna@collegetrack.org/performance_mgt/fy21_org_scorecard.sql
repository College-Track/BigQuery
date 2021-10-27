--Using FY21_eoy_combined_metrics table
/*
    
   
    
    
    
    Strategy Team representing a spectrum of identities above average nonprofit benchmarks*
    Annual Fundraising target (100%)
    Staff with full-time tenure of 3+ years in organization (35%)
  
    Staff engagement score above average nonprofit benchmark (Y)
*/
  
    SELECT
        if_site_sort,
        site_short,
        region_short,
    --reporting group denominators
    SUM(high_school_student_count) AS high_school_student_count,
    SUM(twelfth_grade_count) AS senior_denominator,
    SUM(had_mse_denominator) AS mse_denominator, 
    SUM(four_year_retention_denominator) AS four_year_retention_denominator,
    SUM(on_track_denominator) AS on_track_denominator,
    SUM(grade_rate_6_years_current_class_denom) AS grade_rate_6_years_current_class_denom,
    
    --Seniors with GPA 3.25+ and Composite Ready (55%)
    SUM(above_325_gpa_and_test_ready_seniors) AS above_325_gpa_test_ready_numerator,
    
    --9th grade students are male (50%)
    SUM(male) AS incoming_male_numerator,
    
    --9th grade students are low-income and first-generation (80%)
    SUM(
        CASE WHEN (first_gen = 1 AND low_income = 1) THEN 1 ELSE 0
        END
        ) AS first_gen_low_income_numerator,
    
    --Students with meaningful summer experiences (85%)
    SUM(had_mse_numerator) AS mse_numerator,
    
    --Students growing toward average or above social-emotional strengths
    
    --High school students retained annually (90%)
    SUM(four_year_retention_numerator) AS four_year_retention_numerator,
                
    --High school capacity enrolled (95%); FY21 outcome to be manually entered
    
    --Students matriculating to Best Fit, Good Fit, or Situational Best Fit colleges (50%)
    SUM(matriculated_best_good_situational) AS matriculated_best_good_situational_numerator,
    
    --Students with enough credits accumulated to graduate in 6 years
    SUM(on_track_numerator) AS on_track_numerator,
    
    --Students graduating from college within 6 years (70%)
    SUM(grade_rate_6_years_current_class_numerator) AS grade_rate_6_years_current_class_numerator,
    
    --Graduates with full-time employment or enrolled in graduate school within 6 months of graduation (65%)
    
    --Graduates meeting gainful employment standard (85%)
    
    --Graduates with meaningful employment (85%)
    
  FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics` 
  GROUP BY 
    if_site_sort,
    site_short,
    region_short