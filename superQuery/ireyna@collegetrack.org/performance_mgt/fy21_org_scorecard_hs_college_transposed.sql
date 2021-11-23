--Add Objective column and values to table: fy21_org_scorecard_hs_college_transposed
/*CREATE OR REPLACE TABLE `org-scorecard-286421.transposed_tables.fy21_org_scorecard_hs_college_transposed`
OPTIONS
    (
    description="This is a transposed table for college and high school outcomes for the FY21 org scorecard. Table was created wide in SQL (data-studio-260217:performance_mgt.org_scorecard_program_fy21), and transposed manually in excel. Uploaded as a CSV" 
    )
    AS */

    
--#5 populate outcomes into Measures manually added
SELECT 
        * EXCEPT (PGC,AUR,BH,CREN,DEN,EPA,NOLA,OAK,SAC,SF,WATTS,DC8),
        CASE WHEN Measure = 'percent_hs_capacity_fy21' AND PGC IS NULL THEN .82 END AS PGC,
        CASE WHEN Measure = 'percent_hs_capacity_fy21' AND AUR IS NULL THEN .91 END AS AUR,
        CASE WHEN Measure = 'percent_hs_capacity_fy21' AND BH IS NULL THEN .87 END AS BH,
        CASE WHEN Measure = 'percent_hs_capacity_fy21' AND CREN IS NULL THEN .85 END AS CREN,
        CASE WHEN Measure = 'percent_hs_capacity_fy21' AND DEN IS NULL THEN .19 END AS DEN,
        CASE WHEN Measure = 'percent_hs_capacity_fy21' AND EPA IS NULL THEN .70 END AS EPA,
        CASE WHEN Measure = 'percent_hs_capacity_fy21' AND NOLA IS NULL THEN 1.02 END AS NOLA,
        CASE WHEN Measure = 'percent_hs_capacity_fy21' AND OAK IS NULL THEN .88 END AS OAK,
        CASE WHEN Measure = 'percent_hs_capacity_fy21' AND SAC IS NULL THEN .81 END AS SAC,
        CASE WHEN Measure = 'percent_hs_capacity_fy21' AND SF IS NULL THEN .69 END AS SF,
        CASE WHEN Measure = 'percent_hs_capacity_fy21' AND WATTS IS NULL THEN .87 END AS WATTS,
        CASE WHEN Measure = 'percent_hs_capacity_fy21' AND DC8 IS NULL THEN 1.02 END AS DC8,
FROM `org-scorecard-286421.transposed_tables.fy21_org_scorecard_hs_college_transposed`


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

*/