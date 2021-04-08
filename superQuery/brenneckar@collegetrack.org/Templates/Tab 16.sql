SELECT Contact_Id, AT_Id, previous_academic_semester_c, attendance_rate_c, Attendance_Rate_Previous_Term_c
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
WHERE Attendance_Rate_Previous_Term_c IS NOT NULL AND attendance_rate_c IS NOT NULL
AND AT_Id ='a1a1M0000072TfEQAU'
LIMIT 1000