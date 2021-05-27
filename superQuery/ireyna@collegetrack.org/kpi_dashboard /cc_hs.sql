  SELECT
        contact_id,
        site_short,
            
     --11th Grade Aspirations, any Aspiration
        SUM(CASE 
            WHEN a.id IS NOT NULL 
            THEN 1
            ELSE 0
            END) AS aspirations_any_count,
            
    --11th Grade Aspirations, Affordable colleges
        SUM(CASE
            WHEN fit_type_current_c IN ("Best Fit","Good Fit","Local Affordable") 
            THEN 1
            ELSE 0
            END) AS aspirations_affordable_count,
            
    --11th Grade Aspirations reporting group        
        SUM(CASE 
            WHEN (c.grade_c = '11th Grade'
            AND college_track_status_c = '11A') THEN 1
            ELSE 0
            END) AS aspirations_denom_count
            
    FROM `data-warehouse-289815.salesforce_clean.contact_template` AS c
    LEFT JOIN`data-warehouse-289815.salesforce.college_aspiration_c` a ON c.contact_id=a.student_c
    WHERE college_track_status_c = '11A'
    GROUP BY
        contact_id,
        site_short