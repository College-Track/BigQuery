--Creating org scorecard fy21 transposed table - all outcomes
CREATE OR REPLACE TABLE `org-scorecard-286421.transposed_tables.fy21_org_scorecard_outcomes_transposed`
OPTIONS
    (
    description="This is a tranposed table of all fy21 org scorecard outcomes. Percent entered manually for measures calculated outside of SQL" 
    )
    AS 


--#7 Populate values in new column: measure_datastudio
SELECT 
    * EXCEPT (measure_datastudio),
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
   
FROM `org-scorecard-286421.transposed_tables.fy21_org_scorecard_outcomes_transposed`

/*
--#1 Add Measures shared from other teams, or pulled outside of Salesforce in FY21 (HR data, Fundraising, Alumni data, HS Capacity)
INSERT INTO  `org-scorecard-286421.transposed_tables.fy21_org_scorecard_hs_college_transposed` (Measure) VALUES  
                                                                        ('percent_employment_grad_school_fy21')
                                                                        ,('percent_gainful_employment_fy21')
                                                                        ,('percent_meaningful_employment')
                                                                        ,('staff_engagement_fy21')
                                                                        ,('percent_non_white_hr_fy21')
                                                                        ,('percent_first_gen_hr_fy21')
                                                                        ,('percent_lgbtq_hr_fy21')
                                                                        ,('percent_tenure_fy21')
                                                                        ,('percent_male_hr_fy21')
                                                                        ,('percent_annual_fundraising_target_fy21')
                                                                        ,('hs_capacity_fy21')

                                                                       ;
--#2 Adding Objective to each Measure
SELECT 
            *,
            CASE WHEN Measure IN    (
                                    'male_numerator'
                                    ,'low_income_first_gen_numerator'
                                    ,'ninth_grade_denominator'
                                    ,'annual_retention_numerator'
                                    ,'annual_retention_denominator'
                                    ,'percent_male_fy21'
                                    ,'percent_low_income_first_gen_fy21'
                                    ,'percent_annual_retention_fy21'
                                    )
                THEN 'Objective_1' 
                WHEN Measure IN    (
                                    'social_emotional_growth_numerator'
                                    ,'social_emotional_growth_denominator'
                                    ,'above_325_gpa_seniors_numerator'
                                    ,'senior_325_gpa_and_test_ready_numerator'
                                    ,'senior_325_gpa_only_denominator'
                                    ,'senior_325_gpa_and_test_ready_denominator'
                                    ,'mse_numerator'
                                    ,'mse_denominator'
                                    ,'percent_social_emotional_growth_fy21'
                                    ,'percent_seniors_above_325_fy21'
                                    ,'percent_seniors_above_325_and_test_ready_fy21'
                                    ,'percent_mse_fy21'
                                    )
                THEN 'Objective_2'
                WHEN Measure IN    (
                                    'matriculated_best_good_situational_numerator'
                                    ,'matriculation_senior_denominator'
                                    ,'on_track_numerator'
                                    ,'on_track_denominator'
                                    ,'six_yr_grad_rate_numerator'
                                    ,'grade_rate_6_years_current_class_denom'
                                    ,'percent_matriculated_best_good_situational_fy21'
                                    ,'percent_on_track_fy21'
                                    ,'percent_6_year_grad_rate_fy21'
                                    )
                THEN 'Objective_3' 
                ELSE NULL 
                END AS Objective
            
FROM `org-scorecard-286421.transposed_tables.fy21_org_scorecard_hs_college_transposed`


--#3 Add Objective for each newly added Measure provided by other teams, or calculated outside of BQ    
SELECT 
        * EXCEPT (Objective),
        CASE 
            WHEN Measure = 'percent_employment_grad_school_fy21' THEN 'Objective_4'
            WHEN Measure = 'percent_gainful_employment_fy21' THEN 'Objective_4'
            WHEN Measure = 'percent_meaningful_employment' THEN 'Objective_4'
            WHEN Measure = 'percent_lgbtq_hr_fy21' THEN 'Objective_5'
            WHEN Measure = 'percent_non_white_hr_fy21' THEN 'Objective_5'
            WHEN Measure = 'percent_first_gen_hr_fy21' THEN 'Objective_5'
            WHEN Measure = 'percent_male_hr_fy21' THEN 'Objective_5'
            WHEN Measure = 'percent_tenure_fy21' THEN 'Objective_5'
            WHEN Measure = 'percent_staff_engagement_fy21' THEN 'Objective_5'
            WHEN Measure = 'percent_hs_capacity_fy21' THEN 'Objective_6'
            WHEN Measure = 'percent_annual_fundraising_target_fy21' THEN 'Objective_6'
        ELSE Objective
        END AS Objective,
        
FROM `org-scorecard-286421.transposed_tables.fy21_org_scorecard_hs_college_transposed`

--#4 Add NATIONAL_AS_LOCATION as a column for HR outcomes
ALTER TABLE  `org-scorecard-286421.transposed_tables.fy21_org_scorecard_hs_college_transposed`
ADD COLUMN NATIONAL_AS_LOCATION FLOAT64

#6 Add Columns: NUM AND DENOM FOR HS CAPACITY
INSERT INTO  `org-scorecard-286421.transposed_tables.fy21_org_scorecard_hs_college_transposed` (Measure) VALUES  
                                                                        ('hs_capacity_numerator')
                                                                        ,('hs_capacity_denominator')

--#7 populate outcomes into Measures manually added
WITH add_measures AS (
SELECT 
        * EXCEPT (PGC,AUR,BH,CREN,DEN,EPA,NOLA,OAK,SAC,SF,WATTS,DC8,fiscal_year,Objective),
        --HS capacity %, hs capcaity numerator, hs capacity denominator, tenure, staff engagement
        CASE 
            WHEN Measure = 'percent_staff_engagement_fy21' AND PGC IS NULL THEN .35
            WHEN Measure = 'percent_tenure_fy21' AND PGC IS NULL THEN  .0
            WHEN Measure = 'percent_hs_capacity_fy21' AND PGC IS NULL THEN .82 
            WHEN Measure = 'hs_capacity_numerator' AND PGC IS NULL THEN 146 
            WHEN Measure = 'hs_capacity_denominator' AND PGC IS NULL THEN 177 ELSE PGC END AS PGC,
        CASE 
            WHEN Measure = 'percent_employment_grad_school_fy21' AND AUR IS NULL THEN .5
            WHEN Measure = 'percent_gainful_employment_fy21' AND AUR IS NULL THEN .54
            WHEN Measure = 'percent_meaningful_employment' AND AUR IS NULL THEN .73
            WHEN Measure = 'percent_staff_engagement_fy21' AND AUR IS NULL THEN .90
            WHEN Measure = 'percent_tenure_fy21' AND AUR IS NULL THEN  .25
            WHEN Measure = 'percent_hs_capacity_fy21' AND AUR IS NULL THEN .91 
            WHEN Measure = 'hs_capacity_numerator' AND AUR IS NULL THEN 208 
            WHEN Measure = 'hs_capacity_denominator' AND AUR IS NULL THEN 230 ELSE AUR END AS AUR,
        CASE 
            WHEN Measure = 'percent_employment_grad_school_fy21' AND BH IS NULL THEN .5
            WHEN Measure = 'percent_gainful_employment_fy21' AND BH IS NULL THEN .75
            WHEN Measure = 'percent_meaningful_employment' AND BH IS NULL THEN .89
            WHEN Measure = 'percent_staff_engagement_fy21' AND BH IS NULL THEN .89
            WHEN Measure = 'percent_tenure_fy21' AND BH IS NULL THEN  .50
            WHEN Measure = 'percent_hs_capacity_fy21' AND BH IS NULL THEN .87 
            WHEN Measure = 'hs_capacity_numerator' AND BH IS NULL THEN 250
            WHEN Measure = 'hs_capacity_denominator' AND BH IS NULL THEN 287 ELSE BH END AS BH,
        CASE 
            WHEN Measure = 'percent_staff_engagement_fy21' AND CREN IS NULL THEN .87
            WHEN Measure = 'percent_tenure_fy21' AND CREN IS NULL THEN  .0
            WHEN Measure = 'percent_hs_capacity_fy21' AND CREN IS NULL THEN .85 
            WHEN Measure = 'hs_capacity_numerator' AND CREN IS NULL THEN 51 
            WHEN Measure = 'hs_capacity_denominator' AND CREN IS NULL THEN 60 ELSE CREN END AS CREN,
        CASE 
            WHEN Measure = 'percent_staff_engagement_fy21' AND DEN IS NULL THEN .93
            WHEN Measure = 'percent_tenure_fy21' AND DEN IS NULL THEN  .0
            WHEN Measure = 'percent_hs_capacity_fy21' AND DEN IS NULL THEN .19 
            WHEN Measure = 'hs_capacity_numerator' AND DEN IS NULL THEN 32
            WHEN Measure = 'hs_capacity_denominator' AND DEN IS NULL THEN 170 ELSE DEN END AS DEN,
        CASE 
            WHEN Measure = 'percent_employment_grad_school_fy21' AND EPA IS NULL THEN .63
            WHEN Measure = 'percent_gainful_employment_fy21' AND EPA IS NULL THEN .77
            WHEN Measure = 'percent_meaningful_employment' AND EPA IS NULL THEN .83
            WHEN Measure = 'percent_staff_engagement_fy21' AND EPA IS NULL THEN .77
            WHEN Measure = 'percent_tenure_fy21' AND EPA IS NULL THEN  .0
            WHEN Measure = 'percent_hs_capacity_fy21' AND EPA IS NULL THEN .70 
            WHEN Measure = 'hs_capacity_numerator' AND EPA IS NULL THEN 161
            WHEN Measure = 'hs_capacity_denominator' AND EPA IS NULL THEN 230 ELSE EPA END AS EPA,
        CASE 
            WHEN Measure = 'percent_employment_grad_school_fy21' AND NOLA IS NULL THEN .57
            WHEN Measure = 'percent_gainful_employment_fy21' AND NOLA IS NULL THEN .34
            WHEN Measure = 'percent_meaningful_employment' AND NOLA IS NULL THEN .79
            WHEN Measure = 'percent_staff_engagement_fy21' AND NOLA IS NULL THEN 1
            WHEN Measure = 'percent_tenure_fy21' AND NOLA IS NULL THEN  .625
            WHEN Measure = 'percent_hs_capacity_fy21' AND NOLA IS NULL THEN 1.02
            WHEN Measure = 'hs_capacity_numerator' AND NOLA IS NULL THEN 234
            WHEN Measure = 'hs_capacity_denominator' AND NOLA IS NULL THEN 230 ELSE NOLA END AS NOLA,
        CASE 
            WHEN Measure = 'percent_employment_grad_school_fy21' AND OAK IS NULL THEN .56
            WHEN Measure = 'percent_gainful_employment_fy21' AND OAK IS NULL THEN .77
            WHEN Measure = 'percent_meaningful_employment' AND OAK IS NULL THEN .82
            WHEN Measure = 'percent_staff_engagement_fy21' AND OAK IS NULL THEN .53
            WHEN Measure = 'percent_tenure_fy21' AND OAK IS NULL THEN  .778
            WHEN Measure = 'percent_hs_capacity_fy21' AND OAK IS NULL THEN .88 
            WHEN Measure = 'hs_capacity_numerator' AND OAK IS NULL THEN 254
            WHEN Measure = 'hs_capacity_denominator' AND OAK IS NULL THEN 287 ELSE OAK END AS OAK,
        CASE 
            WHEN Measure = 'percent_staff_engagement_fy21' AND SAC IS NULL THEN .83
            WHEN Measure = 'percent_tenure_fy21' AND SAC IS NULL THEN  .429
            WHEN Measure = 'percent_hs_capacity_fy21' AND SAC IS NULL THEN .81 
            WHEN Measure = 'hs_capacity_numerator' AND SAC IS NULL THEN 185
            WHEN Measure = 'hs_capacity_denominator' AND SAC IS NULL THEN 230 ELSE SAC END AS SAC,
        CASE 
            WHEN Measure = 'percent_employment_grad_school_fy21' AND SF IS NULL THEN .27
            WHEN Measure = 'percent_gainful_employment_fy21' AND SF IS NULL THEN .70
            WHEN Measure = 'percent_meaningful_employment' AND SF IS NULL THEN .71
            WHEN Measure = 'percent_staff_engagement_fy21' AND SF IS NULL THEN .35
            WHEN Measure = 'percent_tenure_fy21' AND SF IS NULL THEN  .556
            WHEN Measure = 'percent_hs_capacity_fy21' AND SF IS NULL THEN .69 
            WHEN Measure = 'hs_capacity_numerator' AND SF IS NULL THEN 187
            WHEN Measure = 'hs_capacity_denominator' AND SF IS NULL THEN 272 ELSE SF END AS SF,
        CASE 
            WHEN Measure = 'percent_staff_engagement_fy21' AND WATTS IS NULL THEN WATTS
            WHEN Measure = 'percent_tenure_fy21' AND WATTS IS NULL THEN  1
            WHEN Measure = 'percent_hs_capacity_fy21' AND WATTS IS NULL THEN .87 
            WHEN Measure = 'hs_capacity_numerator' AND WATTS IS NULL THEN 200
            WHEN Measure = 'hs_capacity_denominator' AND WATTS IS NULL THEN 230 ELSE WATTS END AS WATTS,
        CASE 
            WHEN Measure = 'percent_staff_engagement_fy21' AND DC8 IS NULL THEN .53
            WHEN Measure = 'percent_tenure_fy21' AND DC8 IS NULL THEN  .0
            WHEN Measure = 'percent_hs_capacity_fy21' AND DC8 IS NULL THEN 1.02 
            WHEN Measure = 'hs_capacity_numerator' AND DC8 IS NULL THEN 122
            WHEN Measure = 'hs_capacity_denominator' AND DC8 IS NULL THEN 120 ELSE DC8 END AS DC8,

        
        CASE WHEN Measure IN ('hs_capacity_numerator','hs_capacity_denominator') AND Objective IS NULL THEN 'Objective_6' ELSE Objective END AS Objective,
        CASE 
            WHEN Measure IN ('hs_capacity_numerator','hs_capacity_denominator') AND fiscal_year IS NULL THEN 'FY21' 
            WHEN Measure LIKE '%fy21%' AND fiscal_year IS NULL THEN 'FY21' ELSE fiscal_year END AS fiscal_year
            
        --Add regional and National totals
         
    FROM  `org-scorecard-286421.transposed_tables.fy21_org_scorecard_hs_college_transposed`
),
regions_and_national AS ( --Adding regional and nat'l num/denom for hs capacity, mses
SELECT 
    * EXCEPT (DC,CO,NOLA_RG,LA,NORCAL,NATIONAL),
    
    --hs capacity regional sums
    CASE 
        WHEN Measure = 'percent_staff_engagement_fy21' AND NORCAL IS NULL THEN .61
        WHEN Measure = 'hs_capacity_denominator' AND NORCAL IS NULL THEN EPA+OAK+SF+SAC 
        WHEN Measure = 'hs_capacity_numerator' AND NORCAL IS NULL THEN EPA+OAK+SF+SAC
        WHEN Measure = 'mse_numerator' AND NORCAL IS NULL THEN EPA+OAK+SF+SAC 
        WHEN Measure = 'mse_denominator' AND NORCAL IS NULL THEN EPA+OAK+SF+SAC
        WHEN Measure = 'above_325_gpa_seniors_numerator' AND NORCAL IS NULL THEN EPA+OAK+SF+SAC 
        WHEN Measure = 'senior_325_gpa_only_denominator' AND NORCAL IS NULL THEN EPA+OAK+SF+SAC
        WHEN Measure = 'senior_325_gpa_and_test_ready_numerator' AND NORCAL IS NULL THEN EPA+OAK+SF+SAC 
        WHEN Measure = 'senior_325_gpa_and_test_ready_denominator' AND NORCAL IS NULL THEN EPA+OAK+SF+SAC
        ELSE NORCAL
        END AS NORCAL,
    CASE 
        WHEN Measure = 'percent_staff_engagement_fy21' AND LA IS NULL THEN .79
        WHEN Measure = 'hs_capacity_denominator' AND LA IS NULL THEN BH+WATTS+CREN 
        WHEN Measure = 'hs_capacity_numerator' AND LA IS NULL THEN BH+WATTS+CREN 
        WHEN Measure = 'mse_numerator' AND LA IS NULL THEN BH+WATTS+CREN 
        WHEN Measure = 'mse_denominator' AND LA IS NULL THEN BH+WATTS+CREN 
        WHEN Measure = 'above_325_gpa_seniors_numerator' AND LA IS NULL THEN BH+WATTS
        WHEN Measure = 'senior_325_gpa_only_denominator' AND LA IS NULL THEN BH+WATTS
        WHEN Measure = 'senior_325_gpa_and_test_ready_numerator' AND LA IS NULL THEN BH+WATTS 
        WHEN Measure = 'senior_325_gpa_and_test_ready_denominator' AND LA IS NULL THEN BH+WATTS 
        ELSE LA
        END AS LA,
    CASE 
        WHEN Measure = 'percent_staff_engagement_fy21' AND CO IS NULL THEN .75
        WHEN Measure = 'hs_capacity_denominator' AND CO IS NULL THEN AUR+DEN
        WHEN Measure = 'hs_capacity_numerator' AND CO IS NULL THEN AUR+DEN
        WHEN Measure = 'mse_numerator' AND CO IS NULL THEN AUR+DEN
        WHEN Measure = 'mse_denominator' AND CO IS NULL THEN AUR+DEN
        WHEN Measure = 'above_325_gpa_seniors_numerator' AND CO IS NULL THEN AUR+DEN
        WHEN Measure = 'senior_325_gpa_only_denominator' AND CO IS NULL THEN AUR+DEN
        WHEN Measure = 'senior_325_gpa_and_test_ready_numerator' AND CO IS NULL THEN AUR+DEN
        WHEN Measure = 'senior_325_gpa_and_test_ready_denominator' AND CO IS NULL THEN AUR+DEN
        ELSE CO
        END AS CO,
    CASE 
        WHEN Measure = 'percent_staff_engagement_fy21' AND NOLA_RG IS NULL THEN 1
        WHEN Measure = 'hs_capacity_denominator' AND NOLA_RG IS NULL THEN NOLA
        WHEN Measure = 'hs_capacity_numerator' AND NOLA_RG IS NULL THEN NOLA
        WHEN Measure = 'mse_numerator' AND NOLA_RG IS NULL THEN NOLA
        WHEN Measure = 'mse_denominator' AND NOLA_RG IS NULL THEN NOLA
        WHEN Measure = 'above_325_gpa_seniors_numerator' AND NOLA_RG IS NULL THEN NOLA
        WHEN Measure = 'senior_325_gpa_only_denominator' AND NOLA_RG IS NULL THEN NOLA
        WHEN Measure = 'senior_325_gpa_and_test_ready_numerator' AND NOLA_RG IS NULL THEN NOLA
        WHEN Measure = 'senior_325_gpa_and_test_ready_denominator' AND NOLA_RG IS NULL THEN NOLA
        ELSE NOLA_RG
        END AS NOLA_RG,
    CASE 
        WHEN Measure = 'percent_staff_engagement_fy21' AND DC IS NULL THEN .48
        WHEN Measure = 'hs_capacity_denominator' AND DC IS NULL THEN PGC+DC8
        WHEN Measure = 'hs_capacity_numerator' AND DC IS NULL THEN PGC+DC8
        WHEN Measure = 'mse_numerator' AND DC IS NULL THEN PGC+DC8
        WHEN Measure = 'mse_denominator' AND DC IS NULL THEN PGC+DC8
        ELSE DC
        END AS DC,
    CASE 
        WHEN Measure = 'hs_capacity_denominator' AND NATIONAL IS NULL THEN EPA+OAK+SF+SAC+BH+WATTS+CREN+AUR+DEN+NOLA+PGC+DC8
        WHEN Measure = 'hs_capacity_numerator' AND NATIONAL IS NULL THEN EPA+OAK+SF+SAC+BH+WATTS+CREN+AUR+DEN+NOLA+PGC+DC8
        WHEN Measure = 'mse_numerator' AND NATIONAL IS NULL THEN EPA+OAK+SF+SAC+BH+WATTS+CREN+AUR+DEN+NOLA+PGC+DC8
        WHEN Measure = 'mse_denominator' AND NATIONAL IS NULL THEN EPA+OAK+SF+SAC+BH+WATTS+CREN+AUR+DEN+NOLA+PGC+DC8
        WHEN Measure = 'above_325_gpa_seniors_numerator' AND NATIONAL IS NULL THEN EPA+OAK+SF+SAC+BH+WATTS+AUR+DEN+NOLA
        WHEN Measure = 'senior_325_gpa_only_denominator' AND NATIONAL IS NULL THEN EPA+OAK+SF+SAC+BH+WATTS+AUR+DEN+NOLA
        WHEN Measure = 'senior_325_gpa_and_test_ready_numerator' AND NATIONAL IS NULL THEN EPA+OAK+SF+SAC+BH+WATTS+AUR+DEN+NOLA
        WHEN Measure = 'senior_325_gpa_and_test_ready_denominator' AND NATIONAL IS NULL THEN EPA+OAK+SF+SAC+BH+WATTS+AUR+DEN+NOLA
        ELSE NATIONAL
        END AS NATIONAL,
    
FROM add_measures
),
regional_national_percents AS ( --populate hs capacity %s, mse %, staff engagement, tenure, employment/grad school, gainful employment, meaningful employment
SELECT 
    * EXCEPT (DC,CO,NOLA_RG,LA,NORCAL,NATIONAL,NATIONAL_AS_LOCATION,fiscal_year),
    CASE 
        WHEN Measure = 'percent_seniors_above_325_fy21' AND NORCAL IS NULL THEN  .692
        WHEN Measure = 'percent_seniors_above_325_and_test_ready_fy21' AND NORCAL IS NULL THEN  .292
        WHEN Measure = 'percent_mse_fy21' AND NORCAL IS NULL THEN  .923
        WHEN Measure = 'percent_annual_fundraising_target_fy21' AND NORCAL IS NULL THEN  1.06
        WHEN Measure = 'percent_hs_capacity_fy21' AND NORCAL IS NULL THEN  787/1019
        WHEN Measure = 'percent_tenure_fy21' AND NORCAL IS NULL THEN  .515
        WHEN Measure = 'percent_employment_grad_school_fy21' AND NORCAL IS NULL THEN .5
        WHEN Measure = 'percent_gainful_employment_fy21' AND NORCAL IS NULL THEN .75
        WHEN Measure = 'percent_meaningful_employment' AND NORCAL IS NULL THEN .8
        ELSE NORCAL
        END AS NORCAL,
    CASE 
        WHEN Measure = 'percent_seniors_above_325_fy21' AND LA IS NULL THEN  .587
        WHEN Measure = 'percent_seniors_above_325_and_test_ready_fy21' AND LA IS NULL THEN  .238
        WHEN Measure = 'percent_mse_fy21' AND LA IS NULL THEN  .505
        WHEN Measure = 'percent_annual_fundraising_target_fy21' AND LA IS NULL THEN  .99
        WHEN Measure = 'percent_hs_capacity_fy21' AND LA IS NULL THEN 501/577
        WHEN Measure = 'percent_tenure_fy21' AND LA IS NULL THEN  .368
        WHEN Measure = 'percent_employment_grad_school_fy21' AND LA IS NULL THEN .5
        WHEN Measure = 'percent_gainful_employment_fy21' AND LA IS NULL THEN .75
        WHEN Measure = 'percent_meaningful_employment' AND LA IS NULL THEN .89
        ELSE LA
        END AS LA,
    CASE 
        WHEN Measure = 'percent_seniors_above_325_fy21' AND CO IS NULL THEN  .852
        WHEN Measure = 'percent_seniors_above_325_and_test_ready_fy21' AND CO IS NULL THEN  .698
        WHEN Measure = 'percent_mse_fy21' AND CO IS NULL THEN  .855
        WHEN Measure = 'percent_annual_fundraising_target_fy21' AND CO IS NULL THEN  .78
        WHEN Measure = 'percent_hs_capacity_fy21' AND CO IS NULL THEN 240/400
        WHEN Measure = 'percent_tenure_fy21' AND CO IS NULL THEN  .214
        WHEN Measure = 'percent_employment_grad_school_fy21' AND CO IS NULL THEN .5
        WHEN Measure = 'percent_gainful_employment_fy21' AND CO IS NULL THEN .54
        WHEN Measure = 'percent_meaningful_employment' AND CO IS NULL THEN .73
        ELSE CO
        END AS CO,
    CASE 
        WHEN Measure = 'percent_hs_capacity_fy21' AND NOLA_RG IS NULL THEN 230/234
        WHEN Measure = 'percent_tenure_fy21' AND NOLA_RG IS NULL THEN .556 
        WHEN Measure = 'percent_annual_fundraising_target_fy21' AND NOLA_RG IS NULL THEN  1.32
        WHEN Measure = 'percent_employment_grad_school_fy21' AND NOLA_RG IS NULL THEN .57
        WHEN Measure = 'percent_gainful_employment_fy21' AND NOLA_RG IS NULL THEN .34
        WHEN Measure = 'percent_meaningful_employment' AND NOLA_RG IS NULL THEN .79
        ELSE NOLA_RG
        END AS NOLA_RG,
    CASE 
        WHEN Measure = 'percent_mse_fy21' AND DC IS NULL THEN  .471
        WHEN Measure = 'percent_annual_fundraising_target_fy21' AND DC IS NULL THEN  1.09
        WHEN Measure = 'percent_hs_capacity_fy21' AND DC IS NULL THEN 268/297
        WHEN Measure = 'percent_tenure_fy21' AND DC IS NULL THEN .077 
        ELSE DC
        END AS DC,
    CASE 
        WHEN Measure = 'percent_first_gen_hr_fy21' AND NATIONAL IS NULL THEN .704
        WHEN Measure = 'percent_lgbtq_hr_fy21' AND NATIONAL IS NULL THEN .111
        WHEN Measure = 'percent_male_hr_fy21' AND NATIONAL IS NULL THEN .296
        WHEN Measure = 'percent_non_white_hr_fy21' AND NATIONAL IS NULL THEN .741
        WHEN Measure = 'percent_hs_capacity_fy21' AND NATIONAL IS NULL THEN 2030/2523
        WHEN Measure = 'percent_tenure_fy21' AND NATIONAL IS NULL THEN .429 
        WHEN Measure = 'percent_staff_engagement_fy21' AND NATIONAL IS NULL THEN .71
        WHEN Measure = 'percent_employment_grad_school_fy21' AND NATIONAL IS NULL THEN .51
        WHEN Measure = 'percent_gainful_employment_fy21' AND NATIONAL IS NULL THEN .67
        WHEN Measure = 'percent_meaningful_employment' AND NATIONAL IS NULL THEN .79
        WHEN Measure = 'percent_annual_fundraising_target_fy21' AND NATIONAL IS NULL THEN  1.04
        ELSE NATIONAL
        END AS NATIONAL,
    CASE 
        WHEN Measure = 'percent_hs_capacity_fy21' AND NATIONAL_AS_LOCATION IS NULL THEN 2030/2523
        WHEN Measure = 'percent_tenure_fy21' AND NATIONAL_AS_LOCATION IS NULL THEN .429 
        WHEN Measure = 'percent_staff_engagement_fy21' AND NATIONAL_AS_LOCATION IS NULL THEN .75
        ELSE NATIONAL_AS_LOCATION
        END AS NATIONAL_AS_LOCATION,
        
    CASE 
        WHEN Measure = 'percent_hs_capacity_fy21' AND fiscal_year IS NULL THEN 'FY21' 
        WHEN Measure = 'percent_meaningful_employment' AND fiscal_year IS NULL THEN 'FY21' 
        ELSE fiscal_year END AS fiscal_year
     
FROM regions_and_national
)
SELECT *
FROM regional_national_percents

--#7 Add measure_datastudio column
ALTER TABLE `org-scorecard-286421.transposed_tables.fy21_org_scorecard_outcomes_transposed`
ADD COLUMN measure_datastudio STRING; 
*/