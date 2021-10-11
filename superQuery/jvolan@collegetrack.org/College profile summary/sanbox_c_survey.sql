    SELECT
    Contact_Id,
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
        WHEN in_the_past_12th_months_were_you_involved_in_a_club_organization_at_your_college = "Yes" THEN 1
        ELSE 0
    END AS cs_club_participation,
    
    FROM `data-warehouse-289815.surveys.fy20_ps_survey`
    LEFT JOIN `data-warehouse-289815.salesforce.account` a ON name = current_college_clean
    
    WHERE are_you_currently_in_your_freshman_year_of_college = "Yes"
