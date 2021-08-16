WITH gather_data AS (
  SELECT
    region_short,
    site_short,
    Contact_Id,
    AT_Id,
    student_audit_status_c,
    SPLIT(GAS_Name, ' (') [OFFSET(0)] AS GAS_Name,
    -- GAS_Name,
    AT_Record_Type_Name,
    AT_Grade_c,
    AY_Name,
    CASE
      WHEN A.College_Track_High_School_Capacity_c = 287 THEN 75
      ELSE 60
    END AS first_year_target,
    CASE
      WHEN AT_Grade_c = '9th Grade' THEN 1
      WHEN AT_Grade_c = '10th Grade' THEN 2
      WHEN AT_Grade_c = '11th Grade' THEN 3
      WHEN AT_Grade_c = '12th Grade' THEN 4
      WHEN AT_Grade_c = 'Year 1' THEN 5
      WHEN AT_Grade_c = 'Year 2' THEN 6
      WHEN AT_Grade_c = 'Year 3' THEN 7
      WHEN AT_Grade_c = 'Year 4' THEN 8
      WHEN AT_Grade_c = 'Year 5' THEN 9
      WHEN AT_Grade_c = 'Year 6' THEN 10
      WHEN AT_Grade_c = 'Year 7' THEN 11
      WHEN AT_Grade_c = 'Year 8' THEN 11
      ELSE 12
    END as grade_sort
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template` CAT
    LEFT JOIN `data-warehouse-289815.salesforce.account` A ON A.Id = CAT.site_c
  WHERE
    (
      (GAS_Name LIKE "%Spring%")
      OR (
        GAS_Name LIKE "%Summer%"
        AND AT_Grade_c = '9th Grade'
      )
    )
    AND student_audit_status_c IN (
      'Current CT HS Student',
      'Active: Post-Secondary',
      "Leave of Absence"
    )
    AND start_date_c >= '2017-01-01'
    AND end_date_c <= '2021-06-30'
    and AT_Grade_c != '8th Grade'
),
group_data AS (
  SELECT
    region_short,
    site_short,
    AY_Name,
    GAS_Name,
    AT_Grade_c,
    grade_sort,
    first_year_target,
    -- student_audit_status_c,
    COUNT(Contact_Id) AS student_count
  FROM
    gather_data
  WHERE
    grade_sort <= 11
  GROUP BY
    region_short,
    site_short,
    AY_Name,
    GAS_Name,
    AT_Grade_c,
    grade_sort,
    first_year_target -- student_audit_status_c
),
ninth_grade_adjustment AS (
  SELECT
    region_short,
    site_short,
    AT_Grade_c,
    AY_Name,
    grade_sort,
    first_year_target,
    AVG(student_count) AS student_count
  FROM
    group_data
  GROUP BY
    region_short,
    site_short,
    AT_Grade_c,
    AY_Name,
    grade_sort,
    first_year_target
),
calc_average_gap AS (
  SELECT
    AT_Grade_c,
    grade_sort,
    first_year_target,
    AVG(student_count) as avg_student_count,
    AVG(student_count) / first_year_target AS percent_of_target
  FROM
    ninth_grade_adjustment
  GROUP BY
    AT_Grade_c,
    grade_sort,
    first_year_target
  ORDER BY
    grade_sort
),
calc_percent_of_target AS (
  SELECT
    AT_Grade_c,
    AVG(percent_of_target) as percent_of_target
  FROM
    calc_average_gap
  GROUP BY
    AT_Grade_c,
    grade_sort
  ORDER BY
    grade_sort
)
-- SELECT
--   *
-- FROM
--   calc_percent_of_target


select
-- *
"join" AS join_key,
MAX(IF(AT_Grade_c = "9th Grade", percent_of_target, NULL)) AS nine_grade,
MAX(IF(AT_Grade_c = "10th Grade", percent_of_target, NULL)) AS ten_grade,
MAX(IF(AT_Grade_c = "11th Grade", percent_of_target, NULL)) AS eleven_grade,
MAX(IF(AT_Grade_c = "12th Grade", percent_of_target, NULL)) AS twelve_grade,
MAX(IF(AT_Grade_c = "Year 1", percent_of_target, NULL)) AS year_1,
MAX(IF(AT_Grade_c = "Year 2", percent_of_target, NULL)) AS year_2,
MAX(IF(AT_Grade_c = "Year 3", percent_of_target, NULL)) AS year_3,
MAX(IF(AT_Grade_c = "Year 4", percent_of_target, NULL)) AS year_4,
MAX(IF(AT_Grade_c = "Year 5", percent_of_target, NULL)) AS year_5,
MAX(IF(AT_Grade_c = "Year 6", percent_of_target, NULL)) AS year_6,
MAX(IF(AT_Grade_c = "Year 7", percent_of_target, NULL)) AS year_7,
MAX(IF(AT_Grade_c = "Year 8", percent_of_target, NULL)) AS year_8

From calc_percent_of_target

-- group by percent_of_target order by percent_of_target