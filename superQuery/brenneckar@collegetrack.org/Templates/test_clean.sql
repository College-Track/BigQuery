SELECT  school_type, COUNT(*)
FROM `data-warehouse-289815.salesforce_clean.contact_template`
LEFT JOIN `data-warehouse-289815.salesforce.account` A ON A.Id = Current_School_c
GROUP BY school_type