
    SELECT
    Contact_Id,
    AT_Id,
    school_c,
    type_of_degree_earned_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE type_of_degree_earned_c = "4-year degree"