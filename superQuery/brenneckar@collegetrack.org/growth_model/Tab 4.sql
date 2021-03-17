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



-- WITH numbers AS
--   (SELECT 'nola' as site, 100 AS start_count, 2021 as FY, 2024 AS hs_class
--   UNION ALL SELECT 'nola' as site, 75 AS start_count, 2021 as FY, 2020 AS hs_class 
--   UNION ALL SELECT 'co' as site, 100 AS start_count, 2021 as FY, 2022 AS hs_class)



-- SELECT site, hs_class, SPLIT(student_count, ',')[OFFSET(0)] fiscal_year, CAST(SPLIT(student_count, ',')[OFFSET(1)] AS FLOAT64) num_student
-- FROM (
--   SELECT site, hs_class, `learning-agendas.growth_model.calc_projected_student_count`(start_count, FY, hs_class, 15) count_arrary
-- --   list_fy(FY, 15) fY_array
--   FROM numbers
  
-- ), UNNEST(count_arrary) student_count


SELECT *
FROM gather_data