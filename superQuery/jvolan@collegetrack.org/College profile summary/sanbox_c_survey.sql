    SELECT
    Contact_Id,
    current_college_clean,
    
    
    i_felt_i_belonged_on_my_college_campus AS cs_belong_on_campus,
    most_students_i_met_were_focused_on_getting_a_bachelors_degree AS cs_student_ba_focus,
    my_college_is_culturally_competenthelp_note_i_felt_that_the_adults_on_campus_hel AS cs_cultural_comp,
    
    i_could_pay_for_tuition_and_living_expenses AS cs_afford_school,
    
    
    
    FROM `data-warehouse-289815.surveys.fy20_ps_survey`
    WHERE are_you_currently_in_your_freshman_year_of_college = "Yes"