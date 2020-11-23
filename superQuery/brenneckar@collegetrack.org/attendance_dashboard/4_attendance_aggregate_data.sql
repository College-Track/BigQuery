SELECT
  site_short,
  Workshop_Display_Name_c,
  SUM(Attendance_Numerator_c) AS Attendance_Numerator,
  SUM(Attendance_Denominator_c) AS Attendance_Denominator,
  SUM(mod_numerator) AS mod_numerator,
  SUM(mod_denominator) AS mod_denominator,
  Date_c,
  HIGH_SCHOOL_GRADUATING_CLASS_c,
  dosage_types_c,
  dosage_split,
  GPA_Bucket,
  Indicator_Student_on_Intervention_c,
  site_abrev,
--   Class_c,
  Workshop_Global_Academic_Semester_c,
  Composite_Readiness_Most_Recent_c,
  Region,
  region_abrev,
  Outcome_c,
  Co_Vitality_Scorecard_Color_Most_Recent_c,
  COUNT(Student_c) AS record_count
FROM
  `data-studio-260217.attendance_dashboard.attendance_filtered_data`



GROUP BY
  Workshop_Display_Name_c,
  Date_c,
  HIGH_SCHOOL_GRADUATING_CLASS_c,
  dosage_types_c,
  GPA_Bucket,
  Indicator_Student_on_Intervention_c,
  site_abrev,

  Workshop_Global_Academic_Semester_c,
--   Class_c,
  Composite_Readiness_Most_Recent_c,
  Region,
  region_abrev,
  Outcome_c,
  dosage_split,
  Co_Vitality_Scorecard_Color_Most_Recent_c
  ORDER BY dosage_types_c