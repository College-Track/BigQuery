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
 #,prep AS(
   
        SELECT
    g.site_short,
        (SELECT CASE WHEN SUM(student_has_aspirations) >= 6 THEN 1 ELSE 0 END AS sum_asp
        FROM gather AS subq1 
        WHERE g.contact_id=subq1.contact_id
        group by subq1.contact_id) AS total_aspirations ,
        
        (SELECT CASE WHEN SUM(aspirations_affordable) >=3 THEN 1 ELSE 0 END AS sum_aff
        FROM gather AS subq1 
        WHERE g.contact_id=subq1.contact_id
        group by subq1.contact_id) AS total_affordable 
        
    FROM gather as g
    join gather as subq1 ON g.contact_id=subq1.contact_id
    
    group by g.site_short,g.contact_id
)