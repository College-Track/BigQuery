SELECT 
    DISTINCT CT.student_c,
    CASE
        WHEN college_track_status_c IN ('11A') --current ct hs student
        THEN 1
        ELSE 0
        END AS mse_denom,
    site_short
    
FROM `data-warehouse-289815.salesforce_clean.class_template` CT
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT 
ON CAT.AT_Id = CT.Academic_Semester_c

--pull in students that have attended 1+ workshop in Fall/Spring 2019-20, excluding NSO 
WHERE Attendance_Numerator_c > 0
    AND dosage_types_c NOT LIKE '%NSO%'
    AND AY_Name = "AY 2019-20"
    AND term_c IN ("Fall","Spring")
    AND grade_c != '8th Grade'
    
--pull in students that were active at end of Spring 2019-20
    AND CAT.global_academic_semester_c = 'a3646000000dMXhAAM' --Spring 2019-20 (Semester)
    AND student_audit_status_c IN ('Current CT HS Student','Leave of Absence')