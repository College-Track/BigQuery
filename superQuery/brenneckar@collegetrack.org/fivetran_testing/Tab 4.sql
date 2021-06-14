SELECT DISTINCT GAS_Name, AT_Record_Type_Name, gpa_required_date, next_gpa_required_date, current_valid_gpa_term
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE term_c = 'Winter'
AND AY_Name ='AY 2020-21'
LIMIT 100