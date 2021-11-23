--Add Objective column and values to table: fy21_org_scorecard_hs_college_transposed
CREATE OR REPLACE TABLE `org-scorecard-286421.transposed_tables.fy21_org_scorecard_hs_college_transposed`
OPTIONS
    (
    description="This is a transposed table for college and high school outcomes for the FY21 org scorecard. Table was created wide in SQL (data-studio-260217:performance_mgt.org_scorecard_program_fy21), and transposed manually in excel. Uploaded as a CSV" 
    )
    AS 
    
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

