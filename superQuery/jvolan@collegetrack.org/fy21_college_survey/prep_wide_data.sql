 SELECT
    *,
    CASE
        WHEN REGEXP_CONTAINS("which_of_the_factors_are_most_responsible_for_you_not_feelin	","Staff turnover / I don't know the staff anymore") THEN 1
        ELSE 0
    END AS staff_turnover_count,
    CASE
        WHEN "Which of the factors are most responsible for you not feeling as connected to College Track?(select all that apply)" IN ("I'm too busy / too much time required to maintain that connection") THEN 1
        ELSE 0
    END AS too_busy_count,
    CASE
        WHEN "Which of the factors are most responsible for you not feeling as connected to College Track?(select all that apply)" IN ("I rarely see or hear from anyone at College Track besides my CT college advisor") THEN 1
        ELSE 0
    END AS rarely_hear_count,
    CASE
        WHEN "Which of the factors are most responsible for you not feeling as connected to College Track?(select all that apply)" IN ("I'm in other programs / use school resources that also provide support services") THEN 1
        ELSE 0
    END AS other_program_count,
    CASE
        WHEN "Which of the factors are most responsible for you not feeling as connected to College Track?(select all that apply)" IN ("I'm thriving at college / just don't feel I need much support") THEN 1
        ELSE 0
    END AS thriving_count,
     CASE
        WHEN "Which of the factors are most responsible for you not feeling as connected to College Track?(select all that apply)" IN ("Other (please specify in text box below)") THEN 1
        ELSE 0
    END AS other_count,

    FROM `data-studio-260217.surveys.fy21_ps_survey`
    LEFT JOIN `data-studio-260217.surveys.fy21_ps_survey_filters_clean` ON `data-studio-260217.surveys.fy21_ps_survey_filters_clean`.filter_contact_id = contact_id
    WHERE site_short IS NOT NULL