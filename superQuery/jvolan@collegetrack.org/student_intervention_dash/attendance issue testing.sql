
SELECT
    max(date_c) AS most_recent_attended_workshop,
    academic_semester_c,
    FROM `data-warehouse-289815.salesforce_clean.class_template`
    WHERE Attendance_c IN ('Enrolled','Tardy','Make Up','Drop-in')
    GROUP BY academic_semester_c