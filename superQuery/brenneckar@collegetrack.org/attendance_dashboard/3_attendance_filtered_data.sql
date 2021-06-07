WITH gather_data AS(
  SELECT
    WSA.Class_Attendance_Id,
    WSA.dosage_types_c,
    SPLIT(RTRIM(WSA.dosage_types_c, ";"), ';') AS dosage_combined,
    WSA.Attendance_Numerator_c,
    WSA.Attendance_Denominator_c,
    0 AS group_base,
    WSA.Student_c,
    CAT.Full_Name_c,
    WSA.Date_c,
    WSA.Outcome_c,
    WSA.Department_c,
    WSA.Workshop_Display_Name_c,
    CAT.HIGH_SCHOOL_GRADUATING_CLASS_c,
    WSA.Attendance_Excluded_c,
    CAT.Indicator_High_Risk_for_Dismissal_c,
    CAT.Indicator_Low_Income_c,
    CAT.Ethnic_background_c,
    CAT.First_Generation_c,
    CAT.GPA_Bucket_running_cumulative_c,
    CAT.College_Track_Status_c,
    -- status.Status,
    WSA.Academic_Semester_c,
    REPLACE(
      CAT.GAS_Name,
      ' (Semester)',
      ''
    ) AS Workshop_Global_Academic_Semester_c,
    CAT.Indicator_Student_on_Intervention_c,
    CAT.GPA_prev_semester_cumulative_c,
    CAT.Composite_Readiness_Most_Recent_c,
    CAT.Most_Recent_GPA_Cumulative_bucket AS GPA_Bucket,
    CAT.site_abrev,
    CAT.site_short,
    CAT.CT_Coach_c,
    CAT.Most_Recent_GPA_Cumulative_c,
    CAT.Indicator_Sem_Attendance_Above_80_c,
    CAT.region,
    CAT.region_abrev,
    CAT.College_Track_Status_Name,
    CAT.Co_Vitality_Scorecard_Color_Most_Recent_c,
    WSA.Class_c,
    CONCAT(
      "https://ctgraduates.lightning.force.com/lightning/r/Contact/",
      WSA.Student_c,
      "/view"
    ) AS contact_url,
    CONCAT(
      "https://ctgraduates.lightning.force.com/lightning/r/Class_c/",
      WSA.Class_c,
      "/view"
    ) AS workshop_url,
    WSA.workshop_instructor_c
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template` CAT
    LEFT JOIN `data-warehouse-289815.salesforce_clean.class_template` WSA ON WSA.Academic_Semester_c = CAT.AT_Id -- LEFT JOIN `data-warehouse-289815.salesforce_raw.Class_Session_c` WS ON WS.Id = WSA.Class_Session_c
    -- LEFT JOIN `data-warehouse-289815.salesforce_raw.Class_c` W ON W.Id = WS.Class_c
  WHERE
    (
      CAT.College_Track_Status_Name = 'Current CT HS Student' --   OR CAT.College_Track_Status_Name = 'Onboarding'
      --   OR CAT.College_Track_Status_Name = 'Leave of Absence'
    )
    AND WSA.Date_c >= "2019-08-01"
    -- AND outcome_c != 'Scheduled'
),
mod_dosage AS (
  SELECT
    *
  EXCEPT(
      Attendance_Numerator_c,
      Attendance_Denominator_c
    ),
    Attendance_Numerator_c AS mod_numerator,
    Attendance_Denominator_c AS mod_denominator
  FROM
    gather_data
    CROSS JOIN UNNEST(gather_data.dosage_combined) AS dosage_split
),
create_col_number AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY Class_Attendance_Id
      ORDER BY
        Class_Attendance_Id
    ) - 1 As group_count,
  from
    mod_dosage
),
calc_attendance_rate AS (
  SELECT
    academic_semester_c,
    SUM(Attendance_Denominator_c) AS Attendance_Denominator_c,
    SUM(Attendance_Numerator_c) AS Attendance_Numerator_c,
    CASE
      WHEN SUM(Attendance_Denominator_c) = 0
      AND SUM(Attendance_Numerator_c) = 0 THEN NULL
      WHEN SUM(Attendance_Denominator_c) = 0
      AND SUM(Attendance_Numerator_c) > 0 THEN 1
      ELSE SUM(Attendance_Numerator_c) / SUM(Attendance_Denominator_c)
    END AS attendance_rate
  FROM
    `data-warehouse-289815.salesforce_clean.class_template`
--   WHERE
    -- outcome_c != 'Scheduled'
  GROUP BY
    academic_semester_c
),
combined_metrics AS (
  SELECT
    MD.*
  EXCEPT(dosage_combined),
    GD.Attendance_Numerator_c,
    GD.Attendance_Denominator_c,
    --   GD.* EXCEPT(dosage_combined)
    --   MD.dosage_split
  FROM
     gather_data GD
    
    LEFT JOIN create_col_number MD ON GD.Class_Attendance_Id = MD.Class_Attendance_Id
    AND MD.group_count = GD.group_base
  ORDER BY
    GD.Class_Attendance_Id
),
format_metrics AS (
  SELECT
    CM.*
  EXCEPT(dosage_split, dosage_types_c),
    CASE WHEN REGEXP_CONTAINS(workshop_display_name_c, 'Summer Bridge') THEN "Summer Bridge"
    ELSE TRIM(dosage_split) END AS dosage_split,
    CASE WHEN REGEXP_CONTAINS(workshop_display_name_c, 'Summer Bridge') THEN "Summer Bridge"
    ELSE dosage_types_c
    END AS dosage_types_c,
    CASE
      WHEN AA.attendance_rate IS NULL THEN "No Data"
      WHEN AA.attendance_rate <.65 THEN "< 65%"
      WHEN AA.attendance_rate >=.65
      AND AA.attendance_rate <.8 THEN "65% -79%"
      WHEN AA.attendance_rate >= 0.8
      AND AA.attendance_rate <.9 THEN "80% - 89%"
      ELSE "90%+"
    END AS attendance_bucket,
    AA.attendance_rate AS AT_attendance_rate,
    AA.Attendance_Numerator_c AS AT_attendance_numerator
  FROM
    combined_metrics CM
    LEFT JOIN calc_attendance_rate AA ON AA.academic_semester_c = CM.Academic_Semester_c
  WHERE
    -- Date_c <= CURRENT_DATE()
     Attendance_Excluded_c = FALSE --   AND dosage_types_c IS NOT NULL
--     --   AND (
--     --     mod_denominator > 0
--     --     OR mod_numerator > 0
--     --   )
)
SELECT
  *,
  CASE
    WHEN attendance_bucket = 'No Data' THEN 1
    WHEN attendance_bucket = '< 65%' THEN 2
    WHEN attendance_bucket = '65% -79%' THEN 3
    WHEN attendance_bucket = '80% - 89%' THEN 4
    WHEN attendance_bucket = '90%+' THEN 5
  END AS sort_attendance_bucket,
FROM
  format_metrics

