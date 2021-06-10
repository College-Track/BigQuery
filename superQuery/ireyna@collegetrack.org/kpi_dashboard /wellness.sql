SELECT 
    COUNT (DISTINCT id) AS case_note_id, #case note id
    site_short

FROM `data-warehouse-289815.salesforce_clean.contact_at_template` CAT
LEFT JOIN `data-warehouse-289815.salesforce.progress_note_c` CSE ON CAT.AT_Id = CSE.Academic_Semester_c
WHERE Type_Counseling_c = TRUE
    AND AY_name = 'AY 2020-21'
    AND college_track_status_c = '11A'
    AND co_vitality_scorecard_color_c IN ('Blue','Red')
GROUP BY
    site_short