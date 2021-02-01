WITH gather_data AS (
  SELECT
    CAT.Contact_Id,
    CAT.full_name_c,
    CAT.site_abrev,
    CAT.site_short,
    CAT.site_sort,
    CAT.region_abrev,
    CAT.high_school_graduating_class_c,
    CAT.Gender_c,
    CAT.Ethnic_background_c,
    CAT.student_audit_status_c,
    CAT.AT_Term_GPA,
    CAT.AT_Cumulative_GPA,
    AT_Cumulative_GPA - Prev_Prev_Prev_AT.gpa_semester_cumulative_c AS year_over_year_cum_gpa_change,
    Prev_Prev_Prev_AT.gpa_semester_cumulative_c AS prev_prev_prev_at_cum_gpa,
    -- AT_Term_GPA - Prev_Prev_Prev_AT_Term_GPA AS year_over_year_term_gpa_change,
    CAT.AT_Term_GPA_bucket,
    CAT.sort_AT_Term_GPA_bucket,
    CAT.AT_Cumulative_GPA_bucket,
    CAT.sort_AT_Cumulative_GPA,
    CAT.GPA_Growth_prev_semester_c,
    `data-warehouse-289815.UDF.determine_buckets`(
      CAT.GPA_Growth_prev_semester_c,.25,
      -0.5,
      0.5,
      ""
    ) AS gpa_growth_bucket,
    `data-warehouse-289815.UDF.sort_created_buckets`(CAT.GPA_Growth_prev_semester_c,.25, -0.5, 0.5) AS sort_gpa_growth_bucket,
    CAT.Most_Recent_GPA_Cumulative_bucket,
    CAT.sort_Most_Recent_GPA_Cumulative_bucket,
    CAT.Most_Recent_GPA_Cumulative_c,
    CAT.AT_Id,
    CONCAT(
      'https://ctgraduates.lightning.force.com/',
      CAT.AT_ID
    ) AS at_url,
    CAT.previous_as_c,
    CAT.Current_HS_CT_Coach_c,
    CAT.AT_Grade_c,
    REPLACE(
      CAT.GAS_Name,
      ' (Semester)',
      ''
    ) AS GAS_Name,
    CAT.GAS_Start_Date,
    CAT.AY_Name,
    CAT.AY_Start_Date,
    CASE
      WHEN AT_Cumulative_GPA >= 3.25 THEN 1
      ELSE 0
    END AS above_325_gpa,
    CASE
      WHEN AT_Cumulative_GPA < 2.75 THEN 1
      ELSE 0
    END AS below_275_gpa
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template` CAT
    LEFT JOIN `data-warehouse-289815.salesforce.academic_semester_c` Prev_AT ON Prev_AT.id = CAT.previous_academic_semester_c
    LEFT JOIN `data-warehouse-289815.salesforce.academic_semester_c` Prev_Prev_AT ON Prev_Prev_AT.id = Prev_AT.Previous_Academic_Semester_c
    LEFT JOIN `data-warehouse-289815.salesforce.academic_semester_c` Prev_Prev_Prev_AT ON Prev_Prev_Prev_AT.id = Prev_Prev_AT.Previous_Academic_Semester_c
  WHERE
    CAT.college_track_status_c IN ('11A', '12A')
    AND CAT.student_audit_status_c IN ('Current CT HS Student', 'Leave of Absence')
    AND CAT.term_c != 'Summer'
    AND CAT.GAS_End_Date <= CURRENT_DATE()
  ORDER BY
    CAT.Contact_Id,
    CAT.GAS_Start_Date
),
gather_9th_grade_spring_gpa AS (
  SELECT
    Contact_Id,
    AT_Cumulative_GPA,
    AT_Cumulative_GPA_bucket,
    sort_AT_Cumulative_GPA
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    term_c = 'Spring'
    AND AT_Cumulative_GPA IS NOT NULL
    AND AT_Grade_c = '9th Grade'
),
gather_aa_attendance AS (
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
  WHERE
    department_c = 'Academic Affairs'
  GROUP BY
    student_c,
    academic_semester_c
),
ct_career_aa_attendance AS (
  SELECT
    student_c,
    CASE
      WHEN SUM(Attendance_Denominator_c) = 0 THEN NULL
      ELSE SUM(Attendance_Numerator_c) / SUM(Attendance_Denominator_c)
    END AS attendance_rate_ct_career
  FROM
    gather_aa_attendance
  GROUP BY
    student_c
),
combine_data AS (
  SELECT
    GD.*,
    G9GPA.AT_Cumulative_GPA AS ninth_cum_gpa,
    CASE
      WHEN G9GPA.AT_Cumulative_GPA_bucket IS NULL THEN "No Data"
      ELSE G9GPA.AT_Cumulative_GPA_bucket
    END AS ninth_cum_gpa_bucket,
    G9GPA.sort_AT_Cumulative_GPA AS sort_ninth_cum_gpa_bucket,
    AA.attendance_rate,
    CASE
      WHEN AA.attendance_rate IS NULL THEN "No Data"
      WHEN AA.attendance_rate <.65 THEN "< 65%"
      WHEN AA.attendance_rate >=.65
      AND AA.attendance_rate <.8 THEN "65% -79%"
      WHEN AA.attendance_rate >= 0.8
      AND AA.attendance_rate <.9 THEN "80% - 89%"
      ELSE "90%+"
    END AS attendance_bucket,
    `data-warehouse-289815.UDF.determine_buckets`(
      year_over_year_cum_gpa_change,.25,
      -0.5,
      0.5,
      ""
    ) AS year_over_year_cum_gpa_bucket,
    `data-warehouse-289815.UDF.sort_created_buckets`(year_over_year_cum_gpa_change,.25, -0.5, 0.5) AS sort_year_over_year_cum_gpa_bucket,
    CTAA.attendance_rate_ct_career,
    CASE
      WHEN CTAA.attendance_rate_ct_career IS NULL THEN "No Data"
      WHEN CTAA.attendance_rate_ct_career <.65 THEN "< 65%"
      WHEN CTAA.attendance_rate_ct_career >=.65
      AND CTAA.attendance_rate_ct_career <.8 THEN "65% -79%"
      WHEN CTAA.attendance_rate_ct_career >= 0.8
      AND CTAA.attendance_rate_ct_career <.9 THEN "80% - 89%"
      ELSE "90%+"
    END AS attendance_bucket_ct_career,
  FROM
    gather_data GD
    LEFT JOIN gather_9th_grade_spring_gpa G9GPA ON G9GPA.Contact_Id = GD.Contact_Id
    LEFT JOIN gather_aa_attendance AA ON AA.academic_semester_c = GD.AT_Id
    LEFT JOIN ct_career_aa_attendance CTAA ON CTAA.student_c = GD.Contact_Id
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
  CASE
    WHEN attendance_bucket_ct_career = 'No Data' THEN 1
    WHEN attendance_bucket_ct_career = '< 65%' THEN 2
    WHEN attendance_bucket_ct_career = '65% -79%' THEN 3
    WHEN attendance_bucket_ct_career = '80% - 89%' THEN 4
    WHEN attendance_bucket_ct_career = '90%+' THEN 5
  END AS sort_attendance_bucket_ct_career
FROM
  combine_data