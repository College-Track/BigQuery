SELECT 
Contact_Id,
Advising_Rubric_Academic_Readiness_c
advising_rubric_academic_readiness_v_2_c,
advising_rubric_career_readiness_c,
advising_rubric_career_readiness_v_2_c,
advising_rubric_financial_success_c,
advising_rubric_financial_success_v_2_c,
advising_rubric_wellness_c,
advising_rubric_wellness_v_2_c
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE advising_rubric_wellness_v_2_c IS NOT NULL