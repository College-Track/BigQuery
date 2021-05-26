  SELECT 
        contact_id,
        site_short,
        type_c,
        semester_c,
        AY_name,
        CASE
            WHEN (sl.id IS NOT NULL 
            AND AY_name = 'AY 2019-20'
            AND term_c = 'Summer'
            AND (indicator_completed_ct_hs_program_c = TRUE OR college_track_status_c = '11A')) THEN 1
            ELSE 0
            END AS mse_completed_prev_AY,
        CASE
            WHEN (sl.id IS NOT NULL 
            AND AY_name = 'AY 2020-21'
            AND term_c = 'Summer') THEN 1
            ELSE 0
            END AS mse_completed_current_AY,
        CASE 
            WHEN (competitive_c = True 
            AND AY_name = 'AY 2019-20'
            AND term_c = 'Summer'
            AND (indicator_completed_ct_hs_program_c = TRUE OR college_track_status_c = '11A')) THEN 1
            ELSE 0
            END AS mse_competitive_prev_AY,
        CASE 
            WHEN (competitive_c = True 
            AND term_c = 'Summer'
            AND AY_name = 'AY 2020-21') THEN 1
            ELSE 0
            END AS mse_competitive_current_AY,
        CASE
            WHEN (type_c = 'Internship' 
            AND AY_name = 'AY 2019-20'
            AND (indicator_completed_ct_hs_program_c = TRUE OR college_track_status_c = '11A')) THEN 1
            ELSE 0
            END AS mse_internship_prev_AY,
        CASE
            WHEN (type_c = 'Internship' 
            AND AY_name = 'AY 2020-21') THEN 1
            ELSE 0
            END AS mse_internship_current_AY
            
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template` AS c
        LEFT JOIN `data-warehouse-289815.salesforce.student_life_activity_c` AS sl ON c.at_id = sl.semester_c
        
    WHERE sl.record_type_id = '01246000000ZNi8AAG' #Summer Experience
    AND AY_name IN ('AY 2020-21', 'AY 2019-20')
    #AND term_c = 'Summer'
    AND experience_meaningful_c = True
    AND status_c = 'Approved'