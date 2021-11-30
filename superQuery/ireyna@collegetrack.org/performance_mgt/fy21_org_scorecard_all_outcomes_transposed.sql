SELECT 
    * EXCEPT (measure_datastudio)
    CASE 
        WHEN Measure = 'percent_6_year_grad_rate' AND measure_datastudio IS NULL THEN 'Students graduating from college within 6 years (70%)'
        WHEN Measure = 'percent_gainful_employment' AND measure_datastudio IS NULL THEN 'Graduates meeting gainful employment standard (85%)'
        WHEN Measure = 'percent_annual_fundraising_target' AND measure_datastudio IS NULL THEN 'annual_fundraising	Annual Fundraising target (100%)'
        WHEN Measure = 'percent_meaningful_employment' AND measure_datastudio IS NULL THEN 'Graduates with meaningful employment (85%)'
        WHEN Measure = 'percent_employment_grad_school' AND measure_datastudio IS NULL THEN 'Graduates with full-time employment or enrolled in graduate school within 6 months of graduation (65%)'
        WHEN Measure = 'percent_tenure' AND measure_datastudio IS NULL THEN 'Staff with full-time tenure of 3+ years in organization (35%)'
        WHEN Measure = 'percent_social_emotional_growth' AND measure_datastudio IS NULL THEN 'Students growing toward average or above social-emotional strengths'
        WHEN Measure = 'percent_matriculated_best_good_situational' AND measure_datastudio IS NULL THEN 'Students matriculating to Best Fit, Good Fit, or Situational Best Fit colleges (50%)'
        WHEN Measure = 'percent_on_track' AND measure_datastudio IS NULL THEN 'Students with enough credits accumulated to graduate in 6 years (80%)'
        WHEN Measure = 'percent_seniors_above_325_and_test_ready' AND measure_datastudio IS NULL THEN 'Seniors with GPA 3.25+ and Composite Ready (55%)'
        WHEN Measure = 'percent_annual_retention' AND measure_datastudio IS NULL THEN 'High school students retained annually (90%)'
        WHEN Measure = 'percent_hs_capacity' AND measure_datastudio IS NULL THEN 'High school capacity enrolled (95%)'
        WHEN Measure = 'percent_male' AND measure_datastudio IS NULL THEN '9th grade students are male (50%)'
        WHEN Measure = 'percent_low_income_first_gen' AND measure_datastudio IS NULL THEN '9th grade students are low-income and first-generation (80%)'
        WHEN Measure = 'percent_mse' AND measure_datastudio IS NULL THEN 'Students with meaningful summer experiences (85%)'
        WHEN Measure = 'percent_staff_engagement' AND measure_datastudio IS NULL THEN 'Staff engagement score above average nonprofit benchmark (Y)'
        ELSE measure_datastudio
        END AS measure_datastudio