gather_attendance_data AS (

    SELECT student_c, SUM(Attendance_Numerator_excluding_make_up_c) AS attendance_numerator, SUM(Attendance_Denominator_c) AS attendance_denominator
    #SUM(Attendance_Numerator_excluding_make_up_c) / SUM(Attendance_Denominator_c) AS attendance_rate
    FROM `data-warehouse-289815.salesforce_clean.class_template` 
    WHERE Department_c = "College Completion"
    AND Cancelled_c = FALSE
    AND global_academic_semester_c IN ('a3646000000dMXnAAM','a3646000000dMXoAAM','a3646000000dMXpAAM') #Fall 2020-21, Spring 2020-21, Summer 2020-21
    GROUP BY student_c
    ),
        
gather_data_twelfth_grade AS (
    SELECT 
        contact_id,
        
        #attendance data
        attendance_numerator,
        attendance_denominator,
        
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS subq1
        WHERE admission_status_c = "Accepted" AND College_Fit_Type_Applied_c IN ("Best Fit","Good Fit","Local Affordable")
        AND Contact_Id=student_c
        group by student_c
        ) AS applied_accepted_affordable,
        
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS subq2
        WHERE admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred") AND fit_type_enrolled_c IN ("Best Fit","Good Fit","Local Affordable","Situational")
        AND Contact_Id=student_c
        group by student_c
        ) AS accepted_enrolled_affordable,
        
        site_short,
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean` AS subq3
        WHERE College_Fit_Type_Applied_c IN ("Best Fit","Good Fit","Situational")  
        AND Contact_Id=student_c
        group by student_c
        ) AS applied_best_good_situational,
            
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS subq4
        WHERE admission_status_c = "Accepted" AND College_Fit_Type_Applied_c IN ("Best Fit","Good Fit","Situational")
        AND Contact_Id=student_c
        group by student_c
        ) AS applied_accepted_best_good_situational,
        
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS subq5
        WHERE admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred") AND fit_type_enrolled_c IN ("Best Fit","Good Fit","Situational")
        AND Contact_Id=student_c
        group by student_c
        ) AS accepted_enrolled_best_good_situational,
        
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
        LEFT JOIN gather_attendance_data ON contact_id=student_c
    
    WHERE  college_track_status_c = '11A'
    AND grade_c = '12th Grade'