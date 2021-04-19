 student_c,
        fit_type_current_c,
        
        CASE 
            WHEN a.id IS NOT NULL THEN 1
            ELSE 0
            END AS student_has_aspirations,
    
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce.college_aspiration_c` AS subq1
        WHERE fit_type_current_c IN ("Best Fit","Good Fit","Local Affordable")
        AND Contact_Id=student_c
        group by student_c
        ) AS aspirations_affordable,
    
    FROM `data-warehouse-289815.salesforce.college_aspiration_c` a 
        LEFT JOIN`data-warehouse-289815.salesforce_clean.contact_template` c ON c.contact_id=a.student_c
    
    WHERE college_track_status_c = '11A'
    AND c.grade_c = '11th Grade'