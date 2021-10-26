    SELECT
    AY_Name,
    site_short,
    COUNT(AT_Id) AS at_count,
    COUNT(DISTINCT Contact_Id) AS unique_student_count,
    COUNT(type_of_degree_earned_c) AS degree_earned_count,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN `data-warehouse-289815.salesforce.account` ON id = school_c
    WHERE historically_black_college_univ_hbcu_c = TRUE
    GROUP BY AY_Name, site_short
    
    


    