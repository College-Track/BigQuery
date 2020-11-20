SELECT Current_school_name, COUNT(*)
FROM `data-warehouse-289815.salesforce_clean.contact_template`
GROUP BY Current_school_name