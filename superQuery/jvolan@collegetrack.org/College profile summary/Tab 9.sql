    SELECT
    Contact_Id AS at_contact_id,
    AT_Grade_c,
    school_c,
    AT_School_Name,
    AT_school_type,
    term_c,
    credits_attempted_current_term_c,
    credits_awarded_current_term_c,
    CASE
         WHEN 
        (credits_attempted_current_term_c IS NULL
        OR credits_attempted_current_term_c = 0) THEN NULL
        ELSE credits_awarded_current_term_c/credits_attempted_current_term_c 
    END AS at_sap_credit_rate,
    CASE
        WHEN 
        (credits_attempted_current_term_c IS NULL
        OR credits_attempted_current_term_c = 0) THEN NULL
        WHEN (credits_awarded_current_term_c/credits_attempted_current_term_c) > .6667 THEN 1
        ELSE 0
    END AS met_sap_requirement_6667_num,

    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE AT_Grade_c = "Year 1"
    AND term_c <> "Summer"
    AND AT_Record_Type_Name = "College/University Semester"
    AND school_c IS NOT NULL
    AND AT_Enrollment_Status_c IS NOT NULL

