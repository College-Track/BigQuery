CREATE OR REPLACE TABLE `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
OPTIONS
    (
    description="This table pulls org scorecard program outcomes for fy21.  Numerator and denominators are included per site. Does not include graduate/employment outcomes, annual fundraising outcomes, hs capacity, or hr-reDCted outcomes." 
    )
    AS

WITH add_national_values  AS (
--populte values for NATIONAL
    SELECT
        site_or_region_abbrev	
        ,site_sort	
        ,site_short	
        ,site_abrev	
        ,region_short	
        ,CASE WHEN site_or_region = 'National' THEN 'NATIONAL' ELSE region_abrev END AS region_abrev,
        CASE WHEN site_or_region_abbrev = 'NATIONAL' THEN 'National' ELSE site_or_region END AS site_or_region,
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
    FROM    (
            SELECT * EXCEPT (site_or_region_abbrev), CASE WHEN site_or_region = 'National' THEN 'NATIONAL' ELSE site_or_region_abbrev END AS site_or_region_abbrev 
            FROM `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
            )
    --WHERE region_abrev IN ('NOR CAL','LA','CO','NOLA_RG','DC') OR site_or_region_abbrev = "NATIONAL"
)
, prep_national_table AS(
SELECT 	  
    b.site_or_region	
    ,b.site_or_region_abbrev	
    ,b.site_sort	
    ,b.site_short	
    ,b.site_abrev	
    ,b.region_short	
    ,b.region_abrev
    ,b.male_numerator	
    ,b.low_income_first_gen_numerator	
    ,b.ninth_grade_denominator	
    ,b.annual_retention_numerator	
    ,b.annual_retention_denominator	
    ,b.social_emotional_growth_numerator	
    ,b.social_emotional_growth_denominator	
    ,b.above_325_gpa_seniors_numerator	
    ,b.senior_325_gpa_and_test_ready_numerator	
    ,b.senior_325_gpa_only_denominator	,
    b.senior_325_gpa_and_test_ready_denominator	
    ,b.matriculated_best_good_situational_numerator	
    ,b.matriculation_senior_denominator	
    ,b.on_track_numerator	
    ,b.on_track_denominator	
    ,b.six_yr_grad_rate_numerator	
    ,b.grade_rate_6_years_current_class_denom	
    ,b.alumni_count	
    ,b.mse_numerator	
    ,b.mse_denominator	
    ,percent_male_fy21	
    ,percent_low_income_first_gen_fy21	
    ,percent_annual_retention_fy21	
    ,percent_social_emotional_growth_fy21	
    ,percent_seniors_above_325_fy21	
    ,percent_seniors_above_325_and_test_ready_fy21	
    ,percent_matriculate_best_good_situational_fy21	
    ,percent_on_track_fy21	
    ,percent_6_year_grad_rate_fy21	
    ,percent_mse_fy21
FROM  add_national_values AS b 
LEFT JOIN  `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21` AS A 
ON b.site_or_region_abbrev = a.region_abrev
WHERE b.site_or_region_abbrev='NATIONAL'
)
SELECT * FROM prep_national_table
UNION DISTINCT 
SELECT * FROM `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21` 
;
DELETE  `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
WHERE site_or_region = 'National' AND male_numerator IS NULL
OR region_abrev = 'NATIONAL'
