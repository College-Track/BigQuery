SELECT student_c, COUNT(student_c)
FROM `data-warehouse-289815.salesforce.academic_semester_c`
WHERE  current_as_c = true

GROUP BY student_c
Having COUNT(student_c) > 1