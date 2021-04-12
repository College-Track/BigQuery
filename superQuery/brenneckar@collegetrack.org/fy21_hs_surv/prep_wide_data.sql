WITH gather_data AS (
SELECT *
FROM `data-studio-260217.surveys.fy21_hs_survey`
LIMIT 10
)

SELECT *
FROM gather_data