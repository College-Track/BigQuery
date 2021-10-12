SELECT
    --institutional details
    id AS account_id,
    name AS college_name,
    control_of_institution_value_c,
    level_of_institution_c,
    academic_calendar_category_c,
    minimum_credits_required_to_graduate_c,
    college_partnership_type_c,
    billing_state,
    CASE
        WHEN website IS NULL THEN CONCAT("http://www.google.com/search?q=",name, "+", billing_state)
        ELSE website
    END AS website,
    ipeds_id_c,
    best_fit_college_c,
    
    --common ct school grouping
    CASE
        WHEN historically_black_college_univ_hbcu_c = TRUE THEN "HBCU"
        WHEN hispanic_serving_institution_hsi_c = TRUE THEN "HSI"
        WHEN 
            (name IN
            ("California Polytechnic State University-San Luis Obispo",
            "California State Polytechnic University-Pomona",
            "Humboldt State University",
            "San Diego State University",
            "San Jose State University",
            "Sonoma State University")
            OR
            STARTS_WITH (name, "California State University")) THEN "CSU"
        WHEN 
            STARTS_WITH (name, "University of California") THEN "UC"
        ELSE NULL
    END AS ct_common_college_groups,



    --enrollment and admits
    college_admit_rate_c/100 AS college_admit_rate_decimal,
    sat_c AS SAT_combined_avg,
    act_composite_average_c,
    gpa_average_c,
    total_undergraduate_enrollment_c,
    
    -- enrollment by ethnicity charts
    of_undergrad_enrollment_asian_c/100 AS of_undergrad_enrollment_asian_c,
    of_undergrad_enrollment_black_c/100 AS of_undergrad_enrollment_black_c,
    of_undergrad_enrollment_hispanic_c/100 AS of_undergrad_enrollment_hispanic_c,
    of_undergrad_enrollment_api_c/100 AS of_undergrad_enrollment_api_c,
    of_undergrad_enrollment_white_c/100 AS of_undergrad_enrollment_white_c,
    
    --cost & graduation
    in_state_tuition_and_fees_c,
    out_of_state_tuition_and_fees_c,
    receiving_federal_student_loans_c/100 AS receiving_federal_student_loans_c,
    receiving_pell_grant_c/100 AS receiving_pell_grant_c,
    average_aid_c AS avg_financial_aid_package,
    
    --debt & graduation
    graduates_with_debt_c/100 AS graduates_with_debt_c,
    avg_debt_of_graduates_c,
    median_debt_of_graduates_c,
    
    
    graduation_rate_overall_c/100 AS graduation_rate_overall_c,
    graduation_rate_asian_c/100 AS graduation_rate_asian_c,
    graduation_rate_pacific_islander_c/100 AS graduation_rate_pacific_islander_c,
    graduation_rate_black_african_american_c/100 AS graduation_rate_black_african_american_c,
    graduation_rate_hispanic_c/100 AS graduation_rate_hispanic_c,

    last_data_import_completed_c,
    
    FROM `data-warehouse-289815.salesforce.account`
    WHERE record_type_id = "01246000000RNnLAAW"