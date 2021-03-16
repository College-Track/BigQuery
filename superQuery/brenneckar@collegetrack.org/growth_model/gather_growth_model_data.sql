WITH gather_data AS (
  SELECT
    region_short,
    site_short,
    Contact_Id,
    AT_Id,
    student_audit_status_c,
    GAS_Name,
    AT_Record_Type_Name,
    AT_Grade_c,
    AY_Name,
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
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    GAS_Name LIKE "%Spring%"
    AND student_audit_status_c IN (
      'Current CT HS Student',
      'Active: Post-Secondary',
      "Leave of Absence"
    )
    AND start_date_c >= '2016-01-01'
    AND end_date_c <= '2020-06-30'
    and AT_Grade_c != '8th Grade'
),
group_data AS (
  SELECT
    region_short,
    site_short,
    AY_Name,
    AT_Grade_c,
    grade_sort,
    -- student_audit_status_c,
    COUNT(Contact_Id) AS student_count
  FROM
    gather_data
    WHERE grade_sort <= 11
  GROUP BY
    region_short,
    site_short,
    AY_Name,
    AT_Grade_c,
    grade_sort -- student_audit_status_c
)
SELECT
  AT_Grade_c,
  grade_sort,
  AVG(student_count)
FROM
  group_data
GROUP BY
  AT_Grade_c,
  grade_sort
ORDER BY
  grade_sort


