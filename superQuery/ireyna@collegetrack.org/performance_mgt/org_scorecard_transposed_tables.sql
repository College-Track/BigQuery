--Houses all org scorecard outcomes across fiscal years as a tranposed table for the DS Overview Page
/*CREATE OR REPLACE TABLE `org-scorecard-286421.transposed_tables.org_scorecard_overview_all_fy`
OPTIONS
    (
    description="This is a transposed table that houses outcomes for all available FY"
    )
    AS 
   */
--Correcting incorrect FY20 outcomes for the tranposed table all FYs
SELECT 
    Measure,fiscal_year,
    CASE WHEN measure_datastudio = '9th grade students are low-income and first-generation (80%)' AND fiscal_year = 'FY20' THEN .75 ELSE NATIONAL END AS NATIONAL, --instead of 74%
    CASE 
        WHEN measure_datastudio = 'Staff with full-time tenure of 3+ years in organization (35%)' AND fiscal_year = 'FY20' THEN .38 --instead of 33%
        WHEN measure_datastudio = 'High school capacity enrolled (95%) ' AND fiscal_year = 'FY20' THEN .98 --instead of NULL
        ELSE NOLA 
        END AS NOLA,
    CASE WHEN measure_datastudio = 'Students graduating from college within 6 years (70%)' AND fiscal_year = 'FY20' THEN .67 ELSE NORCAL END AS NORCAL, --instead of 66%
    
FROM `org-scorecard-286421.transposed_tables.org_scorecard_overview_all_fy` 
WHERE measure_datastudio = '9th grade students are low-income and first-generation (80%)' 

--Also update org_scorecard_fy20_overview with values above


/*
--Step #1: Clean up Measure columns for FY21 - remove "fy21"
WITH clean_up_fy21 AS (
SELECT 
Objective
,fiscal_year
,measure_datastudio
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
    WHEN Measure = 'percent_male_hr_fy21' THEN 'percent_male_hr'
    WHEN Measure = 'percent_first_gen_hr_fy21' THEN 'percent_first_gen_hr'
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
,measure_datastudio
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
,measure_datastudio
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
FROM `org-scorecard-286421.transposed_tables.fy21_org_scorecard_outcomes_transposed`

UNION ALL

SELECT
Objective
,Measure
,measure_datastudio
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
FROM `org-scorecard-286421.transposed_tables.org_scorecard_fy20_overview`

--#2 Populate NULL values in column: measure_datastudio
SELECT 
    * EXCEPT (measure_datastudio),
    CASE 
        WHEN Measure = 'percent_6_year_grad_rate' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN 'Students graduating from college within 6 years (70%)'
        WHEN Measure = 'percent_gainful_employment' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN 'Graduates meeting gainful employment standard (85%)'
        WHEN Measure = 'percent_annual_fundraising_target' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN 'annual_fundraising	Annual Fundraising target (100%)'
        WHEN Measure = 'percent_meaningful_employment' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN 'Graduates with meaningful employment (85%)'
        WHEN Measure = 'percent_employment_grad_school' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN 'Graduates with full-time employment or enrolled in graduate school within 6 months of graduation (65%)'
        WHEN Measure = 'percent_tenure' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN 'Staff with full-time tenure of 3+ years in organization (35%)'
        WHEN Measure = 'percent_social_emotional_growth' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN 'Students growing toward average or above social-emotional strengths'
        WHEN Measure = 'percent_matriculated_best_good_situational' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN 'Students matriculating to Best Fit, Good Fit, or Situational Best Fit colleges (50%)'
        WHEN Measure = 'percent_on_track' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN 'Students with enough credits accumulated to graduate in 6 years (80%)'
        WHEN Measure = 'percent_seniors_above_325_and_test_ready' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN 'Seniors with GPA 3.25+ and Composite Ready (55%)'
        WHEN Measure = 'percent_annual_retention' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN 'High school students retained annually (90%)'
        WHEN Measure = 'percent_hs_capacity' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN 'High school capacity enrolled (95%)'
        WHEN Measure = 'percent_male' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN '9th grade students are male (50%)'
        WHEN Measure = 'percent_low_income_first_gen' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN '9th grade students are low-income and first-generation (80%)'
        WHEN Measure = 'percent_mse' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN'Students with meaningful summer experiences (85%)'
        WHEN Measure = 'percent_staff_engagement' AND fiscal_year = 'FY21' AND measure_datastudio IS NULL THEN 'Staff engagement score above average nonprofit benchmark (Y)'
        ELSE measure_datastudio
        END AS measure_datastudio
FROM `org-scorecard-286421.transposed_tables.org_scorecard_overview_all_fy`

*/