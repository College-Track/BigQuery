SELECT indicator_low_income_c, COUNT(*)
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
GROUP BY indicator_low_income_c