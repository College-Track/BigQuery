-- updated attendance sql--
/*
SELECT
    c.Contact_Id,
    high_school_graduating_class_c,
    site_short,
    College_Track_Status_Name,
    AY_student_served,
    AY_name,
    CASE
        WHEN (AY_enrolled_sessions IS NULL 
        OR AY_enrolled_sessions = 0) THEN NULL
        ELSE (AY_attended_workshops / AY_enrolled_sessions) 
    END AS ay_attendance_rate,
    CASE
        WHEN (AY_enrolled_sessions IS NULL 
        OR AY_enrolled_sessions = 0) THEN NULL
        WHEN (AY_attended_workshops / AY_enrolled_sessions) < .25 THEN "<25%"
        WHEN (AY_attended_workshops / AY_enrolled_sessions) >= .25
        AND (AY_attended_workshops / AY_enrolled_sessions) < .45 THEN "25% - 44.5%"
        WHEN (AY_attended_workshops / AY_enrolled_sessions) >= .45
        AND (AY_attended_workshops / AY_enrolled_sessions) < .65 THEN "45% - 64.5%"
        WHEN (AY_attended_workshops / AY_enrolled_sessions) >= .65
        AND (AY_attended_workshops / AY_enrolled_sessions) < .8 THEN "65% - 79%"
        WHEN (AY_attended_workshops / AY_enrolled_sessions) >= .8
        AND (AY_attended_workshops / AY_enrolled_sessions) < .9 THEN "80% - 89%"
        WHEN (AY_attended_workshops / AY_enrolled_sessions) >= .9 THEN "90%+"
    END AS attendance_bucket
    FROM `data-warehouse-289815.salesforce_clean.contact_ay_template` cay
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` c ON c.Contact_Id = cay.Contact_Id
    WHERE site_short IN ('Ward 8', 'The Durant Center')
    AND AY_name IN ('AY 2019-20','AY 2020-21')
    AND AY_student_served = "High School"
    */
    
WITH gather_at_attendance AS
(    
    SELECT
    Student_c,
    site_short,
    high_school_graduating_class_c,
    Attendance_Numerator_c,
    Attendance_Denominator_c,
    date_c,
    Class_Attendance_Id
    
    FROM `data-warehouse-289815.salesforce_clean.class_template`
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` ON Contact_Id = Student_c
    WHERE global_academic_semester_c = "a3646000000dMXuAAM"
    AND date_c < CURRENT_DATE()
    AND Attendance_Denominator_c = 1
    AND site_short IN ('Ward 8', 'The Durant Center')
)
    SELECT
    site_short,
    high_school_graduating_class_c,
    date_c,
    ROUND(SUM(Attendance_Numerator_c)/SUM(Attendance_Denominator_c),2) AS daily_attendance_rate
    
    FROM 
    gather_at_attendance
    GROUP BY site_short, high_school_graduating_class_c, date_c