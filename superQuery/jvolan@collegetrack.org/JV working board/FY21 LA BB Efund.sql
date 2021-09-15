
    SELECT
    student_c,
    id,
    amount_c,
    disbursement_approval_date_c,
    c.site_short
    
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean` st
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` c ON c.Contact_Id = student_c
    WHERE st.record_type_id = '01246000000ZNhsAAG'
    AND amount_c >0
    AND disbursement_approval_date_c >= '2020-07-01'
    AND disbursement_approval_date_c < '2021-07-01'