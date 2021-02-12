SELECT COUNT(contact_id), student_audit_status_c
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE site_short = 'Crenshaw'
GROUP BY student_audit_status_c