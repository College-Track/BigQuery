SELECT
  Contact_Id,
  Full_Name_c,
  site,
  HIGH_SCHOOL_GRADUATING_CLASS_c,
  Indicator_High_Risk_for_Dismissal_c,
  Indicator_Low_Income_c,
  Ethnic_background_c,
  First_Generation_c,
  College_Track_Status_c,
  status.Status,
  Global_Academic_Semester_c,
  Indicator_Student_on_Intervention_c,
  Composite_Readiness_Most_Recent_c,
  REPLACE(GAT.Name, ' (Semester)', '') AS Academic_Term,
  region,
  GPA_Bucket_running_cumulative_c,
  Student_c,
  GPA_prev_semester_cumulative_c,
  Indicator_Sem_Attendance_Above_80_c,
  Indicator_Sem_Attendance_Below_65_c,
  CASE
    WHEN GPA_prev_semester_cumulative_c < 2.5 THEN '2.49 or less'
    WHEN GPA_prev_semester_cumulative_c >= 2.5
  AND GPA_prev_semester_cumulative_c < 2.75 THEN '2.5 - 2.74'
    WHEN GPA_prev_semester_cumulative_c >= 2.75 AND GPA_prev_semester_cumulative_c < 3 THEN '2.75 - 2.99'
    WHEN GPA_prev_semester_cumulative_c >= 3
  AND GPA_prev_semester_cumulative_c < 3.5 THEN '3.0 - 3.49'
  ELSE
  '3.5 or Greater'
END
  GPA_Bucket,
  Contact.site_abrev,
  Contact.region_abrev
  
FROM
  `data-warehouse-289815.salesforce_clean.contact_at_template` AS Contact

LEFT JOIN (
  SELECT
    api_name,
    Status
  FROM
    `data-warehouse-289815.roles.ct_status` ) AS status
    
ON
  Contact.College_Track_Status_c = status.api_name
  
LEFT JOIN (
  SELECT
    Name,
    Id
  FROM
    `data-warehouse-289815.salesforce.global_academic_semester_c`) AS GAT
ON
  GAT.Id = Global_Academic_Semester_c
WHERE
  Contact.Site_Text_c != 'College Track Arlen'
  
  AND (status.Status = 'Current CT HS Student')
  AND  Contact.attendance_rate_c IS NOT NULL