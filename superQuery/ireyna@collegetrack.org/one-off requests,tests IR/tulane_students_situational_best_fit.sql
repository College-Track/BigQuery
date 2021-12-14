SELECT 
    contact_id,
    full_name_c,
    high_school_graduating_class_c,
    site_short,
    AT_Grade_c,
    GAS_Name AS academic_term,
    at_id,
    fit_type_at_c,
    situational_best_fit_c,
    situational_best_fit_context_c
    
FROM `data-warehouse-289815.salesforce_clean.contact_at_template` AS contact_at 

WHERE
    indicator_completed_Ct_hs_program_c = TRUE
    AND AT_School_Name = 'Tulane University of Louisiana'
    AND fit_type_at_c NOT IN ('Best Fit','Situational')
    AND enrollment_status_c IN ("Full-time","Part-time")