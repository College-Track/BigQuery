set_mse_reporting_group AS (
SELECT 
    COUNT (DISTINCT CT.student_c) AS mse_denom_prev_ay,
    CAT.student_c,
    site_short
FROM `data-warehouse-289815.salesforce_clean.contact_at_template` CAT    
LEFT JOIN `data-warehouse-289815.salesforce_clean.class_template` CT
ON CAT.contact_id = CT.student_c

--pull in students that have a session attendance record in Fall/Spring 2019-20, excluding NSO 
WHERE site_short <> "College Track Arlen"
    AND Attendance_Denominator_c IS NOT NULL
    AND dosage_types_c NOT LIKE '%NSO%'
    AND AY_Name = "AY 2019-20"
    AND term_c IN ("Fall","Spring")
    AND grade_c != '8th Grade'
    
--pull in students that were active at end of Spring 2019-20; CT Status (AT)
    AND CAT.global_academic_semester_c = 'a3646000000dMXhAAM' --Spring 2019-20 (Semester)
    AND student_audit_status_c IN ('Current CT HS Student','Leave of Absence')
GROUP BY
    site_short, CAT.student_c
),