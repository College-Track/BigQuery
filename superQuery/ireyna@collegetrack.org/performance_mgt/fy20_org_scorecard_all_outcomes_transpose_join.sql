SELECT 
    *,
    CASE 
        WHEN Measure = 'annual_fundraising' THEN 'Annual Fundraising target (100%)'  
        WHEN Measure = 'hs_capacity' THEN 'High school capacity enrolled (95%)' 
        WHEN Measure = 'gpa_3_0_composite_readiness' THEN 'Seniors with GPA 3.25+ and Composite Ready (55%)' 
        WHEN Measure = 'entering_9th_grade_students_male' THEN '9th grade students are male (50%)' 
        WHEN Measure = 'entering_9th_grade_students_lowincome_firstgen' THEN '9th grade students are low-income and first-generation (80%)'  
        WHEN Measure = 'on_track' THEN 'Students with enough credits accumulated to graduate in 6 years (80%)' 
        WHEN Measure = 'grad_rate' THEN 'Students graduating from college within 6 years (70%)' 
        WHEN Measure = 'employment_grad_school' THEN 'Graduates with full-time employment or enrolled in graduate school within 6 months of graduation (65%)'  
        WHEN Measure = 'gainful_employment_standard' THEN 'Graduates meeting gainful employment standard (85%)'  
        WHEN Measure = 'meaningful_employment' THEN 'Graduates with meaningful employment (85%)'  
        WHEN Measure = 'matriculation' THEN 'Students matriculating to Best Fit, Good Fit, or Situational Best Fit colleges (50%)'  
        WHEN Measure = 'tenure' THEN 'Staff with full-time tenure of 3+ years in organization (35%)' 
        WHEN Measure = 'mse' THEN 'Students with meaningful summer experiences (85%)' 
        WHEN Measure = 'annual_retention' THEN 'High school students retained annually (90%)' 
        WHEN Measure = 'staff_engagement' THEN 'Staff engagement score above average nonprofit benchmark (Y)' 
        WHEN Measure = 'social_emotional_growth' THEN 'Students growing toward average or above social-emotional strengths' 
        WHEN Measure IN ('first_gen,lgbtq,non_white,male') THEN 'Strategy Team representing a spectrum of identities above average nonprofit benchmarks*' 
        ELSE NULL
        END AS measure_datastudio,
FROM  `org-scorecard-286421.transposed_tables.org_scorecard_fy20_overview`