WITH student_list_bb_balance AS
(
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
)

    SELECT
    student_c,
    max(finance_bb_balance_total_c) as Finance_BB_Balance
    
    
    FROM
    `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    LEFT JOIN student_list_bb_balance ON Contact_Id = student_c
    WHERE record_type_id = "01246000000ZNi1AAG"
    AND finance_bb_balance_total_c > 0
    GROUP BY student_c