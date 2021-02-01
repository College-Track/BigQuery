
    SELECT
    student_c, 
    amount_c, 
    transaction_status_c,
    id AS bb_id,
    FORMAT_DATE ("%x", finance_reporting_date_c) AS finance_reporting_date, 
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
    FORMAT_DATE("%m", CURRENT_DATE()) AS report_month,
    FORMAT_DATE("%x", CURRENT_DATE()) AS report_date,    
    
    FROM
    `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean`
    WHERE finance_reporting_date_c >= '2020-07-01'
    AND record_type_id = "01246000000ZNhsAAG"
    AND transaction_status_c = "Approved"
    OR record_type_id = "01246000000ZNhtAAG"
    AND finance_reporting_date_c >= '2020-07-01'
    