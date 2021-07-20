WITH gather_data AS (
  SELECT
    Contact_Id,
    AT_Id,
    site,
    site_short,
    HIGH_SCHOOL_GRADUATING_CLASS_c,
    current_as_c,
    REPLACE(GAS_Name, ' (Semester)', '') AS Workshop_Global_Academic_Semester_c,
    region_short,
    region_abrev,
    site_abrev,
    Most_Recent_GPA_Cumulative_bucket AS GPA_Bucket,
    sort_Most_Recent_GPA_Cumulative_bucket,
    Co_Vitality_Scorecard_Color_Most_Recent_c,
    sort_covitality,
    Composite_Readiness_Most_Recent_c,
    site_sort
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template` AS Contact
  WHERE
    Contact.college_track_status_c IN ('11A')
    AND GAS_Start_Date >= "2019-08-01"
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
    END AS below_65_attendance,
    CASE WHEN Attendance_Denominator_c > 0 THEN 1
    ELSE 0 
    END AS student_count
  FROM
    gather_data GD
    LEFT JOIN calc_attendance CA ON CA.academic_semester_c = GD.AT_Id
  WHERE
    (CA.attendance_rate IS NOT NULL AND current_as_c != true) OR current_as_c = true
)
SELECT
  site_short,
  site,
  HIGH_SCHOOL_GRADUATING_CLASS_c,
  Workshop_Global_Academic_Semester_c,
  region_short,
  region_abrev,
  site_abrev,
  GPA_Bucket,
  Co_Vitality_Scorecard_Color_Most_Recent_c,
  Composite_Readiness_Most_Recent_c,
  sort_Most_Recent_GPA_Cumulative_bucket,
  site_sort,
  sort_covitality,
  SUM(student_count) AS student_count,
  SUM(above_80_attendance) AS above_80_attendance,
  SUM(below_65_attendance) AS below_65_attendance
  
FROM
  join_data

GROUP BY
  site_short,
  site,
  HIGH_SCHOOL_GRADUATING_CLASS_c,
  Workshop_Global_Academic_Semester_c,
  region_short,
  region_abrev,
  site_abrev,
  GPA_Bucket,
  Co_Vitality_Scorecard_Color_Most_Recent_c,
  Composite_Readiness_Most_Recent_c,
  sort_Most_Recent_GPA_Cumulative_bucket,
  site_sort,
  sort_covitality

-- SELECT *
-- FROM gather_data