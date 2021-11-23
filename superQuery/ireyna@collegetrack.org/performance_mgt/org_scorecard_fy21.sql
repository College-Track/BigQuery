SELECT 
    *,
    male_numerator/ninth_grade_denominator AS percent_male_fy21,
    low_income_first_gen_numerator/ninth_grade_denominator AS percent_low_income_first_gen_fy21,
    annual_retention_numerator/annual_retention_denominator AS percent_annual_retention_fy21,
    social_emotional_growth_numerator/social_emotional_growth_denominator AS percent_social_emotional_growth_fy21,
    above_325_gpa_seniors_numerator/senior_325_gpa_only_denominator AS percent_seniors_above_325_fy21,
    senior_325_gpa_and_test_ready_numerator/senior_325_gpa_and_test_ready_denominator AS percent_seniors_above_325_and_test_ready_fy21,
    matriculated_best_good_situational_numerator/matriculation_senior_denominator AS percent_matriculated_best_good_situational_fy21,
    on_track_numerator/on_track_denominator AS percent_on_track_fy21,
    six_yr_grad_rate_numerator/grade_rate_6_years_current_class_denom AS percent_6_year_grad_rate_fy21,
    mse_numerator/mse_denominator AS percent_mse_fy21

FROM  `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`