SELECT indicator_low_income_c, COUNT(*)
FROM `data-warehouse-289815.salesforce_clean.contact_template`
GROUP BY indicator_low_income_c