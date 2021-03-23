WITH new_hs_classes AS (
SELECT region_abrev, site_short, first_year_target as starting_count, high_school_graduating_class_c
FROM (
SELECT "test_region" AS region_abrev, "test_site" AS site_short, 60 AS first_year_target, GENERATE_ARRAY(2024, 2024+12) AS hs_classes 

)
,UNNEST(hs_classes) high_school_graduating_class_c
)

SELECT *
FROM new_hs_classes