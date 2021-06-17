SELECT
        contact_id,
        site_short,
        co_vitality_scorecard_color_c,
   MAX(CASE
            WHEN co_vitality_scorecard_color_c IN ('Blue','Red')
            THEN 1
            ELSE NULL
        END) AS wellness_blue_red_denom,
        
        Ethnic_background_c,
        Gender_c
FROM `data-warehouse-289815.salesforce_clean.contact_at_template` 
WHERE grade_c != '8th Grade'
    AND college_track_status_c = '11A'
    AND AY_NAME = "AY 2020-21"
    AND Term_c = "Fall"
GROUP BY 
    contact_Id,
    site_short,
    co_vitality_scorecard_color_c,
    Ethnic_background_c,
    Gender_c