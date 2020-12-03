SELECT Contact_Id, AT_Id, AT_Grade_c, gpa_cumulative_c, gpa_semester_cumulative_c
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE college_track_status_c IN ('11A')
LIMIT 1000