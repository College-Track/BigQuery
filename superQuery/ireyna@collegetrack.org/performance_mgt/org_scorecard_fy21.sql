#Using data-studio-260217.performance_mgt.fy21_eoy_combined_metrics table
#Adding columns to fy21_org_scorecard_program table


WITH add_national_values  AS (
--populte values for NATIONAL
    SELECT 
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(male_numerator) OVER () ELSE male_numerator END AS male_numerator, --pull grand total, add value only to National
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(ninth_grade_denominator) OVER () ELSE ninth_grade_denominator END AS ninth_grade_denominator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(low_income_first_gen_numerator) OVER () ELSE low_income_first_gen_numerator END AS low_income_first_gen_numerator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(annual_retention_numerator) OVER () ELSE annual_retention_numerator END AS annual_retention_numerator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(annual_retention_denominator) OVER () ELSE annual_retention_denominator END AS annual_retention_denominator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(social_emotional_growth_numerator) OVER () ELSE social_emotional_growth_numerator END AS social_emotional_growth_numerator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(social_emotional_growth_denominator) OVER () ELSE social_emotional_growth_denominator END AS social_emotional_growth_denominator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(mse_numerator) OVER () ELSE mse_numerator END AS mse_numerator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(mse_denominator) OVER () ELSE mse_denominator END AS mse_denominator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(above_325_gpa_seniors_numerator) OVER () ELSE above_325_gpa_seniors_numerator END AS above_325_gpa_seniors_numerator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(senior_325_gpa_and_test_ready_numerator) OVER () ELSE senior_325_gpa_and_test_ready_numerator END AS senior_325_gpa_and_test_ready_numerator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(senior_325_gpa_only_denominator) OVER () ELSE senior_325_gpa_only_denominator END AS senior_325_gpa_only_denominator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(senior_325_gpa_and_test_ready_denominator) OVER () ELSE senior_325_gpa_and_test_ready_denominator END AS senior_325_gpa_and_test_ready_denominator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(matriculated_best_good_situational_numerator) OVER () ELSE matriculated_best_good_situational_numerator END AS matriculated_best_good_situational_numerator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(matriculation_senior_denominator) OVER () ELSE matriculation_senior_denominator END AS matriculation_senior_denominator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(on_track_numerator) OVER () ELSE on_track_numerator END AS on_track_numerator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(on_track_denominator) OVER () ELSE on_track_denominator END AS on_track_denominator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(six_yr_grad_rate_numerator) OVER () ELSE six_yr_grad_rate_numerator END AS six_yr_grad_rate_numerator,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(grade_rate_6_years_current_class_denom) OVER () ELSE grade_rate_6_years_current_class_denom END AS grade_rate_6_years_current_class_denom,
    CASE WHEN site_or_region_abbrev = "NATIONAL" THEN SUM(alumni_count) OVER () ELSE alumni_count END AS alumni_count
    FROM `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
)
, add_norcal_values AS (

SELECT 
    region_abrev,site_or_region_abbrev,
--Populate values for NORCAL
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(male_numerator) OVER () ELSE male_numerator END AS male_numerator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(ninth_grade_denominator) OVER () ELSE ninth_grade_denominator END AS ninth_grade_denominator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(low_income_first_gen_numerator) OVER () ELSE low_income_first_gen_numerator END AS low_income_first_gen_numerator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(annual_retention_numerator) OVER () ELSE annual_retention_numerator END AS annual_retention_numerator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(annual_retention_denominator) OVER () ELSE annual_retention_denominator END AS annual_retention_denominator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(social_emotional_growth_numerator) OVER () ELSE social_emotional_growth_numerator END AS social_emotional_growth_numerator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(social_emotional_growth_denominator) OVER () ELSE social_emotional_growth_denominator END AS social_emotional_growth_denominator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(mse_numerator) OVER () ELSE mse_numerator END AS mse_numerator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(mse_denominator) OVER () ELSE mse_denominator END AS mse_denominator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(above_325_gpa_seniors_numerator) OVER () ELSE above_325_gpa_seniors_numerator END AS above_325_gpa_seniors_numerator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(senior_325_gpa_and_test_ready_numerator) OVER () ELSE senior_325_gpa_and_test_ready_numerator END AS senior_325_gpa_and_test_ready_numerator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(senior_325_gpa_only_denominator) OVER () ELSE senior_325_gpa_only_denominator END AS senior_325_gpa_only_denominator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(senior_325_gpa_and_test_ready_denominator) OVER () ELSE senior_325_gpa_and_test_ready_denominator END AS senior_325_gpa_and_test_ready_denominator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(matriculated_best_good_situational_numerator) OVER () ELSE matriculated_best_good_situational_numerator END AS matriculated_best_good_situational_numerator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(matriculation_senior_denominator) OVER () ELSE matriculation_senior_denominator END AS matriculation_senior_denominator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(on_track_numerator) OVER () ELSE on_track_numerator END AS on_track_numerator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(on_track_denominator) OVER () ELSE on_track_denominator END AS on_track_denominator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(six_yr_grad_rate_numerator) OVER () ELSE six_yr_grad_rate_numerator END AS six_yr_grad_rate_numerator,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(grade_rate_6_years_current_class_denom) OVER () ELSE grade_rate_6_years_current_class_denom END AS grade_rate_6_years_current_class_denom,
    CASE WHEN site_or_region_abbrev = "NORCAL" THEN SUM(alumni_count) OVER () ELSE alumni_count END AS alumni_count

FROM  `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
WHERE region_abrev = 'NOR CAL' OR site_or_region_abbrev = "NORCAL"
),
add_la_values AS (
SELECT 
    region_abrev,site_or_region_abbrev,
--Populate values for LA region
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(male_numerator) OVER () ELSE male_numerator END AS male_numerator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(ninth_grade_denominator) OVER () ELSE ninth_grade_denominator END AS ninth_grade_denominator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(low_income_first_gen_numerator) OVER () ELSE low_income_first_gen_numerator END AS low_income_first_gen_numerator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(annual_retention_numerator) OVER () ELSE annual_retention_numerator END AS annual_retention_numerator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(annual_retention_denominator) OVER () ELSE annual_retention_denominator END AS annual_retention_denominator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(social_emotional_growth_numerator) OVER () ELSE social_emotional_growth_numerator END AS social_emotional_growth_numerator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(social_emotional_growth_denominator) OVER () ELSE social_emotional_growth_denominator END AS social_emotional_growth_denominator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(mse_numerator) OVER () ELSE mse_numerator END AS mse_numerator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(mse_denominator) OVER () ELSE mse_denominator END AS mse_denominator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(above_325_gpa_seniors_numerator) OVER () ELSE above_325_gpa_seniors_numerator END AS above_325_gpa_seniors_numerator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(senior_325_gpa_and_test_ready_numerator) OVER () ELSE senior_325_gpa_and_test_ready_numerator END AS senior_325_gpa_and_test_ready_numerator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(senior_325_gpa_only_denominator) OVER () ELSE senior_325_gpa_only_denominator END AS senior_325_gpa_only_denominator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(senior_325_gpa_and_test_ready_denominator) OVER () ELSE senior_325_gpa_and_test_ready_denominator END AS senior_325_gpa_and_test_ready_denominator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(matriculated_best_good_situational_numerator) OVER () ELSE matriculated_best_good_situational_numerator END AS matriculated_best_good_situational_numerator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(matriculation_senior_denominator) OVER () ELSE matriculation_senior_denominator END AS matriculation_senior_denominator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(on_track_numerator) OVER () ELSE on_track_numerator END AS on_track_numerator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(on_track_denominator) OVER () ELSE on_track_denominator END AS on_track_denominator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(six_yr_grad_rate_numerator) OVER () ELSE six_yr_grad_rate_numerator END AS six_yr_grad_rate_numerator,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(grade_rate_6_years_current_class_denom) OVER () ELSE grade_rate_6_years_current_class_denom END AS grade_rate_6_years_current_class_denom,
    CASE WHEN site_or_region_abbrev = "LA" THEN SUM(alumni_count) OVER () ELSE alumni_count END AS alumni_count

FROM  `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
WHERE region_abrev = 'LA' OR site_or_region_abbrev = "LA"
),
add_co_values AS(
SELECT 
    region_abrev,site_or_region_abbrev,
--Populate values for CO region
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(male_numerator) OVER () ELSE male_numerator END AS male_numerator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(ninth_grade_denominator) OVER () ELSE ninth_grade_denominator END AS ninth_grade_denominator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(low_income_first_gen_numerator) OVER () ELSE low_income_first_gen_numerator END AS low_income_first_gen_numerator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(annual_retention_numerator) OVER () ELSE annual_retention_numerator END AS annual_retention_numerator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(annual_retention_denominator) OVER () ELSE annual_retention_denominator END AS annual_retention_denominator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(social_emotional_growth_numerator) OVER () ELSE social_emotional_growth_numerator END AS social_emotional_growth_numerator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(social_emotional_growth_denominator) OVER () ELSE social_emotional_growth_denominator END AS social_emotional_growth_denominator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(mse_numerator) OVER () ELSE mse_numerator END AS mse_numerator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(mse_denominator) OVER () ELSE mse_denominator END AS mse_denominator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(above_325_gpa_seniors_numerator) OVER () ELSE above_325_gpa_seniors_numerator END AS above_325_gpa_seniors_numerator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(senior_325_gpa_and_test_ready_numerator) OVER () ELSE senior_325_gpa_and_test_ready_numerator END AS senior_325_gpa_and_test_ready_numerator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(senior_325_gpa_only_denominator) OVER () ELSE senior_325_gpa_only_denominator END AS senior_325_gpa_only_denominator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(senior_325_gpa_and_test_ready_denominator) OVER () ELSE senior_325_gpa_and_test_ready_denominator END AS senior_325_gpa_and_test_ready_denominator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(matriculated_best_good_situational_numerator) OVER () ELSE matriculated_best_good_situational_numerator END AS matriculated_best_good_situational_numerator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(matriculation_senior_denominator) OVER () ELSE matriculation_senior_denominator END AS matriculation_senior_denominator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(on_track_numerator) OVER () ELSE on_track_numerator END AS on_track_numerator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(on_track_denominator) OVER () ELSE on_track_denominator END AS on_track_denominator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(six_yr_grad_rate_numerator) OVER () ELSE six_yr_grad_rate_numerator END AS six_yr_grad_rate_numerator,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(grade_rate_6_years_current_class_denom) OVER () ELSE grade_rate_6_years_current_class_denom END AS grade_rate_6_years_current_class_denom,
    CASE WHEN site_or_region_abbrev = "CO" THEN SUM(alumni_count) OVER () ELSE alumni_count END AS alumni_count

FROM  `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
WHERE region_abrev = 'CO' OR site_or_region_abbrev = "CO"
),
add_dc_values AS (
SELECT 
    region_abrev,site_or_region_abbrev,
--Populate values for DC region
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(male_numerator) OVER () ELSE male_numerator END AS male_numerator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(ninth_grade_denominator) OVER () ELSE ninth_grade_denominator END AS ninth_grade_denominator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(low_income_first_gen_numerator) OVER () ELSE low_income_first_gen_numerator END AS low_income_first_gen_numerator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(annual_retention_numerator) OVER () ELSE annual_retention_numerator END AS annual_retention_numerator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(annual_retention_denominator) OVER () ELSE annual_retention_denominator END AS annual_retention_denominator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(social_emotional_growth_numerator) OVER () ELSE social_emotional_growth_numerator END AS social_emotional_growth_numerator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(social_emotional_growth_denominator) OVER () ELSE social_emotional_growth_denominator END AS social_emotional_growth_denominator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(mse_numerator) OVER () ELSE mse_numerator END AS mse_numerator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(mse_denominator) OVER () ELSE mse_denominator END AS mse_denominator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(above_325_gpa_seniors_numerator) OVER () ELSE above_325_gpa_seniors_numerator END AS above_325_gpa_seniors_numerator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(senior_325_gpa_and_test_ready_numerator) OVER () ELSE senior_325_gpa_and_test_ready_numerator END AS senior_325_gpa_and_test_ready_numerator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(senior_325_gpa_only_denominator) OVER () ELSE senior_325_gpa_only_denominator END AS senior_325_gpa_only_denominator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(senior_325_gpa_and_test_ready_denominator) OVER () ELSE senior_325_gpa_and_test_ready_denominator END AS senior_325_gpa_and_test_ready_denominator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(matriculated_best_good_situational_numerator) OVER () ELSE matriculated_best_good_situational_numerator END AS matriculated_best_good_situational_numerator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(matriculation_senior_denominator) OVER () ELSE matriculation_senior_denominator END AS matriculation_senior_denominator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(on_track_numerator) OVER () ELSE on_track_numerator END AS on_track_numerator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(on_track_denominator) OVER () ELSE on_track_denominator END AS on_track_denominator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(six_yr_grad_rate_numerator) OVER () ELSE six_yr_grad_rate_numerator END AS six_yr_grad_rate_numerator,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(grade_rate_6_years_current_class_denom) OVER () ELSE grade_rate_6_years_current_class_denom END AS grade_rate_6_years_current_class_denom,
    CASE WHEN site_or_region_abbrev = "DC" THEN SUM(alumni_count) OVER () ELSE alumni_count END AS alumni_count

FROM  `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
WHERE region_abrev = 'DC' OR site_or_region_abbrev = "DC"
),
add_nola_rg_values AS (
SELECT 
    region_abrev,site_or_region_abbrev,
--Populate values for NOLA region
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(male_numerator) OVER () ELSE male_numerator END AS male_numerator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(ninth_grade_denominator) OVER () ELSE ninth_grade_denominator END AS ninth_grade_denominator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(low_income_first_gen_numerator) OVER () ELSE low_income_first_gen_numerator END AS low_income_first_gen_numerator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(annual_retention_numerator) OVER () ELSE annual_retention_numerator END AS annual_retention_numerator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(annual_retention_denominator) OVER () ELSE annual_retention_denominator END AS annual_retention_denominator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(social_emotional_growth_numerator) OVER () ELSE social_emotional_growth_numerator END AS social_emotional_growth_numerator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(social_emotional_growth_denominator) OVER () ELSE social_emotional_growth_denominator END AS social_emotional_growth_denominator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(mse_numerator) OVER () ELSE mse_numerator END AS mse_numerator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(mse_denominator) OVER () ELSE mse_denominator END AS mse_denominator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(above_325_gpa_seniors_numerator) OVER () ELSE above_325_gpa_seniors_numerator END AS above_325_gpa_seniors_numerator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(senior_325_gpa_and_test_ready_numerator) OVER () ELSE senior_325_gpa_and_test_ready_numerator END AS senior_325_gpa_and_test_ready_numerator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(senior_325_gpa_only_denominator) OVER () ELSE senior_325_gpa_only_denominator END AS senior_325_gpa_only_denominator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(senior_325_gpa_and_test_ready_denominator) OVER () ELSE senior_325_gpa_and_test_ready_denominator END AS senior_325_gpa_and_test_ready_denominator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(matriculated_best_good_situational_numerator) OVER () ELSE matriculated_best_good_situational_numerator END AS matriculated_best_good_situational_numerator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(matriculation_senior_denominator) OVER () ELSE matriculation_senior_denominator END AS matriculation_senior_denominator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(on_track_numerator) OVER () ELSE on_track_numerator END AS on_track_numerator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(on_track_denominator) OVER () ELSE on_track_denominator END AS on_track_denominator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(six_yr_grad_rate_numerator) OVER () ELSE six_yr_grad_rate_numerator END AS six_yr_grad_rate_numerator,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(grade_rate_6_years_current_class_denom) OVER () ELSE grade_rate_6_years_current_class_denom END AS grade_rate_6_years_current_class_denom,
    CASE WHEN site_or_region_abbrev = "NOLA_RG" THEN SUM(alumni_count) OVER () ELSE alumni_count END AS alumni_count

FROM  `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
WHERE region_abrev = 'NOLA' OR site_or_region_abbrev = "NOLA_RG"
),
combine_regional_values AS (
SELECT * EXCEPT (region_abrev) FROM add_norcal_values
UNION DISTINCT
SELECT * EXCEPT (region_abrev) FROM add_la_values
UNION DISTINCT
SELECT * EXCEPT (region_abrev) FROM add_co_values
UNION DISTINCT
SELECT * EXCEPT (region_abrev) FROM add_dc_values
UNION DISTINCT
SELECT * EXCEPT (region_abrev) FROM add_nola_rg_values
)
SELECT 	site_or_region,	site_sort,site_short,	site_abrev,	region_short,region_abrev, b.site_or_region_abbrev
,b.male_numerator	
,b.low_income_first_gen_numerator	
,b.ninth_grade_denominator	
,b.annual_retention_numerator	
,b.annual_retention_denominator	
,b.social_emotional_growth_numerator	
,b.social_emotional_growth_denominator	
,b.above_325_gpa_seniors_numerator	senior_325_gpa_and_test_ready_numerator	
,b.senior_325_gpa_only_denominator	senior_325_gpa_and_test_ready_denominator	
,b.matriculated_best_good_situational_numerator	
,b.matriculation_senior_denominator	
,b.on_track_numerator	
,b.on_track_denominator	
,b.six_yr_grad_rate_numerator	
,b.grade_rate_6_years_current_class_denom	
,b.alumni_count	mse_numerator
,b.mse_denominator	



