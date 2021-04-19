SELECT student_c, SUM(Attendance_Numerator_excluding_make_up_c) AS attendance_numerator, SUM(Attendance_Denominator_c) AS attendance_denominator
    #SUM(Attendance_Numerator_excluding_make_up_c) / SUM(Attendance_Denominator_c) AS attendance_rate
    FROM `data-warehouse-289815.salesforce_clean.class_template` 
    WHERE Department_c = "College Completion"
    AND Cancelled_c = FALSE
    AND global_academic_semester_c IN ('a3646000000dMXnAAM','a3646000000dMXoAAM','a3646000000dMXpAAM') #Fall 2020-21, Spring 2020-21, Summer 2020-21
    GROUP BY student_c