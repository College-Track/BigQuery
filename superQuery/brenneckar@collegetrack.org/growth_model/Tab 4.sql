WITH gather_data AS (
  SELECT
    region_short,
    site_short,
    AT_grade_c,
    CAST(high_school_graduating_class_c AS FLOAT64) AS high_school_graduating_class_c,
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
prep_data_for_new_hs_class AS (
SELECT region_short, site_short, first_year_target, MAX(high_school_graduating_class_c) AS high_school_graduating_class_c
FROM gather_data 
GROUP BY region_short, site_short, first_year_target
),


new_hs_classes AS (
SELECT region_short, site_short, first_year_target, hs_class
FROM (
SELECT region_short, site_short, first_year_target, GENERATE_ARRAY(high_school_graduating_class_c+1, high_school_graduating_class_c+10) AS hs_classes 
FROM prep_data_for_new_hs_class
)
,UNNEST(hs_classes) hs_class
),


calc_projections AS (SELECT region_short, site_short, high_school_graduating_class_c, SPLIT(student_count, ',')[OFFSET(0)] fiscal_year, CAST(SPLIT(student_count, ',')[OFFSET(1)] AS FLOAT64) num_student
FROM (
  SELECT region_short, site_short, high_school_graduating_class_c, `learning-agendas.growth_model.calc_projected_student_count`(fy20_student_count, 2020, high_school_graduating_class_c, 15) count_arrary
  FROM gather_data
  
), UNNEST(count_arrary) student_count
)

SELECT *
FROM new_hs_classes
-- WHERE site_short = 'San Francisco'
-- ORDER BY high_school_graduating_class_c


