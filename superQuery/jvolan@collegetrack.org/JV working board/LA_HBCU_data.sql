    SELECT
    Contact_Id,
    site_short,
    high_school_graduating_class_c,
    
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN `data-warehouse-289815.salesforce.account` ON id = school_c
    WHERE historically_black_college_univ_hbcu_c = TRUE
    AND enrollment_status_c IS NOT NULL
    GROUP BY Contact_id, site_short, high_school_graduating_class_c

    