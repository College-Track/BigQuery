SELECT Attendance_Numerator_c, COUNT(Id)
FROM `data-warehouse-289815.salesforce.class_attendance_c`
GROUP BY attendance_numerator_c