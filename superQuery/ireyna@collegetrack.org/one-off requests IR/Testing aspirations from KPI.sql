 SELECT
        full_name_c,contact_id,
        site_short,
        --10th Grade EFC, FAFSA4Caster only
        MAX(CASE
            WHEN (
                c.grade_c = "10th Grade"
                AND FA_Req_Expected_Financial_Contribution_c IS NOT NULL
                AND fa_req_efc_source_c = 'FAFSA4caster'
            ) THEN 1
            ELSE 0
        END) AS hs_EFC_10th_count,
        MAX(CASE
            WHEN (
                c.grade_c = "10th Grade"
                AND college_track_status_c = '11A'
            ) THEN 1
            ELSE 0
        END) AS hs_EFC_10th_denom_count,
        --11th Grade Aspirations, any Aspiration
        MAX(CASE
            WHEN (
                c.grade_c = '11th Grade'
                AND college_track_status_c = '11A'
                AND a.id IS NOT NULL
            ) THEN 1
            ELSE 0
        END) AS aspirations_any_count,
        --11th Grade Aspirations, Affordable colleges
        MAX(CASE
            WHEN (
                c.grade_c = '11th Grade'
                AND fit_type_current_c IN ("Best Fit", "Good Fit", "Local Affordable")
            ) THEN 1
            ELSE 0
        END) AS aspirations_affordable_count,
        --11th Grade Aspirations reporting group        
        MAX(CASE
            WHEN (
                c.grade_c = '11th Grade'
                AND college_track_status_c = '11A'
            ) THEN 1
            ELSE 0
        END) AS aspirations_denom_count
    FROM
        `data-warehouse-289815.salesforce_clean.contact_template` AS c
        LEFT JOIN `data-warehouse-289815.salesforce.college_aspiration_c` a ON c.contact_id = a.student_c
        where  c.grade_c IN ('11th Grade','10th Grade')
        AND college_track_status_c = '11A'
        group by site_short, contact_id, full_name_c