WITH gather_data AS (
SELECT *
FROM `data-warehouse-289815.surveys.fy21_hs_survey`
LIMIT 10
)

SELECT *
FROM gather_data