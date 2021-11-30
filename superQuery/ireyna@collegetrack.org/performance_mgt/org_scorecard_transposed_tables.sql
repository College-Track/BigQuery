--Houses all org scorecard outcomes across fiscal years as a tranposed table for the DS Overview Page
--CREATE OR REPLACE TABLE `org-scorecard-286421.aggregate_data.org_scorecard_overview_all_fy`
--OPTIONS
--    (
--    description="This is a transposed table that houses outcomes for all available FY"--
--    )
--    AS 
WITH clean_up_fy21 AS (
SELECT 
Objective
,fiscal_year
,EPA
,OAK
,SF
,NOLA
,AUR
,BH
,SAC
,WATTS
,DEN
,PGC
,DC8
,CREN
,DC
,CO
,LA
,NOLA_RG
,NORCAL
,NATIONAL
,NATIONAL_AS_LOCATION
,CASE 
    WHEN Measure = 'percent_non_white_hr_fy21' THEN 'percent_non_white'
    WHEN Measure = 'percent_lgbtq_hr_fy21' THEN 'percent_lgbtq_hr'
    WHEN Measure = 'percent_6_year_grad_rate_fy21' THEN 'percent_6_year_grad_rate'
    WHEN Measure = 'percent_gainful_employment_fy21' THEN 'percent_gainful_employment'
    WHEN Measure = 'percent_annual_fundraising_target_fy21' THEN 'percent_annual_fundraising_target'
    WHEN Measure = 'percent_employment_grad_school_fy21' THEN 'percent_employment_grad_school'
    WHEN Measure = 'percent_tenure_fy21' THEN 'percent_tenure'
    WHEN Measure = 'percent_social_emotional_growth_fy21' THEN 'percent_social_emotional_growth'
    WHEN Measure = 'percent_matriculated_best_good_situational_fy21' THEN 'percent_matriculated_best_good_situational'
    WHEN Measure = 'percent_on_track_fy21' THEN 'percent_on_track'
    WHEN Measure = 'percent_seniors_above_325_and_test_ready_fy21' THEN 'percent_seniors_above_325_and_test_ready'
    WHEN Measure = 'percent_annual_retention_fy21' THEN 'percent_annual_retention'
    WHEN Measure = 'percent_hs_capacity_fy21' THEN 'percent_hs_capacity'
    WHEN Measure = 'percent_male_fy21' THEN 'percent_male'
    WHEN Measure = 'percent_low_income_first_gen_fy21' THEN 'percent_low_income_first_gen'
    WHEN Measure = 'percent_mse_fy21' THEN 'percent_mse'
    WHEN Measure = 'percent_staff_engagement_fy21' THEN 'percent_staff_engagement'
    WHEN Measure = 'percent_seniors_above_325_fy21' THEN 'percent_seniors_above_325'
    ELSE Measure
    END AS Measure
    
FROM `org-scorecard-286421.transposed_tables.fy21_org_scorecard_outcomes_transposed`
),
clean_up_fy20 AS (
SELECT 
Objective
,fiscal_year
,EPA
,OAK
,SF
,NOLA
,AUR
,BH
,SAC
,WATTS
,DEN
,PGC
,DC8
,CREN
,DC
,CO
,LA
,NOLA_RG
,NORCAL
,NATIONAL
,NATIONAL_AS_LOCATION
,CASE 
    WHEN Measure = 'non_white' THEN 'percent_non_white_hr'
    WHEN Measure = 'first_gen' THEN 'percent_first_gen_hr'
    WHEN Measure = 'lgbtq' THEN 'percent_lgbtq_hr'
    WHEN Measure = 'annual_fundraising' THEN 'percent_annual_fundraising_target'
    WHEN Measure = 'male' THEN 'percent_male_hr'
    WHEN Measure = 'tenure' THEN 'percent_tenure'
    WHEN Measure = 'staff_engagement' THEN 'percent_staff_engagement'
    ELSE Measure
    END AS Measure
    
FROM `org-scorecard-286421.transposed_tables.org_scorecard_fy20_overview`
)
SELECT
Objective
,Measure
,fiscal_year
,EPA
,OAK
,SF
,NOLA
,AUR
,BH
,SAC
,WATTS
,DEN
,PGC
,DC8
,CREN
,DC
,CO
,LA
,NOLA_RG
,NORCAL
,NATIONAL
,NATIONAL_AS_LOCATION
FROM clean_up_fy21

UNION ALL

SELECT
Objective
,Measure
,fiscal_year
,EPA
,OAK
,SF
,NOLA
,AUR
,BH
,SAC
,WATTS
,DEN
,PGC
,DC8
,CREN
,DC
,CO
,LA
,NOLA_RG
,NORCAL
,NATIONAL
,NATIONAL_AS_LOCATION
FROM clean_up_fy20