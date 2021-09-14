WITH bb_balance AS
(
    SELECT
    student_c,
    max(finance_bb_balance_total_c) as Finance_BB_Balance
    
    FROM
    `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    WHERE record_type_id = "01246000000ZNi1AAG"
    AND finance_bb_balance_total_c > 0
    GROUP BY student_c
 ),


student_list_bb_balance AS
(
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