WITH gather_data AS
(
  SELECT
    Contact_Id,
    site_short,
    CASE
      WHEN (Prev_AT_Cum_GPA >= 3.25
      AND composite_readiness_most_recent_c = '1. Ready'
      AND college_track_status_c ='11A'
      AND grade_c = '12th Grade') THEN 1
      ELSE 0
    END AS gpa_3_25__test_ready,
    
    
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    current_as_c = true
    AND college_track_status_c IN ('11A')
),

gather_retention_data AS (
SELECT DISTINCT student_c 
FROM `data-warehouse-289815.salesforce_clean.class_template`
LEFT JOIN `data-warehouse-289815.salesforce.global_academic_semester_c` GAS ON GAS.id = global_academic_semester_c
WHERE Attendance_Numerator_c > 0 
AND dosage_types_c NOT LIKE '%NSO%'
AND GAS.name LIKE '%2020-21%'

)

SELECT COUNT student_c
FROM gather_retention_data
    -- SELECT
    -- site_short,
    -- SUM(gather_data.gpa_3_25__test_ready) AS red_gpa_3_25_test_ready
    
    -- FROM gather_data
    -- GROUP BY site_short