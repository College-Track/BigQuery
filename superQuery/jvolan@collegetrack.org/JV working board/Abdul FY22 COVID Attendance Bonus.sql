SELECT
    Contact_Id,
    CASE
        WHEN attendance_rate_c >= .8 THEN 1 
        ELSE 0
    END AS prev_at_attendance_80_yn

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE 
    GAS_Name IN ("Fall 2021-22 (Semester)")
    AND student_audit_status_c IN ("Current CT HS Student","Onboarding")
    AND attended_workshops_c > 0