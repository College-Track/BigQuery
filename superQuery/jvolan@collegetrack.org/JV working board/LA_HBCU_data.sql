    SELECT
    Contact_Id,
    site_short,
    high_school_graduating_class_c,
    College_Track_Status_Name
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN `data-warehouse-289815.salesforce.account` ON id = school_c
    WHERE historically_black_college_univ_hbcu_c = TRUE
    GROUP BY Contact_id, site_short, high_school_graduating_class_c, College_Track_Status_Name


    