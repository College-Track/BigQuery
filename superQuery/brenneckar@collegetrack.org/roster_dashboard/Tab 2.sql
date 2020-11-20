SELECT school_type, COUNT(*)
FROM `data-warehouse-289815.salesforce_clean.contact_template`
GROUP BY school_type