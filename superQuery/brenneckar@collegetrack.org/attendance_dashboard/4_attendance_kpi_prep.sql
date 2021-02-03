WITH gather_data AS (
  SELECT
    Contact_Id,
    AT_Id,
    site_short,
    HIGH_SCHOOL_GRADUATING_CLASS_c,
    REPLACE(GAS_Name, ' (Semester)', '') AS GAS_Name,
    region_short,
    region_abrev,
    site_abrev,
    CASE
      WHEN GPA_prev_semester_cumulative_c < 2.5 THEN '2.49 or less'
      WHEN GPA_prev_semester_cumulative_c >= 2.5
      AND GPA_prev_semester_cumulative_c < 2.75 THEN '2.5 - 2.74'
      WHEN GPA_prev_semester_cumulative_c >= 2.75
      AND GPA_prev_semester_cumulative_c < 3 THEN '2.75 - 2.99'
      WHEN GPA_prev_semester_cumulative_c >= 3
      AND GPA_prev_semester_cumulative_c < 3.5 THEN '3.0 - 3.49'
      ELSE '3.5 or Greater'
    END GPA_Bucket,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template` AS Contact
    WHERE Contact.college_track_status_c IN ('11A')
),
calc_attendance AS (
  SELECT
    student_c,
    academic_semester_c,
    SUM(Attendance_Denominator_c) AS Attendance_Denominator_c,
    SUM(Attendance_Numerator_c) AS Attendance_Numerator_c,
    CASE
      WHEN SUM(Attendance_Denominator_c) = 0 THEN NULL
      ELSE SUM(Attendance_Numerator_c) / SUM(Attendance_Denominator_c)
    END AS attendance_rate
  FROM
    `data-warehouse-289815.salesforce_clean.class_template`
  GROUP BY
    student_c,
    academic_semester_c
),
join_data AS (
  SELECT
    GD.*,
    CA.attendance_rate,
    CASE
      WHEN CA.attendance_rate >= 0.8 THEN 1
      ELSE 0
    END AS above_80_attendance,
    CASE
      WHEN CA.attendance_rate < 0.65 THEN 1
      ELSE 0
    END AS below_65_attendance
  FROM
    gather_data GD
    LEFT JOIN calc_attendance CA ON CA.academic_semester_c = GD.AT_Id
    WHERE CA.attendance_rate IS NOT NULL
)
SELECT
  site_short,
--   HIGH_SCHOOL_GRADUATING_CLASS_c,
  GAS_Name,
  region_short,
  region_abrev,
  site_abrev,
--   GPA_Bucket,
  COUNT(Contact_Id) AS student_count,
  SUM(above_80_attendance) AS above_80_attendance,
  SUM(below_65_attendance) AS below_65_attendance
FROM
  join_data
  WHERE GAS_Name = 'Fall 2020-21'
GROUP BY
  site_short,
--   HIGH_SCHOOL_GRADUATING_CLASS_c,
  GAS_Name,
  region_short,
  region_abrev,
  site_abrev
--   GPA_Bucket