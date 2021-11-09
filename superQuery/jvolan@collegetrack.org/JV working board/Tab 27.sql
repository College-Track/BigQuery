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