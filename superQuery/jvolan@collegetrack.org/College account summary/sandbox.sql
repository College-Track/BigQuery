SELECT
    id AS account_id,
    name AS college_name,
    control_of_institution_value_c,
    level_of_institution_c,
    academic_calendar_category_c,
    minimum_credits_required_to_graduate_c,
    best_fit_college_c,
    college_partnership_type_c,
    
    --uploaded publicly available data
    college_admit_rate_c,
    sat_c AS SAT_combined_avg,
    act_composite_average_c,
    gpa_average_c,
    
    --enrollment and cost
    total_undergraduate_enrollment_c,
    in_state_tuition_and_fees_c,
    out_of_state_tuition_and_fees_c,
    receiving_federal_student_loans_c,
    receiving_pell_grant_c,
    average_aid_c AS avg_financial_aid_package,
    
    --debt & graduation
    graduates_with_debt_c,
    avg_debt_of_graduates_c,
    median_debt_of_graduates_c,
    graduation_rate_overall_c,
    
    FROM `data-warehouse-289815.salesforce.account`
    WHERE record_type_id = "01246000000RNnLAAW"