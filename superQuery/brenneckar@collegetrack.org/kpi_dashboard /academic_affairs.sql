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
    CASE
      WHEN SUM(Attendance_Denominator_c) = 0 THEN NULL
      ELSE SUM(Attendance_Numerator_c) / SUM(Attendance_Denominator_c)
    END AS attendance_rate
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
),

gather_survey_data AS (
  SELECT
    CT.site_short,
    S.contact_id,
    CASE
      WHEN ct_helps_me_better_understand_that_i_am_in_control_of_my_academic_performance = "Strongly Agree" THEN 1
      WHEN ct_helps_me_better_understand_that_i_am_in_control_of_my_academic_performance = 'Agree' THEN 1
      ELSE 0
    END AS i_am_in_control_of_my_academic_performance,
        CASE
      WHEN i_feel_prepared_to_engage_in_academic_stretch_opportunities = "Strongly Agree" THEN 1
      WHEN i_feel_prepared_to_engage_in_academic_stretch_opportunities = 'Agree' THEN 1
      ELSE 0
    END AS i_feel_prepared_to_engage_in_academic_stretch_opportunities
    
  FROM
    `data-studio-260217.surveys.fy21_hs_survey` S
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` CT ON CT.Contact_Id = S.contact_id
 
)
-- aggregate_survey_data AS (
-- SELECT
-- site_short,

-- FROM gather_survey_data
-- GROUP BY site_short
-- )

  
SELECT
  GD.site_short,
  SUM(above_325_gpa) AS aa_above_325_gpa,
  SUM(composite_ready) AS aa_composite_ready,
  SUM(above_80_aa_attendance) AS aa_above_80_aa_attendance,
  SUM(i_am_in_control_of_my_academic_performance) AS aa_i_am_in_control_of_my_academic_performance,
SUM(i_feel_prepared_to_engage_in_academic_stretch_opportunities) AS aa_i_feel_prepared_to_engage_in_academic_stretch_opportunities
FROM
  gather_data GD
  LEFT JOIN aa_attendance_kpi AA ON GD.Contact_Id = AA.student_c
  LEFT JOIN gather_survey_data GSD ON GSD.contact_id = GD.contact_id
GROUP BY
  site_short