WITH gather_test_data AS (
SELECT 
test_date_c, Id, act_math_readiness_c, version_c
FROM `data-warehouse-289815.salesforce_clean.test_clean`
WHERE act_math_readiness_c IS NOT NULL 
AND version_c IS NOT NULL
AND version_c != "Official"
)

SELECT *
FROM gather_test_data
LIMIT 100