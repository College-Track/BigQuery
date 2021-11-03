
    SELECT
    Contact_Id,
    high_school_graduating_class_c,
    AT_Grade_c,
    GAS_Name,
    GAS_Start_Date,
    AT_School_Name,
    AT_school_type,
    major_c,
    CASE
        when current_as_c = TRUE THEN fit_type_current_c
        ELSE fit_type_at_c
    END AS fit_type_at,
    situational_best_fit_c,
    credits_attempted_current_term_c,
    credits_awarded_current_term_c,
    cumulative_credits_awarded_all_terms_c,
    credits_accumulated_c,
    on_track_c,
    
    AT_Term_GPA,
    AT_Term_GPA_bucket,
    AT_Cumulative_GPA,
    AT_Cumulative_GPA_bucket,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE student_audit_status_c IN ("Active: Post-Secondary", "CT Alumni")