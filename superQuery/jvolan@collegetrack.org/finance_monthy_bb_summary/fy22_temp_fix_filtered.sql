-- gather all BB disbursements & earnings from current FY to date
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
    WHERE 
    (finance_reporting_date_c >= '2021-07-01'
    AND finance_reporting_date_c <'2021-09-01'
    AND record_type_id = "01246000000ZNhsAAG"
    AND transaction_status_c = "Approved")
    OR 
    (record_type_id = "01246000000ZNhtAAG"
    AND finance_reporting_date_c >= '2021-07-01'
    AND finance_reporting_date_c <'2021-09-01')
),

temp_fix_student_bb_balance_list AS
(
    SELECT
    Contact_Id,
    Full_Name_c,
    site_abrev,
    current_cc_advisor_2_c,
    high_school_graduating_class_c,
    temp_fix_finance_bb_balance_9_1,
    
    FROM
    `data-studio-260217.finance_monthly_bb.temp_fix_fy22_finance_grouped_bb_data`
),

-- join all BB transaction data with student data & bb balance
bb_raw AS
(
    SELECT
    temp_fix_student_bb_balance_list.*,
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
    temp_fix_student_bb_balance_list
    LEFT JOIN bb_d_e_fy ON bb_d_e_fy.student_c = temp_fix_student_bb_balance_list.Contact_Id
)

    SELECT
    *
    FROM
    bb_raw
    WHERE bb_id IS NOT NULL
    AND BB_Record_Type = "BB Earnings"
    