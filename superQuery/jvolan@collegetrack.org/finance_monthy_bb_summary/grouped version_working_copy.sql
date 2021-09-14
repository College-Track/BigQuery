SELECT
    student_c,
    SUM (amount_c) as bb_earnings_total,
    
    FROM
    `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean`
    WHERE
    record_type_id = "01246000000ZNhtAAG"
    AND created_date >= '2021-07-01'
    AND amount_c > 0
    GROUP BY student_c