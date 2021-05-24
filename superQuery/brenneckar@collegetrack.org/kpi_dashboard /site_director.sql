SELECT
DISTINCT 
Contact_Id
site_short, 
site_c,
credit_accumulation_pace_c,
current_enrollment_status_c,
college_track_status_c
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE AT_Grade_c = 'Year 1'
AND AT_Enrollment_Status_c != 'Approved Gap Year'
AND years_since_hs_grad_c <= 6
AND indicator_completed_ct_hs_program_c = true