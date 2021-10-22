SELECT
    #contact data
    contact_id,
    full_name_c,
    high_school_graduating_class_c,
    College_Track_Status_Name,
    site_short,

    #current enrollment data 
    Current_school_name,
    current_enrollment_status_c,
    college_4_year_degree_earned_c --for alumni
    

    FROM `data-warehouse-289815.salesforce_clean.contact_template` 

    WHERE
    indicator_completed_Ct_hs_program_c = TRUE
    AND (Current_school_name LIKE '%Hampton University%' OR college_4_year_degree_earned_c LIKE '%Hampton University%')