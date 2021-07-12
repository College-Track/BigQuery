 SELECT
 AT_Name,
 full_name_c,
 AT_Cumulative_GPA,
 previous_as_c,
 current_as_c

 FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
 WHERE college_track_status_c = '15A'
 AND previous_as_c = TRUE