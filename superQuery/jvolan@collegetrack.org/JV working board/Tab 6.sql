SELECT
    student_18_digit_contact_id_c AS s_contact_id,
    scholarship_c,
    SUM(amount_c) AS total_amount,
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean`
    WHERE scholarship_c IN ('DOOR','College Track Emergency Fund')
    AND academic_year_c = 'AY 2020-21'
    GROUP BY student_18_digit_contact_id_c, scholarship_c