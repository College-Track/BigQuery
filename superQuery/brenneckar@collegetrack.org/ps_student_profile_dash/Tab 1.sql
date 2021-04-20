SELECT
  Contact_Id,
  AT_Id,
  AT_Term_GPA,
  Most_Recent_GPA_Cumulative_c,
  most_recent_gpa_semester_c,
  AT_Cumulative_GPA,
  GAS_Name,
  start_date_c,
  attendance_rate_c,
  current_as_c,
  attended_workshops_c,
  enrolled_sessions_c,
  Cumulative_Credits_Awarded_All_Terms_c/100 AS Cumulative_Credits_Awarded_All_Terms_c,
 
FROM
  `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE
  college_track_status_c IN ('15A', '16A')
  AND indicator_completed_ct_hs_program_c = true
  AND start_date_c <= CURRENT_DATE() 
  AND AT_Record_Type_Name = "College/University Semester"