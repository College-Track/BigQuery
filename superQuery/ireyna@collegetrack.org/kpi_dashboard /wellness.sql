SELECT
        student_c,
        site_short,
        SUM(CASE
            WHEN co_vitality_scorecard_color_c IN ('Blue','Red')
            THEN 1
            ELSE 0
        END) AS wellness_blue_red_num
FROM `data-warehouse-289815.salesforce_clean.contact_at_template` 
WHERE grade_c != '8th Grade'
    AND college_track_status_c = '11A'
GROUP BY 
    student_c
    site_short