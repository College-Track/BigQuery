SELECT
    site_short AS survey_site_short,
    CASE
        WHEN contact_id IS NOT NULL THEN 1
        ELSE 0
    END AS ps_survey_scholarship_denom,
    CASE
        WHEN i_am_able_to_receive_my_scholarship_funds_from_college_track IN ('StronglyAgree', 'Strongly Agree', 'Agree') THEN 1
        ELSE 0
    END AS ps_survey_scholarship_num
    
    FROM  `data-studio-260217.surveys.fy21_ps_survey_wide_prepped`
    WHERE i_am_able_to_receive_my_scholarship_funds_from_college_track IS NOT NULL