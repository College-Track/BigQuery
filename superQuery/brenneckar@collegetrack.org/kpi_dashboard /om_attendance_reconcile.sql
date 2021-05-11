SELECT EXTRACT(MONTH FROM date_c)
FROM `data-warehouse-289815.salesforce_clean.class_template`
WHERE Outcome_c = 'Scheduled' 
LIMIT 10