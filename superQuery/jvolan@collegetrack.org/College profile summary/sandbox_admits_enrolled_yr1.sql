WITH gather_college_survey AS
(
    SELECT
    Contact_Id AS cs_contact_id,
    current_college_clean AS college_name,
    a.id AS account_id,
    "Spring" AS cs_term,
    
    --% agreed vs. disagree for key college survey transition Qs
     CASE
        WHEN i_could_pay_for_tuition_and_living_expenses IS NULL THEN NULL
        ELSE 1
    END AS cs_afford_school_denom,
    CASE
        WHEN i_could_pay_for_tuition_and_living_expenses IN ("Strongly Agree", "Agree") THEN 1
        ELSE 0
    END AS cs_afford_school_agree,
      CASE
        WHEN i_could_pay_for_tuition_and_living_expenses IN ("Strongly Disagree", "Disagree") THEN 1
        ELSE 0
    END AS cs_afford_school_disagree,
    
    
    
    CASE
        WHEN i_felt_i_belonged_on_my_college_campus IS NULL THEN NULL
        ELSE 1
    END AS cs_belong_denom,
    CASE
        WHEN i_felt_i_belonged_on_my_college_campus IN ("Strongly Agree", "Agree") THEN 1
        ELSE 0
    END AS cs_belong_agree,
      CASE
        WHEN i_felt_i_belonged_on_my_college_campus IN ("Strongly Disagree", "Disagree") THEN 1
        ELSE 0
    END AS cs_belong_disagree,
    
    CASE
        WHEN most_students_i_met_were_focused_on_getting_a_bachelors_degree IS NULL THEN NULL
        ELSE 1
    END AS cs_ba_focus_denom,
    CASE
        WHEN most_students_i_met_were_focused_on_getting_a_bachelors_degree IN ("Strongly Agree", "Agree") THEN 1
        ELSE 0
    END AS cs_ba_focus_agree,
      CASE
        WHEN most_students_i_met_were_focused_on_getting_a_bachelors_degree IN ("Strongly Disagree", "Disagree") THEN 1
        ELSE 0
    END AS cs_ba_focus_disagree,
    
    CASE
        WHEN my_college_is_culturally_competenthelp_note_i_felt_that_the_adults_on_campus_hel IS NULL THEN NULL
        ELSE 1
    END AS cs_cultural_comp_denom,
    CASE
        WHEN my_college_is_culturally_competenthelp_note_i_felt_that_the_adults_on_campus_hel IN ("Strongly Agree", "Agree") THEN 1
        ELSE 0
    END AS cs_cultural_comp_agree,
      CASE
        WHEN my_college_is_culturally_competenthelp_note_i_felt_that_the_adults_on_campus_hel IN ("Strongly Disagree", "Disagree") THEN 1
        ELSE 0
    END AS cs_cultural_comp_disagree,
    
    CASE
        WHEN in_the_past_12th_months_were_you_involved_in_a_club_organization_at_your_college IS NULL THEN NULL
        WHEN in_the_past_12th_months_were_you_involved_in_a_club_organization_at_your_college IN ("Yes, more than one club/organization","Yes, one club/organization") THEN 1
        ELSE 0
    END AS cs_club_participation,
    
    CASE
        WHEN in_the_past_12_months_did_you_have_a_job_to_help_you_pay_the_bills_which_was_not IS NULL THEN NULL
        WHEN in_the_past_12_months_did_you_have_a_job_to_help_you_pay_the_bills_which_was_not = "No, I did not have that type of job during college" THEN 0
        ELSE 1
    END AS cs_needed_job_yn,
    
    CASE
        WHEN in_the_past_12_months_did_you_have_a_job_to_help_you_pay_the_bills_which_was_not = "No, I did not have that type of job during college" THEN NULL
        WHEN in_the_past_12_months_did_you_have_a_job_to_help_you_pay_the_bills_which_was_not IN ("Yes, I need/needed to work 20-30 hours per week", "Yes, I need/needed to work 30-40 hours per week", "Yes, I need/needed to work 40 hours or more per week") THEN 1
        ELSE 0
    END AS cs_job_20_hours,
    
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
    
    cs_afford_school_denom,
    cs_afford_school_agree,
    cs_afford_school_disagree,
    cs_belong_denom,
    cs_belong_agree,
    cs_belong_disagree,
    cs_ba_focus_denom,
    cs_ba_focus_agree,
    cs_ba_focus_disagree,
    cs_cultural_comp_denom,
    cs_cultural_comp_agree,
    cs_cultural_comp_disagree,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    LEFT JOIN gather_college_survey ON cs_contact_id = Contact_Id AND cs_term = term_c
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
    s_year_1_cgpa_bucket,
    COUNT(DISTINCT(Contact_Id)) AS student_count,
    COUNT(AT_School_Name) AS at_count,
    
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
    
    SUM(w_at_term_gpa) AS w_at_term_gpa_num,
    SUM(CASE
        WHEN w_at_term_gpa IS NOT NULL THEN 1
        ELSE 0
    END) AS w_at_term_gpa_denom,
    
    SUM(s_at_term_gpa) AS s_at_term_gpa_num,
    SUM(CASE
        WHEN s_at_term_gpa IS NOT NULL THEN 1
        ELSE 0
    END) AS s_at_term_gpa_denom,
    
    SUM(es_fulltime) AS es_ft_num,
    SUM(es_parttime) AS es_pt_num,
    SUM(es_other) AS es_o_num,
    SUM(es_fulltime+es_parttime+es_other) AS es_denom,
    
    SUM(s_year_1_c_credits) AS s_year_1_c_credits_num,
    SUM(
        CASE
        WHEN s_year_1_c_credits IS NOT NULL THEN 1
        ELSE 0
    END) AS s_year_1_c_credits_denom,
    
    SUM(s_year_1_cgpa) AS s_year_1_cgpa_num,
    SUM(
        CASE
        WHEN s_year_1_cgpa IS NOT NULL THEN 1
        ELSE 0
    END) AS s_year_1_cgpa_denom,

    
    SUM(at_gpa_standing_flag) AS at_gpa_standing_flag_num,
    
    MAX(CASE
        WHEN s_year_1_cgpa_bucket = "3.25+" THEN 1
        WHEN s_year_1_cgpa_bucket = "2.75-3.25" THEN 2
        WHEN s_year_1_cgpa_bucket = "Below 2.75" THEN 3
    END) AS s_year_1_cgpa_bucket_sort,
    
    SUM(first_year_loan_debt_c) AS first_year_loan_debt_num,
    SUM(CASE
        WHEN first_year_loan_debt_c IS NOT NULL THEN 1
        ELSE 0
    END) AS first_year_loan_debt_denom,
    
    SUM(ar_loans_at_risk_30k_num) AS ar_loans_at_risk_30k_num,
    SUM(ar_loans_at_risk_30k_denom) AS ar_loans_at_risk_30k_denom,
    
    SUM(ar_ability_to_pay_full_cost_num) AS ar_ability_to_pay_full_cost_num,
    SUM(ar_ability_to_pay_full_cost_denom) AS ar_ability_to_pay_full_cost_denom,
    
    SUM(year_1_math_pass_num) AS year_1_math_pass_num,
    SUM(CASE
        WHEN year_1_college_math_course_grade_c IS NOT NULL THEN 1
        ELSE 0
    END) AS year_1_math_pass_denom,
    CASE
        WHEN first_year_college_math_course_c = "No math course taken in year 1" THEN NULL
        ELSE first_year_college_math_course_c
    END AS first_year_college_math_course_c,
    
    ROUND(AVG(avg_sap_percent_at),0) AS avg_sap_percent_at,
    SUM(met_sap_requirement_6667_num) AS met_sap_requirement_6667_num,
    SUM(sap_at_denom) AS sap_at_denom,
    
    SUM(cs_afford_school_denom) AS cs_afford_school_denom,
    SUM(cs_afford_school_agree) AS cs_afford_school_agree,
    SUM(cs_afford_school_disagree) AS cs_afford_school_disgree,
    
    SUM(cs_belong_denom) AS cs_belong_denom,
    SUM(cs_belong_agree) AS cs_belong_agree,
    SUM(cs_belong_disagree) AS cs_belong_disagree,
    
    SUM(cs_ba_focus_denom) AS cs_ba_focus_denom,
    SUM(cs_ba_focus_agree) AS cs_ba_focus_agree,
    SUM(cs_ba_focus_disagree) AS cs_ba_focus_disagree,
    
    SUM(cs_cultural_comp_denom) AS cs_cultural_comp_denom,
    SUM(cs_cultural_comp_agree) AS cs_cultural_comp_agree,
    SUM(cs_cultural_comp_disagree) AS cs_cultural_comp_disagree,
    

    "" AS dummy_dimension,

    
    FROM join_data
    GROUP BY AT_School_Name,school_c, site_short, high_school_graduating_class_c, x_11_cgpa_bucket, readiness_composite_off_c, first_year_college_math_course_c, s_year_1_cgpa_bucket
