SELECT
        CAT.student_c,
        site_short,
        MAX(
            CASE
                --pull in students that have a session attendance record in Fall/Spring 2019-20, excluding NSO     
                WHEN grade_c != '8th Grade'
                    THEN 1
                ELSE 0
            END
        ) AS mse_reporting_group
    FROM
        `data-warehouse-289815.salesforce_clean.contact_at_template` CAT
        LEFT JOIN `data-warehouse-289815.salesforce_clean.class_template` CT ON CAT.contact_id = CT.student_c
    WHERE ((CAT.global_academic_semester_c = 'a3646000000dMXhAAM' --Spring 2019-20 (Semester)
            AND student_audit_status_c = 'Current CT HS Student') 
        AND (CAT.global_academic_semester_c = 'a3646000000dMXiAAM' --Summer 2019-20 (Semester)
            AND student_audit_status_c = 'Current CT HS Student'))
    GROUP BY
        site_short,
        CAT.student_c