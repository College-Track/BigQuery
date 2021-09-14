SELECT
    -- Select fields from templates
    Contact_Id,
    Full_Name_c,
    site_abrev,
    current_cc_advisor_2_c,
    high_school_graduating_class_c,

    FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE College_Track_Status_Name IN ('Current CT HS Student', 'Leave of Absence', 'Active: Post-Secondary','Inactive: Post-Secondary')