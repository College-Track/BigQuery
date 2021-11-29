--Add Objective column and values to table: fy21_org_scorecard_hs_college_transposed
/*CREATE OR REPLACE TABLE `org-scorecard-286421.transposed_tables.fy21_org_scorecard_hs_college_transposed`
OPTIONS
    (
    description="This is a transposed table for college and high school outcomes for the FY21 org scorecard. Table was created wide in SQL (data-studio-260217:performance_mgt.org_scorecard_program_fy21), and transposed manually in excel. Uploaded as a CSV" 
    )
    AS */

    
--#5 populate outcomes into Measures manually added
WITH add_measures AS (
SELECT 
        * EXCEPT (PGC,AUR,BH,CREN,DEN,EPA,NOLA,OAK,SAC,SF,WATTS,DC8,fiscal_year,Objective),
        --HS capacity %, hs capcaity numerator, hs capacity denominator, tenure
        CASE 
            WHEN Measure = 'percent_tenure_fy21' AND PGC IS NULL THEN  .0
            WHEN Measure = 'percent_hs_capacity_fy21' AND PGC IS NULL THEN .82 
            WHEN Measure = 'hs_capacity_numerator' AND PGC IS NULL THEN 146 
            WHEN Measure = 'hs_capacity_denominator' AND PGC IS NULL THEN 177 ELSE PGC END AS PGC,
        CASE 
            WHEN Measure = 'percent_tenure_fy21' AND AUR IS NULL THEN  .25
            WHEN Measure = 'percent_hs_capacity_fy21' AND AUR IS NULL THEN .91 
            WHEN Measure = 'hs_capacity_numerator' AND AUR IS NULL THEN 208 
            WHEN Measure = 'hs_capacity_denominator' AND AUR IS NULL THEN 230 ELSE AUR END AS AUR,
        CASE 
            WHEN Measure = 'percent_tenure_fy21' AND BH IS NULL THEN  .50
            WHEN Measure = 'percent_hs_capacity_fy21' AND BH IS NULL THEN .87 
            WHEN Measure = 'hs_capacity_numerator' AND BH IS NULL THEN 250
            WHEN Measure = 'hs_capacity_denominator' AND BH IS NULL THEN 287 ELSE BH END AS BH,
        CASE 
            WHEN Measure = 'percent_tenure_fy21' AND CREN IS NULL THEN  .0
            WHEN Measure = 'percent_hs_capacity_fy21' AND CREN IS NULL THEN .85 
            WHEN Measure = 'hs_capacity_numerator' AND CREN IS NULL THEN 51 
            WHEN Measure = 'hs_capacity_denominator' AND CREN IS NULL THEN 60 ELSE CREN END AS CREN,
        CASE 
            WHEN Measure = 'percent_tenure_fy21' AND DEN IS NULL THEN  .0
            WHEN Measure = 'percent_hs_capacity_fy21' AND DEN IS NULL THEN .19 
            WHEN Measure = 'hs_capacity_numerator' AND DEN IS NULL THEN 32
            WHEN Measure = 'hs_capacity_denominator' AND DEN IS NULL THEN 170 ELSE DEN END AS DEN,
        CASE 
            WHEN Measure = 'percent_tenure_fy21' AND EPA IS NULL THEN  .0
            WHEN Measure = 'percent_hs_capacity_fy21' AND EPA IS NULL THEN .70 
            WHEN Measure = 'hs_capacity_numerator' AND EPA IS NULL THEN 161
            WHEN Measure = 'hs_capacity_denominator' AND EPA IS NULL THEN 230 ELSE EPA END AS EPA,
        CASE 
            WHEN Measure = 'percent_tenure_fy21' AND NOLA IS NULL THEN  .625
            WHEN Measure = 'percent_hs_capacity_fy21' AND NOLA IS NULL THEN 1.02
            WHEN Measure = 'hs_capacity_numerator' AND NOLA IS NULL THEN 234
            WHEN Measure = 'hs_capacity_denominator' AND NOLA IS NULL THEN 230 ELSE NOLA END AS NOLA,
        CASE 
            WHEN Measure = 'percent_tenure_fy21' AND OAK IS NULL THEN  .778
            WHEN Measure = 'percent_hs_capacity_fy21' AND OAK IS NULL THEN .88 
            WHEN Measure = 'hs_capacity_numerator' AND OAK IS NULL THEN 254
            WHEN Measure = 'hs_capacity_denominator' AND OAK IS NULL THEN 287 ELSE OAK END AS OAK,
        CASE 
            WHEN Measure = 'percent_tenure_fy21' AND SAC IS NULL THEN  .429
            WHEN Measure = 'percent_hs_capacity_fy21' AND SAC IS NULL THEN .81 
            WHEN Measure = 'hs_capacity_numerator' AND SAC IS NULL THEN 185
            WHEN Measure = 'hs_capacity_denominator' AND SAC IS NULL THEN 230 ELSE SAC END AS SAC,
        CASE 
            WHEN Measure = 'percent_tenure_fy21' AND SF IS NULL THEN  .556
            WHEN Measure = 'percent_hs_capacity_fy21' AND SF IS NULL THEN .69 
            WHEN Measure = 'hs_capacity_numerator' AND SF IS NULL THEN 187
            WHEN Measure = 'hs_capacity_denominator' AND SF IS NULL THEN 272 ELSE SF END AS SF,
        CASE 
            WHEN Measure = 'percent_tenure_fy21' AND WATTS IS NULL THEN  1
            WHEN Measure = 'percent_hs_capacity_fy21' AND WATTS IS NULL THEN .87 
            WHEN Measure = 'hs_capacity_numerator' AND WATTS IS NULL THEN 200
            WHEN Measure = 'hs_capacity_denominator' AND WATTS IS NULL THEN 230 ELSE WATTS END AS WATTS,
        CASE 
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
regional_national_percents AS ( --populate hs capacity %s
SELECT 
    * EXCEPT (DC,CO,NOLA_RG,LA,NORCAL,NATIONAL,fiscal_year),
    CASE 
        WHEN Measure = 'percent_hs_capacity_fy21' AND NORCAL IS NULL THEN  787/1019
        WHEN Measure = 'percent_tenure_fy21' AND NORCAL IS NULL THEN  .515
        ELSE NORCAL
        END AS NORCAL,
    CASE 
        WHEN Measure = 'percent_hs_capacity_fy21' AND LA IS NULL THEN 501/577
        WHEN Measure = 'percent_tenure_fy21' AND LA IS NULL THEN  .368
        ELSE LA
        END AS LA,
    CASE 
        WHEN Measure = 'percent_hs_capacity_fy21' AND CO IS NULL THEN 240/400
        WHEN Measure = 'percent_tenure_fy21' AND CO IS NULL THEN  .214
        ELSE CO
        END AS CO,
    CASE 
        WHEN Measure = 'percent_hs_capacity_fy21' AND NOLA_RG IS NULL THEN 230/234
        WHEN Measure = 'percent_tenure_fy21' AND NOLA_RG IS NULL THEN .556 
        ELSE NOLA_RG
        END AS NOLA_RG,
    CASE 
        WHEN Measure = 'percent_hs_capacity_fy21' AND DC IS NULL THEN 268/297
        WHEN Measure = 'percent_tenure_fy21' AND DC IS NULL THEN .077 
        ELSE DC
        END AS DC,
    CASE 
        WHEN Measure = 'percent_hs_capacity_fy21' AND NATIONAL IS NULL THEN 2030/2523
        WHEN Measure = 'percent_tenure_fy21' AND NATIONAL IS NULL THEN .429 
        ELSE NATIONAL
        END AS NATIONAL,
    CASE WHEN Measure = 'percent_hs_capacity_fy21' AND fiscal_year IS NULL THEN 'FY21' ELSE fiscal_year END AS fiscal_year
     
FROM regions_and_national
)
SELECT *
FROM regional_national_percents
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
*/