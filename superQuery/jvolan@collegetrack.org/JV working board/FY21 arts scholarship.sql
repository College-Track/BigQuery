  SELECT
    st.student_c AS e_contact_id,
    st.academic_semester_c,
    amount_c,
    cat.academic_year_c

    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean` st
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` cat ON st.academic_semester_c = cat.AT_Id
    WHERE scholarship_c = 'a3B46000000HX7xEAG'
),

fy21_efund AS
(
    SELECT
    e_contact_id,
    SUM(amount_c) AS fy21_efund_total,

    FROM get_efund
    WHERE academic_year_c = 'a1b46000000dRR8AAM'
    GROUP BY e_contact_id