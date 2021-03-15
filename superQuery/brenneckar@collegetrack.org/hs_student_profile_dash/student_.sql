SELECT
  Contact_Id,
  AT_Id,
  AT_Term_GPA,
  Most_Recent_GPA_Cumulative_c,
  most_recent_gpa_semester_c,
  AT_Cumulative_GPA,
  GAS_Name,
  start_date_c
FROM
  `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE
  college_track_status_c IN ('18a', '11A', '12A', '13A')
  AND years_since_hs_grad_c <= 0