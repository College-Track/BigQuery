SELECT
    *,

    FROM `data-studio-260217.surveys.fy21_ps_survey`
    LEFT JOIN `data-studio-260217.surveys.fy21_ps_survey_filters_clean` ON `data-studio-260217.surveys.fy21_ps_survey_filters_clean`.filter_contact_id = contact_id
    WHERE site_short IS NOT NULL