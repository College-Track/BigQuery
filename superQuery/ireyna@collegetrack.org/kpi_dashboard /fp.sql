  SELECT 
        contact_id,
        site_short,
    
    --Students accepted to Best Fit
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS subq1
        WHERE (admission_status_c = "Accepted" AND College_Fit_Type_Applied_c = "Best Fit")
        AND Contact_Id=student_c
        group by student_c
        ) AS accepted_best_fit,
        
    --Students enrolled in Best Fit
        (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS subq2
        WHERE admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred") AND fit_type_enrolled_c = "Best Fit"
        AND Contact_Id=student_c
        group by student_c
        ) AS accepted_enrolled_best_fit
      
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE  college_track_status_c = '11A'
    AND (grade_c = "12th Grade" OR (grade_c='Year 1' AND indicator_years_since_hs_graduation_c = 0))