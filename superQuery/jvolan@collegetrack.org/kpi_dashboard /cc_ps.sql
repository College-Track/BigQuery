
    SELECT
    Contact_Id,
    site_short,
    high_school_graduating_class_c,
    indicator_completed_ct_hs_program_c,
    current_school_name,
    current_school_type_c_degree,
    current_enrollment_status_c,
    indicator_years_since_hs_graduation_c,
    graduated_4_year_degree_c,
    graduated_4_year_degree_4_years_c,
    graduated_4_year_degree_5_years_c,
    graduated_4_year_degree_6_years_c,
    current_cc_advisor_2_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE indicator_completed_ct_hs_program_c = true