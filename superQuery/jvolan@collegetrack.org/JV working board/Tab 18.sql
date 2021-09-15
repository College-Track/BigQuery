SELECT 
    student_c,
    Count(id) AS efund_st_count,
    SUM(amount_c) AS total_efund_disbursement_amount,
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean` st
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` c ON c.Contact_Id = student_c

    WHERE scholarship_c = 'College Track Emergency Fund'
    AND st.record_type_id = '01246000000ZNhvAAG'
    AND date_c >= '2020-07-01'
    AND date_c < '2021-07-01'
    AND site_short IN ('Boyle Heights','Watts')
    GROUP BY student_c