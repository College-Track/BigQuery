SELECT 
    *,
    CASE WHEN site_or_region = "NATIONAL" THEN SUM(male_numerator) OVER () ELSE male_numerator END AS male_numerator,
    CASE WHEN site_or_region = "NATIONAL" THEN SUM(ninth_grade_denominator) OVER () ELSE ninth_grade_denominator END AS ninth_grade_denominator,
    CASE WHEN site_or_region = "NATIONAL" THEN SUM(low_income_first_gen_numerator) OVER () ELSE low_income_first_gen_numerator END AS low_income_first_gen_numerator,
    CASE WHEN site_or_region = "NATIONAL" THEN SUM(annual_retention_numerator) OVER () ELSE annual_retention_numerator END AS annual_retention_numerator,
    CASE WHEN site_or_region = "NATIONAL" THEN SUM(annual_retention_denominator) OVER () ELSE annual_retention_denominator END AS annual_retention_denominator,
    CASE WHEN site_or_region = "NATIONAL" THEN SUM(social_emotional_growth_numerator) OVER () ELSE social_emotional_growth_numerator END AS social_emotional_growth_numerator,
    CASE WHEN site_or_region = "NATIONAL" THEN SUM(social_emotional_growth_denominator) OVER () ELSE social_emotional_growth_denominator END AS social_emotional_growth_denominator,
    CASE WHEN site_or_region = "National" THEN SUM(mse_numerator) OVER () ELSE mse_numerator END AS mse_numerator,
    CASE WHEN site_or_region = "National" THEN SUM(mse_denominator) OVER () ELSE mse_denominator END AS mse_denominator,
    CASE WHEN site_or_region = "National" THEN SUM(above_325_gpa_seniors_numerator) OVER () ELSE above_325_gpa_seniors_numerator END AS above_325_gpa_seniors_numerator,
    CASE WHEN site_or_region = "National" THEN SUM(senior_325_gpa_and_test_ready_numerator) OVER () ELSE senior_325_gpa_and_test_ready_numerator END AS senior_325_gpa_and_test_ready_numerator,
    CASE WHEN site_or_region = "National" THEN SUM(senior_325_gpa_only_denominator) OVER () ELSE senior_325_gpa_only_denominator END AS senior_325_gpa_only_denominator,
    CASE WHEN site_or_region = "National" THEN SUM(senior_325_gpa_and_test_ready_denominator) OVER () ELSE senior_325_gpa_and_test_ready_denominator END AS senior_325_gpa_and_test_ready_denominator,
    CASE WHEN site_or_region_abbrev = "National" THEN SUM(matriculated_best_good_situational_numerator) OVER () ELSE matriculated_best_good_situational_numerator END AS matriculated_best_good_situational_numerator,
    CASE WHEN site_or_region_abbrev = "National" THEN SUM(matriculation_senior_denominator) OVER () ELSE matriculation_senior_denominator END AS matriculation_senior_denominator,
    CASE WHEN site_or_region_abbrev = "National" THEN SUM(on_track_numerator) OVER () ELSE on_track_numerator END AS on_track_numerator,
    CASE WHEN site_or_region_abbrev = "National" THEN SUM(on_track_denominator) OVER () ELSE on_track_denominator END AS on_track_denominator,
    CASE WHEN site_or_region_abbrev = "National" THEN SUM(six_yr_grad_rate_numerator) OVER () ELSE six_yr_grad_rate_numerator END AS six_yr_grad_rate_numerator,
    CASE WHEN site_or_region_abbrev = "National" THEN SUM(grade_rate_6_years_current_class_denom) OVER () ELSE grade_rate_6_years_current_class_denom END AS grade_rate_6_years_current_class_denom,
    --CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(alumni_count) OVER () ELSE alumni_count END AS alumni_count

FROM  `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
WHERE site_or_region ='National' OR site_or_region_abbrev IN ('NORCAL','CO','LA','NOLA_RG','DC')