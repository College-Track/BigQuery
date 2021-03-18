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
    -- LEFT JOIN `learning-agendas.growth_model.growth_model_assumptions` GMA ON GMA.join_key = GD.join_key
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
SELECT region_short, site_short, first_year_target, high_school_graduating_class_c
FROM (
SELECT region_short, site_short, first_year_target, GENERATE_ARRAY(high_school_graduating_class_c+1, high_school_graduating_class_c+12) AS hs_classes 
FROM prep_data_for_new_hs_class
)
,UNNEST(hs_classes) high_school_graduating_class_c
),


calc_projections AS (SELECT region_short, site_short, high_school_graduating_class_c, SPLIT(student_count, ',')[OFFSET(0)] fiscal_year, CAST(SPLIT(student_count, ',')[OFFSET(1)] AS FLOAT64) num_student
FROM (
  SELECT region_short, site_short, high_school_graduating_class_c, `learning-agendas.growth_model.calc_projected_student_count`(fy20_student_count, 2020, high_school_graduating_class_c, 15,[0.918175347, 1.080857452, 0.877739525, 0.846273341, 0.945552158,0.947539442, 0.903267551, 0.83901895, 0.47881341, 0.481957966, 0.689493272, 0.419033383]) count_arrary
  FROM gather_data
  
), UNNEST(count_arrary) student_count
),


calc_projections_new_hs_class AS (SELECT region_short, site_short, high_school_graduating_class_c, SPLIT(student_count, ',')[OFFSET(0)] fiscal_year, CAST(SPLIT(student_count, ',')[OFFSET(1)] AS FLOAT64) num_student
FROM (
  SELECT region_short, site_short, high_school_graduating_class_c, `learning-agendas.growth_model.calc_projected_student_count`(first_year_target, 2020, high_school_graduating_class_c, 15, [0.918175347, 1.080857452, 0.877739525, 0.846273341, 0.945552158,0.947539442, 0.903267551, 0.83901895, 0.47881341, 0.481957966, 0.689493272, 0.419033383]) count_arrary
  FROM new_hs_classes
  
), UNNEST(count_arrary) student_count
)

SELECT *
FROM calc_projections_new_hs_class
UNION ALL (SELECT * FROM calc_projections)
-- ORDER BY site_short, hs_class
-- WHERE site_short = 'San Francisco'
-- ORDER BY high_school_graduating_class_c


