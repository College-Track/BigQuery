SELECT 
Advising_Rubric_Academic_Readiness_v_2_c,
-- Advising_Rubric_Academic_Readiness_c,
-- GAS_Name,
COUNT(Contact_Id)
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE Advising_Rubric_Academic_Readiness_c IS NOT NULL AND Advising_Rubric_Academic_Readiness_v_2_c IS NULL
GROUP BY 
-- GAS_Name,
Advising_Rubric_Academic_Readiness_v_2_c
-- Advising_Rubric_Academic_Readiness_c