WITH gather_data AS (
  SELECT
    Contact_Id,
    site_short,
    CASE
      WHEN Prev_AT_Cum_GPA >= 3.25 THEN 1
      ELSE 0
    END AS above_325_gpa,
    CASE
      WHEN composite_readiness_most_recent_c = '1. Ready'
      AND grade_c = '12th Grade' THEN 1
      ELSE 0
    END AS composite_ready
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    current_as_c = true
    AND college_track_status_c IN ('11A')
),
aa_attendance_prep AS (
    SELECT
      C.student_c,
      SUM(Attendance_Numerator_c) / SUM(Attendance_Denominator_c) AS attendance_rate
    --   SUM(Attendance_Denominator_c) AS Attendance_Denominator_c
    FROM
      `data-warehouse-289815.salesforce_clean.class_template` C
      LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT ON CAT.global_academic_semester_c = C.global_academic_semester_c
    WHERE
      department_c = "Academic Affairs"
      AND CAT.AY_Name = 'AY 2020-21'
      
    GROUP BY student_c
  ),
  
aa_attendance_kpi AS (
SELECT student_c,
CASE WHEN attendance_rate >= 0.8 THEN 1
ELSE 0
END AS above_80_aa_attendance
FROM aa_attendance_prep
)  
  
SELECT
  site_short,
  SUM(above_325_gpa) AS above_325_gpa,
  SUM(composite_ready) AS composite_ready,
  SUM(above_80_aa_attendance) AS above_80_aa_attendance
FROM
  gather_data GD
  LEFT JOIN aa_attendance_kpi AA ON GD.Contact_Id = AA.student_c
GROUP BY
  site_short