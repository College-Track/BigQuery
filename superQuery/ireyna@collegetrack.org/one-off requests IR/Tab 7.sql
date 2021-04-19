WITH GATHER AS 
(
     
    SELECT 
        contact_id,
        site_short,
        
        CASE 
            WHEN a.id IS NOT NULL THEN 1
            ELSE 0
            END AS student_has_aspirations,
        
        CASE
            WHEN fit_type_current_c IN ("Best Fit","Good Fit","Local Affordable") THEN 1
            ELSE 0
            END AS aspirations_affordable
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template` c 
        LEFT JOIN`data-warehouse-289815.salesforce.college_aspiration_c` a ON c.contact_id=a.student_c
    
    WHERE college_track_status_c = '11A'
    AND c.grade_c = '11th Grade'
   )
   
        SELECT *,
        
        CASE 
            WHEN SUM(student_has_aspirations) >= 6 THEN 1
            ELSE 0
            END AS cc_hs_aspirations_count,
        
        CASE 
            WHEN SUM(aspirations_affordable) >= 3 THEN 1
            ELSE 0
            END AS cc_hs_aspirations_affordable_count
        
    FROM gather
    GROUP BY contact_id, site_short, student_has_aspirations,aspirations_affordable
    
   