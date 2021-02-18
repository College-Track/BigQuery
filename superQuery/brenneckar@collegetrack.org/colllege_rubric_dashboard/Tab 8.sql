SELECT 
-- Advising_Rubric_Academic_Readiness_v_2_c,
-- Advising_Rubric_Academic_Readiness_c,
GAS_Name,
GAS_Start_Date,
COUNT(Contact_Id)
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE Advising_Rubric_Academic_Readiness_c IS NOT NULL AND Advising_Rubric_Academic_Readiness_v_2_c IS NULL
GROUP BY 
GAS_Name,
GAS_Start_Date
-- Advising_Rubric_Academic_Readiness_v_2_c
-- Advising_Rubric_Academic_Readiness_c
ORDER BY GAS_Start_Date