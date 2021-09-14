 SELECT
    student_c,
    SUM (amount_c) as bb_earnings_total,
    
    FROM
    `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean`
    WHERE
    record_type_id = "01246000000ZNhtAAG"
    AND created_date >= '2021-07-01'
    AND created_date < '2021-09-01'
    AND amount_c IS NOT NULL
    AND student_c ='0034600001TQuZJAA1'
    GROUP BY student_c