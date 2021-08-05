SELECT
    student_18_digit_contact_id_c AS bb_contact_id,
    SUM(amount_c) AS fy21_bb_total,
    
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean`
    WHERE academic_year_c = 'AY 2020-21'
    AND record_type_id = '01246000000ZNhtAAG'
    GROUP BY student_18_digit_contact_id_c