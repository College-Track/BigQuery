SELECT besides_my_ct_college_advisor_i_have_at_least_one_ct_staff_m, COUNT(*)
FROM `data-studio-260217.surveys.fy21_ps_survey`
WHERE site_short = "Sacramento"
GROUP BY besides_my_ct_college_advisor_i_have_at_least_one_ct_staff_m