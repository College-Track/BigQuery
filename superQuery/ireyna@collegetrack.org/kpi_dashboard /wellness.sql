SELECT
        student_c,
        site_short,
        AY_Name,
        MAX(CASE
            WHEN co_vitality_scorecard_color_c IN ('Blue','Red')
            THEN 1
            ELSE NULL
        END) AS wellness_blue_red_denom
FROM `data-warehouse-289815.salesforce_clean.contact_at_template` 
WHERE grade_c != '8th Grade'
    AND college_track_status_c = '11A'
    AND AY_NAME = "AY 2020-21"
    AND Term_c = "Fall"
    AND grade_c != '8th Grade'
    AND co_vitality_scorecard_color_c IN ('Blue','Red')
GROUP BY 
    student_c,
    site_short,
    AY_Name