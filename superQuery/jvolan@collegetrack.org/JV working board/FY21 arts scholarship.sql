SELECT
    st.student_c,
    st.academic_semester_c,
    st.amount_c,
    cat.academic_year_c
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean` st
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` cat ON academic_semester_c = id
    WHERE st.record_type_id = '01246000000ZNhtAAG'