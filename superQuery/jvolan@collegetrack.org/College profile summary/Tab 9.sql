WITH gather_college_survey AS
(
    SELECT
    Contact_Id AS cs_contact_id,
    current_college_clean AS college_name,
    a.id AS account_id,
    "Spring" AS cs_term,
    
    i_felt_i_belonged_on_my_college_campus AS cs_belong_on_campus,
    most_students_i_met_were_focused_on_getting_a_bachelors_degree AS cs_student_ba_focus,
    my_college_is_culturally_competenthelp_note_i_felt_that_the_adults_on_campus_hel AS cs_cultural_comp,
    
    i_could_pay_for_tuition_and_living_expenses AS cs_afford_school,
    
    FROM `data-warehouse-289815.surveys.fy20_ps_survey`
    LEFT JOIN `data-warehouse-289815.salesforce.account` a ON name = current_college_clean
    WHERE are_you_currently_in_your_freshman_year_of_college = "Yes"
),

gather_year_1_enrolled AS
(
    SELECT
    Contact_Id AS at_contact_id,
    AT_Grade_c,
    school_c,
    AT_School_Name,
    AT_school_type,
    term_c,
    CASE
        WHEN AT_Enrollment_Status_c = "Full-time" THEN 1
        ELSE 0
    END AS es_fulltime,
    CASE
        WHEN AT_Enrollment_Status_c = "Part-time" THEN 1
        ELSE 0
    END AS es_parttime,
    CASE
        WHEN AT_Enrollment_Status_c NOT IN ("Full-time", "Part-time") THEN 1
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
        WHEN term_c = "Spring" THEN credits_accumulated_c
        ELSE NULL
    END AS s_year_1_c_credits,
    
    CASE
        WHEN term_c = "Spring" THEN AT_Cumulative_GPA
        ELSE NULL
    END AS s_year_1_cgpa,
    
    CASE
        WHEN 
        (term_c = "Spring"
        AND AT_Cumulative_GPA < 2.75) THEN "Below 2.75"
        WHEN 
        (term_c = "Spring"
        AND AT_Cumulative_GPA >= 2.75
        AND AT_Cumulative_GPA <3.25) THEN "2.75-3.25"
        WHEN
        (term_c = "Spring"
        AND AT_Cumulative_GPA >= 3.25) THEN "3.25+"
        ELSE NULL
    END AS s_year_1_cgpa_bucket,

    
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
    CASE
        WHEN year_1_college_math_course_grade_c IN ("A","B","C","Pass (P/NP)") THEN 1
        ELSE 0
    END AS year_1_math_pass_num,
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
    
    CASE
        WHEN 
        (credits_attempted_current_term_c IS NULL
        OR credits_attempted_current_term_c = 0) THEN NULL
        ELSE credits_awarded_current_term_c/credits_attempted_current_term_c 
    END AS avg_sap_percent_at,
    
     CASE
        WHEN credits_attempted_current_term_c IS NOT NULL THEN 1
        ELSE 0
    END AS sap_at_denom,
    
    CASE
        WHEN 
        (credits_attempted_current_term_c IS NULL
        OR credits_attempted_current_term_c = 0) THEN NULL
        WHEN (credits_awarded_current_term_c/credits_attempted_current_term_c) > .6667 THEN 1
        ELSE 0
    END AS met_sap_requirement_6667_num,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN gather_college_survey ON cs_contact_id = Contact_Id AND term_c = cs_term
    WHERE AT_Grade_c = "Year 1"
    AND term_c <> "Summer"
    AND AT_Record_Type_Name = "College/University Semester"
    AND school_c IS NOT NULL
    AND AT_Enrollment_Status_c IS NOT NULL
    
)
    SELECT
    *
    FROM gather_year_1_enrolled