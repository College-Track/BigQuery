    SELECT
    Contact_Id,
    site_short,
    college_first_enrolled_school_c AS cfe,
    CASE
        WHEN 
        (College_Track_Status_Name = "CT Alumni"
        AND college_first_enrolled_school_c = college_4_year_degree_earned_c) THEN "Started & graduated from same HBCU"
        WHEN 
        (College_Track_Status_Name = "CT Alumni"
        AND college_first_enrolled_school_c <> college_4_year_degree_earned_c) THEN "Started HBCU graduated at different school"
        WHEN
        (College_Track_Status_Name = "Active: Post-Secondary"
        AND college_first_enrolled_school_c = Current_School_c) THEN "Started & still at same HBCU"
        WHEN 
        (College_Track_Status_Name = "Active: Post-Secondary"
        AND college_first_enrolled_school_c <> Current_School_c) THEN "Started HBCU, but at different school now"
        WHEN College_Track_Status_Name = "Inactive: Post-Secondary" THEN "Started HBCU, but went Inactive"
        ELSE "NA"
    END AS cfe_bucket,
    Current_school_name,
    college_4_year_degree_earned_c,

    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    LEFT JOIN `data-warehouse-289815.salesforce.account` ON id = college_first_enrolled_school_c
    WHERE historically_black_college_univ_hbcu_c = TRUE

