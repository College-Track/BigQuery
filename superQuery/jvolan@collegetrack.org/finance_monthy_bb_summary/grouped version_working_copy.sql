SELECT
    student_c,
    SUM (amount_c) as bb_disbursement_total,
    
    FROM
    `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean`
    WHERE
    record_type_id = "01246000000ZNhsAAG"
    AND finance_reporting_date_c >= '2021-07-01'
    AND transaction_status_c = "Approved"
    GROUP BY student_c