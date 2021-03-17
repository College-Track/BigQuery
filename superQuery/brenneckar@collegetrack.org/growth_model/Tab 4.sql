



WITH numbers AS
  (SELECT 'nola' as site, 100 AS start_count, 2021 as FY, 2024 AS hs_class
  UNION ALL SELECT 'nola' as site, 75 AS start_count, 2021 as FY, 2020 AS hs_class 
  UNION ALL SELECT 'co' as site, 100 AS start_count, 2021 as FY, 2022 AS hs_class)



SELECT site, hs_class, SPLIT(student_count, ',')[OFFSET(0)] fiscal_year, CAST(SPLIT(student_count, ',')[OFFSET(1)] AS FLOAT64) num_student
FROM (
  SELECT site, hs_class, `learning-agendas.growth_model.calc_projected_student_count`(start_count, FY, hs_class, 15) count_arrary
--   list_fy(FY, 15) fY_array
  FROM numbers
  
), UNNEST(count_arrary) student_count