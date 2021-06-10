SELECT
    SUM(attendance_numerator_c) AS sum_attended_wellness_sessions,
    site_short
   
    FROM  `data-warehouse-289815.salesforce_clean.contact_at_template` AS CAT  
    LEFT JOIN `data-warehouse-289815.salesforce_clean.class_template` AS CT ON CAT.at_id = CT.academic_semester_c
    WHERE
        Attendance_Numerator_c > 0
        AND department_c = 'Wellness'
        AND dosage_types_c NOT LIKE '%NSO%'
        AND Outcome_c != 'Cancelled'
        AND CT.student_c IN (SELECT student_c FROM gather_red_blue_covi_at)
    GROUP BY
            site_short