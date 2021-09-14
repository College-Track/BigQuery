SELECT
    -- Select fields from templates
    Contact_Id,
    Full_Name_c,
    site_abrev,
    current_cc_advisor_2_c,
    high_school_graduating_class_c,
    bb_balance.Finance_BB_Balance,
    
    FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
    LEFT JOIN bb_balance ON bb_balance.student_c = Contact_Id
    WHERE College_Track_Status_c IN ('11A', '12A','15A', '16A')