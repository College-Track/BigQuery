SELECT
        contact_id,
        site_short,
        
         --10th Grade EFC, FAFSA4Caster only
        CASE
            WHEN (c.grade_c = "10th Grade" 
            AND FA_Req_Expected_Financial_Contribution_c IS NOT NULL 
            AND fa_req_efc_source_c = 'FAFSA4caster') THEN 1
            ELSE 0
            END AS hs_EFC_10th_count,
            
        CASE
            WHEN (c.grade_c = "10th Grade" 
            AND college_track_status_c = '11A') THEN 1
            ELSE 0
            END AS hs_EFC_10th_denom_count

FROM `data-warehouse-289815.salesforce_clean.contact_template` AS c
WHERE college_track_status_c = '11A'
    AND grade_c = '10th Grade'