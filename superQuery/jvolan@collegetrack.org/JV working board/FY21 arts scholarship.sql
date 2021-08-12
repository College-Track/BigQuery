SELECT
    st.student_c AS e_contact_id,
    st.academic_semester_c,
    amount_c,
    cat.academic_year_c,

    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean` st
    WHERE scholarship_c = 'a3B46000000HX7xEAG'