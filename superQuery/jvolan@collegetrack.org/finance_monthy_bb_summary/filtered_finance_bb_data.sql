
WITH bb_d_e_fy AS
(
   SELECT
    student_c, 
    amount_c, 
    transaction_status_c,
    earning_type_c,
    name,
    id AS bb_id,
    CAST(finance_reporting_date_c AS DATE) AS finance_reporting_date, 
    CASE
        WHEN record_type_id = "01246000000ZNhsAAG"then "BB Disbursement"
        WHEN record_type_id = "01246000000ZNhtAAG"then "BB Earnings"
        END AS BB_Record_Type,
    CASE
        WHEN record_type_id = "01246000000ZNhsAAG"then amount_c
        END AS BB_Disbursement_Amount,
    CASE
        WHEN record_type_id = "01246000000ZNhtAAG"then amount_c
        END AS BB_Earnings_Amount,
    academic_year_c,
    FORMAT_DATE("%m", CURRENT_DATE()) AS report_month,
    CAST (CURRENT_DATE() AS DATE) AS report_date,    
    
    FROM
    `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean`
    WHERE finance_reporting_date_c >= '2021-07-01'
    AND record_type_id = "01246000000ZNhsAAG"
    AND transaction_status_c = "Approved"
    OR record_type_id = "01246000000ZNhtAAG"
    AND finance_reporting_date_c >= '2021-07-01'
),

bb_balance AS
(
    SELECT
    student_c,
    MAX(finance_bb_balance_total_c) AS Finance_BB_Balance,
    
    FROM
    `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    WHERE record_type_id = "01246000000ZNi1AAG"
    AND finance_bb_balance_total_c > 0
    GROUP BY student_c
 ),  
    
student_bb_balance_list AS
(
    SELECT
    Contact_Id,
    Full_Name_c,
    site_abrev AS Site,
    current_cc_advisor_2_c AS Current_CCA,
    high_school_graduating_class_c AS HS_Class,
    College_Track_Status_Name AS CT_Status,
    bb_balance.Finance_BB_Balance,
    FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
    LEFT JOIN bb_balance ON bb_balance.student_c = Contact_Id
    WHERE College_Track_Status_c IN ('11A', '12A','15A', '16A')
    AND bb_balance.Finance_BB_Balance IS NOT NULL
),

bb_raw AS
(
    SELECT
    student_bb_balance_list.*,
    bb_d_e_fy.bb_id,
    bb_d_e_fy.BB_Record_Type,
    bb_d_e_fy.amount_c,
    bb_d_e_fy.BB_Disbursement_Amount,
    bb_d_e_fy.BB_Earnings_Amount,
    bb_d_e_fy.finance_reporting_date,
    bb_d_e_fy.academic_year_c,
    bb_d_e_fy.earning_type_c,
    bb_d_e_fy.name,
    bb_d_e_fy.transaction_status_c, 
    bb_d_e_fy.report_month, 
    bb_d_e_fy.report_date, 
    FROM
    student_bb_balance_list
    LEFT JOIN bb_d_e_fy ON bb_d_e_fy.student_c = student_bb_balance_list.Contact_Id
)

    SELECT
    *
    FROM
    bb_raw
    WHERE BB_Record_Type = "BB Disbursement"
     
     