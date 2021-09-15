With fy21_bb_data AS
(    
    SELECT
    c.site_short AS bb_site_short,
    COUNT(DISTINCT(student_c)) AS unique_bb_student_count,
    Count(id) AS bb_disbursement_count,
    SUM(amount_c) total_bb_disbursement_amount,

    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean` st
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` c ON c.Contact_Id = student_c

    WHERE st.record_type_id = '01246000000ZNhsAAG'
    AND amount_c >0
    AND transaction_status_c = 'Approved'
    AND disbursement_approval_date_c >= '2020-07-01'
    AND disbursement_approval_date_c < '2021-07-01'
    AND site_short IN ('Boyle Heights','Watts')
    GROUP BY site_short
),

fy21_efund_data AS
(
    SELECT 
    c.site_short AS efund_site_short,
    COUNT(DISTINCT(student_c)) AS unique_efund_student_count,
    Count(id) AS efund_st_count,
    SUM(amount_c) AS total_efund_disbursement_amount,
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean` st
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` c ON c.Contact_Id = student_c

    WHERE scholarship_c = 'College Track Emergency Fund'
    AND st.record_type_id = '01246000000ZNhvAAG'
    AND date_c >= '2020-07-01'
    AND date_c < '2021-07-01'
    AND site_short IN ('Boyle Heights','Watts')
    GROUP BY site_short
),

class_2021_bb_earn AS
(
    SELECT
    site_short,
    SUM(total_bb_earnings_as_of_hs_grad_contact_c) AS total_hs_bb_earnings_2021
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE indicator_completed_ct_hs_program_c = TRUE
    AND site_short IN ('Boyle Heights','Watts')
    AND high_school_graduating_class_c = '2021'
    GROUP BY site_short
)

    SELECT
    site_short,
    fy21_bb_data.unique_bb_student_count,
    fy21_bb_data.bb_disbursement_count,
    fy21_bb_data.total_bb_disbursement_amount,
    
    fy21_efund_data.unique_efund_student_count,
    fy21_efund_data.efund_st_count,
    fy21_efund_data.total_efund_disbursement_amount,

    class_2021_bb_earn.total_hs_bb_earnings_2021
    
    FROM fy21_bb_data
    LEFT JOIN fy21_efund_data ON efund_site_short = bb_site_short
    LEFT JOIN class_2021_bb_earn ON site_short = bb_site_short