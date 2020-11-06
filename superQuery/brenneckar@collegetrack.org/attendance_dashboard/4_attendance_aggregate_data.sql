SELECT
  Student_Site__c,
  Workshop_Display_Name__c,
  SUM(Attendance_Numerator__c) AS Attendance_Numerator,
  SUM(Attendance_Denominator__c) AS Attendance_Denominator,
  SUM(mod_numerator) AS mod_numerator,
  SUM(mod_denominator) AS mod_denominator,
  Date__c,
  Student_High_School_Class__c,
  Workshop_Dosage_Type__c,
  dosage_split,
  GPA_Bucket,
  Indicator_Student_on_Intervention__c,
  site_abrev,
--   Class__c,
  Workshop_Global_Academic_Semester__c,
  Composite_Readiness_Most_Recent__c,
  Region,
  region_abrev,
  Outcome__c,
  COUNT(Student__c) AS record_count
FROM
  `data-studio-260217.attendance_dashboard.tmp_filtered_attendance`
WHERE
  Attendance_Excluded__c = FALSE
  AND Workshop_Dosage_Type__c IS NOT NULL
  AND (Attendance_Denominator__c > 0 OR Attendance_Numerator__c > 0)
GROUP BY
  Student_Site__c,
  Workshop_Display_Name__c,
  Date__c,
  Student_High_School_Class__c,
  Workshop_Dosage_Type__c,
  GPA_Bucket,
  Indicator_Student_on_Intervention__c,
  site_abrev,
  Workshop_Global_Academic_Semester__c,
--   Class__c,
  Workshop_Global_Academic_Semester__c,
  Composite_Readiness_Most_Recent__c,
  Region,
  region_abrev,
  Outcome__c,
  dosage_split
  ORDER BY Workshop_Dosage_Type__c