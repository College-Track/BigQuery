WITH gather_rubric_data AS
(
    SELECT
    contact_id AS rubric_contact_id,
    financial_score_color,
    academic_score_color,
    wellness_score_color,
    career_score_color

    FROM 
    `data-studio-260217.college_rubric.filtered_college_rubric`
)

    
    SELECT
    * except (filter_contact_id, rubric_contact_id),
    CASE
        WHEN REGEXP_CONTAINS(which_of_the_factors_are_most_responsible_for_you_not_feelin,"Staff turnover / I don't know the staff anymore") THEN 1
        ELSE 0
    END AS staff_turnover_count,
    CASE
        WHEN REGEXP_CONTAINS(which_of_the_factors_are_most_responsible_for_you_not_feelin,"I'm too busy / too much time required to maintain that connection") THEN 1
        ELSE 0
    END AS too_busy_count,
    CASE
        WHEN REGEXP_CONTAINS(which_of_the_factors_are_most_responsible_for_you_not_feelin, "I rarely see or hear from anyone at College Track besides my CT college advisor") THEN 1
        ELSE 0
    END AS rarely_hear_count,
    CASE
        WHEN REGEXP_CONTAINS(which_of_the_factors_are_most_responsible_for_you_not_feelin, "I'm in other programs / use school resources that also provide support services") THEN 1
        ELSE 0
    END AS other_program_count,
    CASE
        WHEN REGEXP_CONTAINS(which_of_the_factors_are_most_responsible_for_you_not_feelin, "I'm thriving at college / just don't feel I need much support") THEN 1
        ELSE 0
    END AS thriving_count,
    CASE
        WHEN REGEXP_CONTAINS(which_of_the_factors_are_most_responsible_for_you_not_feelin, "Other (please specify in text box below)") THEN 1
        ELSE 0
    END AS other_count,
    CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Career advice & exploration") THEN 1
        ELSE 0
    END AS career_advice_count,
    
    CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Graduate school information") THEN 1
        ELSE 0
    END AS grad_school_info_count,
    CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Handling personal finances") THEN 1
        ELSE 0
    END AS personal_finances_count,
    CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Job, internship, & volunteer opprotunities") THEN 1
        ELSE 0
    END AS career_opps_count,
    CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Networking & building connections") THEN 1
        ELSE 0
    END AS networking_count,
    CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Resume, application, & interview advice") THEN 1
        ELSE 0
    END AS resume_count,
    CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Starting a business") THEN 1
        ELSE 0
    END AS starting_biz_count,
     CASE
        WHEN REGEXP_CONTAINS(what_types_of_support_resources_information_would_you_be_int,"Work life balance") THEN 1
        ELSE 0
    END AS work_life_count,

    FROM `data-studio-260217.surveys.fy21_ps_survey`
    LEFT JOIN `data-studio-260217.surveys.fy21_ps_survey_filters_clean` ON filter_contact_id = contact_id
    LEFT JOIN gather_rubric_data ON gather_rubric_data.rubric_contact_id = contact_id
    WHERE site_short IS NOT NULL