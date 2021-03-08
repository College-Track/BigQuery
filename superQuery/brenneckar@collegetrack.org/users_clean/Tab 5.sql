SELECT CONCAT(first_name," ", last_name), id 
FROM `data-warehouse-289815.salesforce_clean.user_clean`
WHERE user_role_id = '00E46000000YcO1EAK'