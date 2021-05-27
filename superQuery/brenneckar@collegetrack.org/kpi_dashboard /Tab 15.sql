SELECT
  site_short,
  Class_Attendance_Id,
  Outcome_c
FROM
  `data-warehouse-289815.salesforce_clean.class_template` CT
 WHERE Outcome_c = "Scheduled"
 AND current_as_c = true
  AND is_deleted = false