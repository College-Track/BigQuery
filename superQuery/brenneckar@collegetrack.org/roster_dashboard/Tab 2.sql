SELECT current_enrollment_status_c, COUNT(*)
FROM `data-warehouse-289815.salesforce_clean.contact_template`
GROUP BY current_enrollment_status_c