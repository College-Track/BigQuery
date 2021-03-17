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
)
SELECT
  GD.*
EXCEPT(join_key),
  CASE
    WHEN AT_Grade_c = '9th Grade' THEN fy20_student_count * GMA.ten_grade
    ELSE 0
  END AS fy21_projection
FROM
  gather_data GD
  LEFT JOIN `learning-agendas.growth_model.growth_model_assumptions` GMA ON GMA.join_key = GD.join_key