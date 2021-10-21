 SELECT
    Contact_Id,
    
    COUNT(AT_Id) AS eligble_AT_count,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE 
    GAS_Name IN ("Spring 2019-20 (Semester)","Fall 2020-21 (Semester)", "Spring 2020-21 (Semester)")
    AND student_audit_status_c IN ("Current CT HS Student","Onboarding")
    AND attended_workshops_c > 0
    GROUP BY Contact_Id