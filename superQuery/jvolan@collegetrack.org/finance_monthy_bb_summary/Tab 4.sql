
    SELECT
    student_c,
    max(finance_bb_balance_total_c) as Finance_BB_Balance
    
    FROM
    `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    WHERE record_type_id = "01246000000ZNi1AAG"
    AND finance_bb_balance_total_c > 0
    AND current_ct_status_c IN ('Current CT HS Student', 'Leave of Absence', 'Active: Post-Secondary','Inactive: Post-Secondary')
    GROUP BY student_c