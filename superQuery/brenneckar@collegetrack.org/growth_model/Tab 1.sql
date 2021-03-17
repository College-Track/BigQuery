WITH gather_data AS (
  SELECT
    "join" AS join_key,
    region_short,
    site_short,
    AT_grade_c,
    high_school_graduating_class_c,
    CASE
      WHEN A.College_Track_High_School_Capacity_c = 287 THEN 75
      ELSE 60
    END AS first_year_target,
    COUNT(Contact_Id) as fy20_student_count,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template` CAT
    LEFT JOIN `data-warehouse-289815.salesforce.account` A ON A.Id = CAT.site_c
  WHERE
    GAS_Name LIKE '%Spring 2019-20%'
    AND student_audit_status_c IN (
      'Current CT HS Student',
      'Active: Post-Secondary',
      "Leave of Absence"
    )
  GROUP BY
    region_short,
    first_year_target,
    site_short,
    AT_grade_c,
    high_school_graduating_class_c
),
create_new_hs_class AS (
  SELECT DISTINCT 
    GD.join_key,
    region_short,
    site_short,
    "NA" AS AT_grade_c,
    '2025' AS high_school_graduating_class_c,
    first_year_target,
    0 AS fy20_student_count,
    (first_year_target * GMA.nine_grade) AS fy21_projection
    
  FROM
    gather_data GD 
    LEFT JOIN `learning-agendas.growth_model.growth_model_assumptions` GMA ON GMA.join_key = GD.join_key
    
),
calc_projection AS (
  SELECT
    GD.*
  EXCEPT(join_key),
    CASE
      WHEN AT_Grade_c = '9th Grade' THEN fy20_student_count * GMA.ten_grade
      WHEN AT_Grade_c = '10th Grade' THEN fy20_student_count * GMA.eleven_grade
      WHEN AT_Grade_c = '11th Grade' THEN fy20_student_count * GMA.twelve_grade
      WHEN AT_Grade_c = '12th Grade' THEN fy20_student_count * GMA.year_1
      WHEN AT_Grade_c = 'Year 1' THEN fy20_student_count * GMA.year_2
      WHEN AT_Grade_c = 'Year 2' THEN fy20_student_count * GMA.year_3
      WHEN AT_Grade_c = 'Year 3' THEN fy20_student_count * GMA.year_4
      WHEN AT_Grade_c = 'Year 4' THEN fy20_student_count * GMA.year_5
      WHEN AT_Grade_c = 'Year 5' THEN fy20_student_count * GMA.year_6
      WHEN AT_Grade_c = 'Year 6' THEN fy20_student_count * GMA.year_7
      WHEN AT_Grade_c = 'Year 7' THEN fy20_student_count * GMA.year_8
      ELSE 0
    END AS fy21_projection
  FROM
    gather_data GD
    LEFT JOIN `learning-agendas.growth_model.growth_model_assumptions` GMA ON GMA.join_key = GD.join_key
    UNION ALL (SELECT *EXCEPT(join_key) FROM create_new_hs_class)
    
)
SELECT
  SUM(fy20_student_count),
  SUM(fy21_projection)
FROM
  calc_projection