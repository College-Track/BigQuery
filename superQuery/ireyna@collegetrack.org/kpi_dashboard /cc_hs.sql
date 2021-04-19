SELECT student_c, SUM(Attendance_Numerator_excluding_make_up_c) AS attendance_numerator, SUM(Attendance_Denominator_c) AS attendance_denominator, 
    #SUM(Attendance_Numerator_excluding_make_up_c) / SUM(Attendance_Denominator_c) AS attendance_rate
    FROM `data-warehouse-289815.salesforce_clean.class_template` 
    WHERE Department_c = "College Completion"
    GROUP BY student_c,Attendance_Numerator_excluding_make_up_c,Attendance_Denominator_c