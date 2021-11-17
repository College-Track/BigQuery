
CREATE OR REPLACE TABLE FUNCTION  `org-scorecard-286421.aggregate_data.mapObjectiveUDF`(STRING)
AS
  SELECT
    CASE 
            WHEN male_numerator IS NULL THEN 'Objective_1'
            WHEN male_numerator IS NOT NULL THEN 'Objective_1'
            WHEN low_income_first_gen_numerator IS NULL THEN 'Objective_1'
            WHEN low_income_first_gen_numerator IS NOT NULL THEN 'Objective_1'
            WHEN low_income_first_gen_numerator IS NOT NULL THEN 'Objective_1'
            WHEN low_income_first_gen_numerator IS NOT NULL THEN 'Objective_1'
            WHEN low_income_first_gen_numerator IS NOT NULL THEN 'Objective_1'
            WHEN low_income_first_gen_numerator IS NOT NULL THEN 'Objective_1'
            WHEN low_income_first_gen_numerator IS NOT NULL THEN 'Objective_1'
            WHEN low_income_first_gen_numerator IS NOT NULL THEN 'Objective_1'
            WHEN low_income_first_gen_numerator IS NOT NULL THEN 'Objective_1'
            
            WHEN Measure LIKE %social_emotional_academic_foundation% THEN 'Objective_2'
            WHEN Measure LIKE %college_students% THEN 'Objective_3'
  FROM  `org-scorecard-286421.aggregate_data.org_scorecard_program_fy21`
  
  
    THEN recruit_and_retain
    ninth_grade_denominator THEN recruit_and_retain
     = annual_retention_numerator THEN recruit_and_retain
     = ninth_grade_denominator THEN recruit_and_retain
     = annual_retention_denominator THEN recruit_and_retain
     = percent_male_fy21 THEN recruit_and_retain                             
     = percent_low_income_first_gen_fy21 THEN recruit_and_retain
     = percent_annual_retention_fy21 THEN recruit_and_retain     
     = annual_retention_denominator THEN recruit_and_retain
     = percent_male_fy21 THEN recruit_and_retain                             
     = percent_low_income_first_gen_fy21 THEN recruit_and_retain
     = percent_annual_retention_fy21 THEN recruit_and_retain 
     = social_emotional_growth_numerator THEN social_emotional_academic_foundation
     = social_emotional_growth_denominator THEN social_emotional_academic_foundation
     = percent_social_emotional_growth_fy21 THEN social_emotional_academic_foundation
     = above_325_gpa_seniors_numerator THEN social_emotional_academic_foundation
     = senior_325_gpa_and_test_ready_numerator THEN social_emotional_academic_foundation                             
     = senior_325_gpa_only_denominator THEN social_emotional_academic_foundation
     = senior_325_gpa_and_test_ready_denominator THEN social_emotional_academic_foundation    
     = mse_numerator THEN social_emotional_academic_foundation                             
     = mse_denominator THEN social_emotional_academic_foundation
     = percent_social_emotional_growth_fy21 THEN social_emotional_academic_foundation
     = percent_seniors_above_325_fy21 THEN social_emotional_academic_foundation  
     = percent_seniors_above_325_and_test_ready_fy21 THEN social_emotional_academic_foundation  
     = percent_mse_fy21 THEN social_emotional_academic_foundation     
     = matriculated_best_good_situational_numerator THEN college_students                             
     = matriculation_senior_denominator THEN college_students
     = on_track_numerator THEN college_students     
     = on_track_denominator THEN college_students
     = six_yr_grad_rate_numerator THEN college_students                             
     = grade_rate_6_years_current_class_denom THEN college_students
     = percent_matriculate_best_good_situational_fy21 THEN college_students         
     = percent_on_track_fy21 THEN college_students  
     = percent_6_year_grad_rate_fy21 THEN college_students