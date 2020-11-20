SELECT enrollment_status_c, COUNT(*)
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
GROUP BY enrollment_status_c