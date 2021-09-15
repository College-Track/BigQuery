
    SELECT
    student_c,
    id,
    amount_c,
    disbursement_approval_date_c,

    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean` st
    WHERE st.record_type_id = '01246000000ZNhsAAG'
    AND amount_c >0
    AND disbursement_approval_date_c >= '2020-07-01'
    AND disbursement_approval_date_c < '2021-07-01'