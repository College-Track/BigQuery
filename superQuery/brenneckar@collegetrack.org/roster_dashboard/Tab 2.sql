SELECT Current_school_c, A.Name, A.predominant_degree_awarded_c, COUNT(*)
FROM `data-warehouse-289815.salesforce_clean.contact_template`
LEFT JOIN `data-warehouse-289815.salesforce.account` A ON A.Id = Current_school_c
GROUP BY Current_school_c, A.Name, A.predominant_degree_awarded_c