FROM `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21` A
LEFT JOIN combine_regional_values B ON a.site_or_region_abbrev=b.site_or_region_abbrev
/*CREATE TEMPORARY FUNCTION AccountAbrev (Account STRING) AS ( --create function to transform new site_or_region column to site_or_region_abrev
    CASE
        WHEN Account LIKE '%Northern California%' THEN 'NORCAL'
        WHEN Account LIKE '%Colorado%' THEN 'CO'
        WHEN Account LIKE '%Los Angeles%' THEN 'DC'
        WHEN Account LIKE '%New Orleans_RG%' THEN 'NODC_RG'
        WHEN Account LIKE '%DC%' THEN 'DC'
        WHEN Account LIKE '%Denver%' THEN 'DEN'
        WHEN Account LIKE '%Aurora%' THEN 'AUR'
        WHEN Account LIKE '%San Francisco%' THEN 'SF'
        WHEN Account LIKE '%East Palo Alto%' THEN 'EPA'
        WHEN Account LIKE '%Sacramento%' THEN 'SAC'
        WHEN Account LIKE '%OakDCnd%' THEN 'OAK'
        WHEN Account LIKE '%Watts%' THEN 'WATTS'
        WHEN Account LIKE '%Boyle Heights%' THEN 'BH'
        WHEN Account LIKE '%Ward 8%' THEN 'DC8'
        WHEN Account LIKE '%Durant%' THEN 'PGC'
        WHEN Account LIKE '%New Orleans%' THEN 'NODC'
        WHEN Account LIKE '%Crenshaw%' THEN 'CREN'
        WHEN Account = 'National' THEN 'NATIONAL'
        WHEN Account = 'National (AS LOCATION)' THEN 'NATIONAL_AS_LOCATION'
      END)
      ;
CREATE TEMP TABLE ORG_SCORECARD_FY21_ADD_COLUMN (site_or_region STRING); --create table that stores new column to add to fy21_org_scorecard_program table
INSERT INTO ORG_SCORECARD_FY21_ADD_COLUMN (site_or_region) VALUES  ('National'), --add site_or_region column with values
                                                        ('East Palo Alto'),
                                                        ('OakDCnd'),
                                                        ('San Francisco'),
                                                        ('New Orleans'),
                                                        ('Aurora'),
                                                        ('Boyle Heights'),
                                                        ('Sacramento'),
                                                        ('Watts'),
                                                        ('Denver'),
                                                        ('The Durant Center'),
                                                        ('Ward 8'),
                                                        ('Crenshaw'),
                                                        ('Northern California'),
                                                        ('Los Angeles'),
                                                        ('New Orleans_RG'),
                                                        ('Colorado'),
                                                        ('Washington DC');
/*
CREATE OR REPDCCE TABLE `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
OPTIONS
    (
    description="This table pulls org scorecard program outcomes for fy21.  Numerator and denominators are included per site. Does not include graduate/employment outcomes, annual fundraising outcomes, hs capacity, or hr-reDCted outcomes." 
    )
    AS
*/    
    
