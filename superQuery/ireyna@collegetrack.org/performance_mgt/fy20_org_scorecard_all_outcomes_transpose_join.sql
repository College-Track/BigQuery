SELECT 
    * EXCEPT (Measure),
    CASE 
        WHEN Measure = 'hs_capacity' THEN 'percent_hs_capacity'
        WHEN Measure = 'gpa_3_0_composite_readiness' THEN 'percent_seniors_above_325_and_test_ready'
        WHEN Measure = 'entering_9th_grade_students_male' THEN 'percent_male'
        WHEN Measure = 'entering_9th_grade_students_lowincome_firstgen' THEN  'percent_low_income_first_gen'
        WHEN Measure = 'on_track' THEN  'percent_on_track'
        WHEN Measure = 'grad_rate' THEN 'percent_6_year_grad_rate'
        WHEN Measure = 'employment_grad_school' THEN 'percent_employment_grad_school'
        WHEN Measure = 'gainful_employment_standard' THEN 'percent_gainful_employment' 
        WHEN Measure = 'meaningful_employment' THEN 'percent_meaningful_employment'
        WHEN Measure = 'matriculation' THEN 'percent_matriculated_best_good_situational'
        WHEN Measure = 'mse' THEN 'percent_mse'
        WHEN Measure = 'annual_retention' THEN  'percent_annual_retention'
        WHEN Measure = 'social_emotional_growth' THEN 'percent_social_emotional_growth'
        ELSE Measure
        END AS Measure
FROM  `org-scorecard-286421.transposed_tables.org_scorecard_fy20_overview`