WITH gather_year_1_enrolled AS
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
),

    

gather_student_data AS
(
    SELECT
    Contact_Id,
    high_school_graduating_class_c,
    site_short,
    AT_Cumulative_GPA AS x_12_cgpa,
        CASE
            WHEN AT_Cumulative_GPA >=3.25 THEN 1
        END AS x_12_cgpa_325,
        CASE
            WHEN AT_Cumulative_GPA <3.25
            AND AT_Cumulative_GPA >=2.75 THEN 1
        END AS x_12_cgpa_275_325,
        CASE
            WHEN AT_Cumulative_GPA <2.75 THEN 1
        END AS x_12_cgpa_below_275,
        
    college_eligibility_gpa_11th_grade AS x_11_cgpa,
        CASE
            WHEN college_eligibility_gpa_11th_grade >=3.25 THEN "3.25+"
            WHEN 
            (college_eligibility_gpa_11th_grade < 3.25
            AND college_eligibility_gpa_11th_grade >= 2.75) THEN "2.75-3.25"
            WHEN college_eligibility_gpa_11th_grade < 2.75 THEN "Below 2.75"
            ELSE NULL
        END AS x_11_cgpa_bucket,
        CASE
            WHEN college_eligibility_gpa_11th_grade >=3.25 THEN 1
        END AS x_11_cgpa_325,
        CASE
            WHEN college_eligibility_gpa_11th_grade <3.25
            AND college_eligibility_gpa_11th_grade >=2.75 THEN 1
        END AS x_11_cgpa_275_325,
        CASE
            WHEN college_eligibility_gpa_11th_grade <2.75 THEN 1
        END AS x_11_cgpa_below_275,
    readiness_composite_off_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE AT_Grade_c = "12th Grade"
    AND term_c = "Spring"
),

join_data AS
(    
    SELECT
    gy.*,
    gsd.*
    
    FROM
    gather_year_1_enrolled gy
    LEFT JOIN gather_student_data gsd ON gsd.Contact_Id = gy.at_contact_id
)

    SELECT
    school_c AS account_id,
    AT_School_Name AS college_name,
    site_short,
    high_school_graduating_class_c,
    readiness_composite_off_c,
    x_11_cgpa_bucket,
    COUNT(DISTINCT(Contact_Id)) AS total_students,
    
    SUM(x_12_cgpa) AS avg_12_cgpa_num,
    SUM(x_12_cgpa_325) AS x_12_cgpa_325_percent_num,
    SUM(x_12_cgpa_275_325) AS x_12_cgpa_275_325_percent_num,
    SUM(x_12_cgpa_below_275) AS x_12_cgpa_below_275_percent_num,
    SUM(CASE
        WHEN x_12_cgpa IS NOT NULL THEN 1
        ELSE 0
    END) AS x_12_cgpa_denom,
    
    SUM(x_11_cgpa) AS avg_11_cgpa_num,
    SUM(x_11_cgpa_325) AS x_11_cgpa_325_percent_num,
    SUM(x_11_cgpa_275_325) AS x_11_cgpa_275_325_percent_num,
    SUM(x_11_cgpa_below_275) AS x_11_cgpa_below_275_percent_num,
    SUM(CASE
        WHEN x_11_cgpa IS NOT NULL THEN 1
        ELSE 0
    END) AS x_11_cgpa_denom,
    
    SUM(f_at_term_gpa) AS f_at_term_gpa_num,
    SUM(CASE
        WHEN f_at_term_gpa IS NOT NULL THEN 1
        ELSE 0
    END) AS f_at_term_gpa_denom,
    
    SUM(es_fulltime) AS es_ft_num,
    SUM(es_parttime) AS es_pt_num,
    SUM(es_other) AS es_o_num,
    SUM(es_fulltime+es_parttime+es_other) AS es_denom,
    
    SUM(s_year_1_cgpa) AS s_year_1_cgpa_num,
    SUM(
        CASE
        WHEN s_year_1_cgpa IS NOT NULL THEN 1
        ELSE 0
    END) AS s_year_1_cgpa_denom,
    
    SUM(s_year_1_c_credits) AS s_year_1_c_credits_num,
    SUM(
        CASE
        WHEN s_year_1_c_credits IS NOT NULL THEN 1
        ELSE 0
    END) AS s_year_1_c_credits_denom,
    
    "" AS dummy_dimension
    
    FROM join_data
    GROUP BY AT_School_Name,school_c, site_short, high_school_graduating_class_c, x_11_cgpa_bucket, readiness_composite_off_c
