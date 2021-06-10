SELECT
    SUM(attendance_numerator_c) AS sum_attended_wellness_sessions,
    site_short,CAT.student_c
   
    FROM  `data-warehouse-289815.salesforce_clean.contact_at_template` AS CAT  
    LEFT JOIN `data-warehouse-289815.salesforce_clean.class_template` AS CT ON CAT.contact_id = CT.student_c
    WHERE
        Attendance_Numerator_c > 0
        AND department_c = 'Wellness'
        AND dosage_types_c NOT LIKE '%NSO%'
        AND academic_semester_c IN (SELECT at_id FROM  `data-warehouse-289815.salesforce_clean.contact_at_template` WHERE AY_Name = "AY 2020-21")
        AND Outcome_c != 'Cancelled'
    GROUP BY
            site_short, student_c