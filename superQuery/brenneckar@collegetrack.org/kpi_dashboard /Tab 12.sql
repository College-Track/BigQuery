WITH gather_test_data AS (
SELECT 
test_date_c, Id
FROM `data-warehouse-289815.salesforce_clean.test_clean`
)

SELECT *
FROM gather_test_data
LIMIT 100