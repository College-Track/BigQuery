SELECT DISTINCT GAS_Name, AT_Record_Type_Name, gpa_required_date, next_gpa_required_date, current_valid_gpa_term
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE college_track_status_c IN ('11A')
AND term_c = 'Spring'
LIMIT 100