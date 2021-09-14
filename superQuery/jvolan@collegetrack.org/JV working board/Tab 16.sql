  SELECT
    AVG(AT_Term_GPA),
    AVG(AT_Cumulative_GPA),
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE site_short = "The Durant Center"
    AND student_audit_status_c = "Current CT HS Student"
    AND GAS_Name IN ("Fall 2020-21 (Semester)","Spring 2020-21 (Semester)")
    GROUP BY GAS_Name

/* alternate version if you want to account for NULLs

    SELECT
    Contact_Id,
    AT_Term_GPA,
    AT_Cumulative_GPA,
    AT_Name,
    full_name_c,
    high_school_class_c, 
    College_Track_Status_Name
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE site_short = "The Durant Center"
    AND student_audit_status_c = "Current CT HS Student"
    AND GAS_Name IN ("Fall 2020-21 (Semester)","Spring 2020-21 (Semester)")

 FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE site_short = "The Durant Center"
    AND student_audit_status_c = "Current CT HS Student"
    AND 
    (GAS_Name IN ("Fall 2020-21 (Semester)","Spring 2020-21 (Semester)")
    AND 
    (AT_Term_GPA IS NULL
    OR AT_Cumulative_GPA IS NULL)
    )
*/