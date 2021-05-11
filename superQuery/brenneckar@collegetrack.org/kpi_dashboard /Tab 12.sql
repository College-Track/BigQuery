WITH gather_test_data AS (
SELECT 
test_date_c, Id, act_math_readiness_c, version_c, co_vitality_indicator_c, record_type_id
FROM `data-warehouse-289815.salesforce_clean.test_clean`
WHERE co_vitality_indicator_c IS NOT NULL
)

SELECT *
FROM gather_test_data
LIMIT 100