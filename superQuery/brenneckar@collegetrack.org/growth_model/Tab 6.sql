
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

),

calc_graduates AS (
(SELECT region_abrev, site_short, high_school_graduating_class_c, SPLIT(student_count, ',')[OFFSET(0)] fiscal_year, CAST(SPLIT(student_count, ',')[OFFSET(1)] AS FLOAT64) num_student, SPLIT(student_count, ',')[OFFSET(2)] student_type,
FROM (
  SELECT region_abrev, site_short, high_school_graduating_class_c, `learning-agendas.growth_model.calc_grad_projections`(num_student, (2000+CAST(REGEXP_EXTRACT(fiscal_year,r'[0-9 ]+')AS INT64)), high_school_graduating_class_c) count_arrary
  FROM determine_ps_or_hs
  
), UNNEST(count_arrary) student_count
)
),

prep_alumni AS (
  SELECT
    C.region_abrev,
    C.site_short,
    C.high_school_graduating_class_c,
    COUNT(C.Contact_Id) as num_student,
    "FY20" AS fiscal_year,
    "Alumni" AS student_type
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template` C
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` A_T ON A_T.AT_Id = C.contact_4_year_degree_earned_at_lookup_c
    WHERE C.college_track_status_c = '17A'
    AND A_T.GAS_Name NOT LIKE '%2020-21%' AND A_T.GAS_Name NOT LIKE '%2019-20%'
    GROUP BY 
    C.region_abrev,
    C.site_short,
    C.high_school_graduating_class_c
),

combined_alumni AS (
SELECT 
region_abrev,
site_short, 
CAST(high_school_graduating_class_c AS INT64) AS high_school_graduating_class_c, 
fiscal_year, 
student_type, 
num_student  
FROM prep_alumni 
UNION ALL (
SELECT 
region_abrev,
site_short, 
CAST(high_school_graduating_class_c AS INT64) AS high_school_graduating_class_c, 
fiscal_year, 
student_type, 
num_student  
FROM calc_graduates)

)


-- SELECT fiscal_year, SUM(num_student)
-- FROM combined_alumni
-- WHERE site_short = "Oakland" AND fiscal_year IN ('FY20', 'FY21')
-- GROUP BY fiscal_year

, complete_alumni AS (SELECT
  region_abrev, site_short, high_school_graduating_class_c, fiscal_year, student_type, SUM(num_student)
OVER
  (PARTITION BY  region_abrev, site_short
  ORDER BY fiscal_year) AS running_total
FROM combined_alumni
-- WHERE site_short = 'Denver' AND high_school_graduating_class_c = 2023
-- ORDER BY fiscal_year
)

SELECT fiscal_year,site_short,  SUM(running_total)
FROM complete_alumni
WHERE fiscal_year IN ("FY20", "FY21") AND site_short = "Oakland"
GROUP BY fiscal_year, site_short
ORDER BY site_short, fiscal_year 