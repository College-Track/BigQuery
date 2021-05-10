WITH gather_data AS (
  SELECT
    Contact_Id,
    site_short,
    CASE
      WHEN (
        Prev_AT_Cum_GPA >= 3.25
        AND composite_readiness_most_recent_c = '1. Ready'
        AND college_track_status_c = '11A'
        AND grade_c = '12th Grade'
      ) THEN 1
      ELSE 0
    END AS gpa_3_25__test_ready,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    current_as_c = true
    AND college_track_status_c IN ('11A')
),
gather_retention_data AS (
  SELECT
    DISTINCT CT.student_c,
    CASE
      WHEN college_track_status_c IN ('11A', '18a', '12A') THEN 1
      ELSE 0
    END AS currently_active,
    site_short
  FROM
    `data-warehouse-289815.salesforce_clean.class_template` CT
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT ON CAT.AT_Id = CT.Academic_Semester_c
  WHERE
    Attendance_Numerator_c > 0
    AND dosage_types_c NOT LIKE '%NSO%'
    AND AY_Name = "AY 2020-21"
    AND grade_c != '8th Grade'
)
SELECT
  site_short,
  COUNT(student_c) AS retention_denom,
  SUM(currently_active) AS retention_num
FROM
  gather_retention_data 
  GROUP BY site_short
  
  -- SELECT
  -- site_short,
  -- SUM(gather_data.gpa_3_25__test_ready) AS red_gpa_3_25_test_ready
  -- FROM gather_data
  -- GROUP BY site_short