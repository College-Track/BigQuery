    SELECT
    Contact_Id,
    current_college_clean AS college_name,
    a.id AS account_id,
    "Spring" AS cs_term,
    
    
    CASE
        WHEN i_felt_i_belonged_on_my_college_campus IS NULL THEN NULL
        WHEN i_felt_i_belonged_on_my_college_campus IN ("Agree") THEN 1
        ELSE 0
    END AS cs_belong_num,
    i_felt_i_belonged_on_my_college_campus,
    
    
    most_students_i_met_were_focused_on_getting_a_bachelors_degree AS cs_student_ba_focus,
    my_college_is_culturally_competenthelp_note_i_felt_that_the_adults_on_campus_hel AS cs_cultural_comp,
    
    i_could_pay_for_tuition_and_living_expenses AS cs_afford_school
    
    FROM `data-warehouse-289815.surveys.fy20_ps_survey`
    LEFT JOIN `data-warehouse-289815.salesforce.account` a ON name = current_college_clean
    
    WHERE are_you_currently_in_your_freshman_year_of_college = "Yes"
