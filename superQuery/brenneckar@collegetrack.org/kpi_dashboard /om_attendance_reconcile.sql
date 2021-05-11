SELECT COUNT(Class_Attendance_Id)
FROM `data-warehouse-289815.salesforce_clean.class_template`
WHERE Outcome_c = 'Scheduled' AND (EXTRACT(MONTH FROM date_c) < EXTRACT(MONTH FROM CURRENT_DATE()))