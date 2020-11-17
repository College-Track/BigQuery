SELECT attendance_denominator_c, COUNT(Id)
FROM `data-warehouse-289815.salesforce.class_attendance_c`
GROUP BY attendance_denominator_c