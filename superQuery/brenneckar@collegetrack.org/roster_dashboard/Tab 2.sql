SELECT Current_School_Type_c_degree, COUNT(*)
FROM `data-warehouse-289815.salesforce_clean.contact_template`
GROUP BY Current_School_Type_c_degree