WITH gather_data AS (
  SELECT
    region_abrev,
    site_short,
    AT_grade_c,
    CAST(high_school_graduating_class_c AS FLOAT64) AS high_school_graduating_class_c,
    CASE
      WHEN A.College_Track_High_School_Capacity_c = 287 THEN 75
      ELSE 60
    END AS first_year_target,
    COUNT(Contact_Id) as starting_count,
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
    region_abrev,
    first_year_target,
    site_short,
    AT_grade_c,
    high_school_graduating_class_c
),
prep_data_for_new_hs_class AS (
SELECT region_abrev, site_short, first_year_target, MAX(high_school_graduating_class_c) AS high_school_graduating_class_c
FROM gather_data 
GROUP BY region_abrev, site_short, first_year_target
),


new_hs_classes AS (
SELECT region_abrev, site_short, first_year_target as starting_count, high_school_graduating_class_c
FROM (
SELECT region_abrev, site_short, first_year_target, GENERATE_ARRAY(high_school_graduating_class_c+1, high_school_graduating_class_c+12) AS hs_classes 
FROM prep_data_for_new_hs_class
)
,UNNEST(hs_classes) high_school_graduating_class_c
),

news_site AS (
SELECT region_abrev, site_short, first_year_target as starting_count, high_school_graduating_class_c
FROM (
SELECT @new_region_1 AS region_abrev, @new_site_1 AS site_short, CAST(@new_site_1_target AS INT64) AS first_year_target, GENERATE_ARRAY(2024, 2024+12) AS hs_classes 

)
,UNNEST(hs_classes) high_school_graduating_class_c
),




combined_classes AS (
SELECT region_abrev, site_short, starting_count, high_school_graduating_class_c
FROM gather_data
WHERE starting_count = 0
UNION ALL (SELECT * FROM new_hs_classes WHERE starting_count=0)
UNION ALL (SELECT * FROM news_site WHERE starting_count = 0)
)


SELECT *
FROM combined_classes



