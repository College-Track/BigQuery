 SELECT
    st.student_c
    amount_c,
    cat.academic_year_c

    FROM `data-warehouse-289815.salesforce_clean.scholarship_transaction_clean` st
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` cat ON st.academic_semester_c = cat.AT_Id
    WHERE scholarship_c = 'College Track Emergency Fund'
    GROUP BY st.student_c,cat.academic_year_c