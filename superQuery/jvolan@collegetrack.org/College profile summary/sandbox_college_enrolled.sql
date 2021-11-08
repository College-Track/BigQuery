  
    SELECT
    Contact_Id,
    AT_Id,
    AT_Grade_c,
    start_date_c,
    term_c,
    GAS_Name,
    AT_School_Name,
    AT_school_type,
    major_c,
    CASE WHEN current_as_c = TRUE THEN fit_type_current_c ELSE fit_type_at_c END AS fit_type_at,
    CASE WHEN situational_best_fit_c = "High Grad Rate Program" THEN 1 ELSE 0 END AS sfit_high_grad_program,
    CASE WHEN situational_best_fit_c = "High Grad Rate Major" THEN 1 ELSE 0 END AS sfit_high_grad_major,
    CASE WHEN situational_best_fit_c = "High Grad Rate and Affordable" THEN 1 ELSE 0 END AS sfit_high_grad_afford,
    CASE WHEN situational_best_fit_c = "DOOR" THEN 1 ELSE 0 END AS sfit_door,
    CASE WHEN situational_best_fit_c = "Other" THEN 1 ELSE 0 END AS sfit_other,
    credits_attempted_current_term_c,
    credits_awarded_current_term_c,
    credits_accumulated_c,
    cumulative_credits_awarded_all_terms_c,
    CASE WHEN on_track_c = "On-Track" THEN 1 ELSE 0 END AS on_track_count,
    CASE WHEN on_track_c = "Near On-Track" THEN 1 ELSE 0 END AS near_on_track_count,
    CASE WHEN on_track_c = "Off-Track" THEN 1 ELSE 0 END AS off_track_count,
    CASE WHEN on_track_c IS NULL THEN 1 ELSE 0 END AS missing_on_track_data_count,
    AT_Term_GPA,
    AT_Cumulative_GPA,
    current_as_c,
    fit_type_current_c,
    fit_type_at_c,
    enrollment_status_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE student_audit_status_c IN ("Active: Post-Secondary", "CT Alumni")
    AND AT_School_Name IS NOT NULL