SELECT
    Contact_Id AS at_contact_id,
    AT_Grade_c,
    school_c,
    AT_School_Name,
    AT_school_type,
    term_c,
    CASE
        WHEN enrollment_status_c = "Full-time" THEN 1
        ELSE 0
    END AS es_fulltime,
    CASE
        WHEN enrollment_status_c = "Part-time" THEN 1
        ELSE 0
    END AS es_parttime,
    CASE
        WHEN enrollment_status_c NOT IN ("Full-time", "Part-time") THEN 1
        ELSE 0
    END AS es_other,

    CASE
        WHEN term_c = "Fall" THEN AT_Term_GPA
        ELSE NULL
    END AS f_at_term_gpa,
    CASE
        WHEN term_c = "Winter" THEN AT_Term_GPA
        ELSE NULL
    END AS w_at_term_gpa,
    CASE
        WHEN term_c = "Spring" THEN AT_Term_GPA
        ELSE NULL
    END AS s_at_term_gpa,
    
    CASE
        WHEN term_c = "Spring" THEN AT_Cumulative_GPA
        ELSE NULL
    END AS s_year_1_cgpa,
    
    CASE
        WHEN term_c = "Spring" THEN credits_accumulated_c
        ELSE NULL
    END AS s_year_1_c_credits,
    
    CASE
        WHEN 
        (AT_Term_GPA IS NOT NULL
        AND AT_Term_GPA <2)
        OR academic_standing_c IN ("Academic Probation","Subject to Dismissal")
        THEN 1
        ELSE 0
    END AS at_gpa_standing_flag,
    
    AT_Term_GPA,
    AT_Term_GPA_bucket,
    AT_Cumulative_GPA,
    AT_Cumulative_GPA_bucket,
    
    
    first_year_college_math_course_c,
    year_1_college_math_course_grade_c,
    first_year_loan_debt_c,
    
    CASE
        WHEN loans_c = "LN_R" THEN 1
        ELSE 0
    END AS ar_loans_at_risk_30k_num,
    CASE WHEN loans_c IS NOT NULL THEN 1
        ELSE 0
    END AS ar_loans_at_risk_30k_denom,
    CASE
        WHEN ability_to_pay_c = "ATP_G" THEN 1
        ELSE 0
    END AS ar_ability_to_pay_full_cost_num,
     CASE WHEN ability_to_pay_c IS NOT NULL THEN 1
        ELSE 0
    END AS ar_ability_to_pay_full_cost_denom,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE AT_Grade_c = "Year 1"
    AND term_c <> "Summer"
    AND AT_Record_Type_Name = "College/University Semester"
    AND school_c IS NOT NULL
    AND AT_Enrollment_Status_c IS NOT NULL
