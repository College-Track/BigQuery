
WITH calc_projections AS (SELECT region_abrev, site_short, high_school_graduating_class_c, SPLIT(student_count, ',')[OFFSET(0)] fiscal_year, CAST(SPLIT(student_count, ',')[OFFSET(1)] AS FLOAT64) num_student
FROM (
  SELECT region_abrev, site_short, high_school_graduating_class_c, `learning-agendas.growth_model.calc_projected_student_count`(starting_count, 2020, high_school_graduating_class_c, 15,[0.918175347, 1.080857452, 0.877739525, 0.846273341, 0.945552158,0.947539442, 0.903267551, 0.83901895, 0.47881341, 0.481957966, 0.689493272, 0.419033383]) count_arrary
  FROM `learning-agendas.growth_model.growth_model_data_prep`
  
), UNNEST(count_arrary) student_count
),

determine_ps_or_hs AS (
SELECT *,
CASE WHEN (high_school_graduating_class_c - 2000) >= CAST(REGEXP_EXTRACT(fiscal_year,r'[0-9 ]+')AS FLOAT64) THEN "High School"
ELSE "Post-Secondary"
END AS student_type
FROM calc_projections

)


SELECT * EXCEPT(num_student),
CASE WHEN num_student IS NULL THEN 0
ELSE num_student
END AS num_student
FROM determine_ps_or_hs