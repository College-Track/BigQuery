SELECT Contact_Id, attendance_rate_c, Attendance_Rate_Previous_Term_c
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE Attendance_Rate_Previous_Term_c IS NOT NULL
LIMIT 1000