/*
#code used to add site_or_region and site_or_region_abbrev to org_scorecard_fy21_program table
CREATE TEMPORARY FUNCTION AccountAbrev (Account STRING) AS (
    CASE
        WHEN Account LIKE '%Northern California%' THEN 'NORCAL'
        WHEN Account LIKE '%Colorado%' THEN 'CO'
        WHEN Account LIKE '%Los Angeles%' THEN 'DC'
        WHEN Account LIKE '%New Orleans_RG%' THEN 'NODC_RG'
        WHEN Account LIKE '%DC%' THEN 'DC'
        WHEN Account LIKE '%Denver%' THEN 'DEN'
        WHEN Account LIKE '%Aurora%' THEN 'AUR'
        WHEN Account LIKE '%San Francisco%' THEN 'SF'
        WHEN Account LIKE '%East Palo Alto%' THEN 'EPA'
        WHEN Account LIKE '%Sacramento%' THEN 'SAC'
        WHEN Account LIKE '%OakDCnd%' THEN 'OAK'
        WHEN Account LIKE '%Watts%' THEN 'WATTS'
        WHEN Account LIKE '%Boyle Heights%' THEN 'BH'
        WHEN Account LIKE '%Ward 8%' THEN 'DC8'
        WHEN Account LIKE '%Durant%' THEN 'PGC'
        WHEN Account LIKE '%New Orleans%' THEN 'NODC'
        WHEN Account LIKE '%Crenshaw%' THEN 'CREN'
        WHEN Account = 'National' THEN 'NATIONAL'
        WHEN Account = 'National (AS LOCATION)' THEN 'NATIONAL_AS_LOCATION'
      END)
      ;
CREATE TEMP TABLE ORG_SCORECARD_FY21_ADD_COLUMN (site_or_region STRING); --create table that stores new column to add to fy21_org_scorecard table
INSERT INTO ORG_SCORECARD_FY21_ADD_COLUMN (site_or_region) VALUES  ('National'), --add site_or_region column with values
                                                        ('East Palo Alto'),
                                                        ('OakDCnd'),
                                                        ('San Francisco'),
                                                        ('New Orleans'),
                                                        ('Aurora'),
                                                        ('Boyle Heights'),
                                                        ('Sacramento'),
                                                        ('Watts'),
                                                        ('Denver'),
                                                        ('The Durant Center'),
                                                        ('Ward 8'),
                                                        ('Crenshaw'),
                                                        ('Northern California'),
                                                        ('Los Angeles'),
                                                        ('New Orleans_RG'),
                                                        ('Colorado'),
                                                        ('Washington DC');
INSERT INTO `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21` (site_or_region) VALUES ('National') --Add "National" as a row value for site_or_region column
;
INSERT INTO `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21` (site_or_region_abbrev) VALUES ('NATIONAL') --Add "NATIONAL" as a row value for site_or_region_abbrev column
;

WITH prep_orgscorecard AS (
    SELECT EOY.* , site_or_region, AccountAbrev(site_or_region) AS site_or_region_abbrev --add newly created column
    FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics`  AS EOY
    FULL JOIN ORG_SCORECARD_FY21_ADD_COLUMN AS TEMP ON EOY.site_short=TEMP.site_or_region 
    )
    
, aggregate_outcomes_as_percent AS (
    SELECT 
        *,
        male_numerator/ninth_grade_denominator AS percent_male_fy21,
        low_income_first_gen_numerator/ninth_grade_denominator AS percent_low_income_first_gen_fy21,
        annual_retention_numerator/annual_retention_denominator AS percent_annual_retention_fy21,
        social_emotional_growth_numerator/social_emotional_growth_denominator AS percent_social_emotional_growth_fy21,
        above_325_gpa_seniors_numerator/senior_325_gpa_only_denominator AS percent_seniors_above_325_fy21,
        senior_325_gpa_and_test_ready_numerator/senior_325_gpa_and_test_ready_denominator AS percent_seniors_above_325_and_test_ready_fy21,
        matriculated_best_good_situational_numerator/matriculation_senior_denominator AS percent_matricuDCte_best_good_situational_fy21,
        on_track_numerator/on_track_denominator AS percent_on_track_fy21,
        six_yr_grad_rate_numerator/grade_rate_6_years_current_class_denom AS percent_6_year_grad_rate_fy21,
        mse_numerator/mse_denominator AS percent_mse_fy21,
         
        
    FROM 
        (SELECT DISTINCT--gather org scorecard metrics to calcuDCte outcomes in main SELECT statement, account for ZEROs
        site_or_region,
        site_or_region_abbrev,
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
        
        
    --matricuDCtion data
        CASE WHEN matricuDCted_best_good_situational = 0 THEN NULL ELSE matricuDCted_best_good_situational END AS matriculated_best_good_situational_numerator,
        CASE WHEN twelfth_grade_count = 0 THEN NULL ELSE twelfth_grade_count END AS matriculation_senior_denominator,
    
    --on-track data
        CASE WHEN on_track_numerator = 0 THEN NULL ELSE on_track_numerator END AS on_track_numerator,
        CASE WHEN on_track_denominator = 0 THEN NULL ELSE on_track_denominator END AS on_track_denominator,
        
    --6 year graduation rate
        CASE WHEN grade_rate_6_years_current_cDCss_numerator = 0 THEN NULL ELSE grade_rate_6_years_current_cDCss_numerator END AS six_yr_grad_rate_numerator,
        CASE WHEN grade_rate_6_years_current_class_denom = 0 THEN NULL ELSE grade_rate_6_years_current_class_denom END AS grade_rate_6_years_current_class_denom,
    
    --alumni
        alumni_count,
        
    --meaningful summer experiences
        CASE WHEN had_mse_numerator = 0 THEN NULL ELSE had_mse_numerator END AS mse_numerator,
        CASE WHEN had_mse_denominator = 0 THEN NULL ELSE had_mse_denominator END AS mse_denominator
    
        FROM  prep_orgscorecard AS EOY
        LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_tempDCte` AS C ON EOY.site_or_region=C.site_short
        
        GROUP BY site_short, male,low_income_and_first_gen,ninth_grade_count,annual_retention_numerator,annual_retention_denominator
                ,covi_student_grew,covi_deonominator,above_325_gpa_seniors,above_325_gpa_and_test_ready_seniors,twelfth_grade_count
                ,matricuDCted_best_good_situational,twelfth_grade_count_valid_test,twelfth_grade_count,on_track_numerator,on_track_denominator
                ,grade_rate_6_years_current_cDCss_numerator,grade_rate_6_years_current_class_denom,alumni_count
                ,had_mse_numerator,mse_denominator,site_sort,site_short,site_abrev,region_short,region_abrev,site_or_region,
                site_or_region_abbrev
        ))
    SELECT *
    FROM aggregate_outcomes_as_percent AS EOY
   
*/        
/* #Alter table org_scorecard_program_fy21
ALTER TABLE `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
    ADD COLUMN fiscal_year STRING;
UPDATE `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21` --PopuDCte 'fiscal year' with 'FY20'
    SET fiscal_year = "FY21"
    WHERE fiscal_year IS NULL
        ;
*/
