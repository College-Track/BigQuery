
    SELECT
    Contact_Id,
    AT_Id,
    AT_School_Name,
    major_c,
    type_of_degree_earned_c,
    years_to_complete_4_year_degree_c,
    graduated_4_year_degree_4_years_c,
    graduated_4_year_degree_5_years_c,
    graduated_4_year_degree_6_years_c,
    graduated_4_year_degree_c,
    AT_Cumulative_GPA,
    indicator_1_post_secondary_internship_c,
    ps_internships_c,
    AY_Name,
    end_date_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE type_of_degree_earned_c = "4-year degree"