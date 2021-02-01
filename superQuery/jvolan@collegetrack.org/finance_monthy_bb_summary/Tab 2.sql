
    SELECT
    student_c, 
    amount_c, 
    transaction_status_c,
    id AS bb_id,
    finance_reporting_date_c, 
    
    
    FROM
    `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean`
    WHERE
    finance_reporting_date_c > '2020-07-01'AND
    record_type_id = "01246000000ZNhsAAG" OR
    record_type_id = "01246000000ZNhtAAG"