SELECT 
    c.site_short,
    COUNT(DISTINCT(student_c)) AS unique_student_count,
    Count(id) AS efund_count,
    SUM(amount_c) total_efund_disbursement_amount,
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean`
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` c ON c.Contact_Id = student_c

    WHERE scholarship_c = 'College Track Emergency Fund'
    AND date_c >= '2020-07-01'
    AND date_c < '2021-07-01'
    AND site_short IN ('Boyle Heights','Watts')
    GROUP BY site_short