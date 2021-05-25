SELECT *
FROM `data-warehouse-289815.salesforce_clean.test_clean` AS COVI
WHERE record_type_id ='0121M000001cmuDQAQ' --Covitality test record type
AND status_c = 'Completed'