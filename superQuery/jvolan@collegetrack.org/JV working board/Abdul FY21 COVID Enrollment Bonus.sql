    SELECT
    Contact_Id,
    full_name_c,
    high_school_graduating_class_c,
    site_short,
    College_Track_Status_Name,
    AT_Name,
    student_audit_status_c,
    attended_workshops_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE AY_Name = "AY 2020-21"
    AND student_audit_status_c IN ("Current CT HS Student","Onboarding")