SELECT
    Contact_Id,
    site_short,
    estimated_family_contribution_c,
    CASE
        WHEN estimated_family_contribution_c IS NOT NULL THEN 1
        ELSE estimated_family_contribution_c
    END AS cc_hs_EFC_10th,
    (SELECT subq.student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS subq
        WHERE subq.admission_status_c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred")
        AND subq.College_Fit_Type_Applied_c IN ("Best Fit","Good Fit","Situational")
        AND Contact_Id=subq.student_c
        group by subq.student_c
        ) AS  applied_best_good_situational,
        
FROM `data-warehouse-289815.salesforce_clean.contact_template` AS Contact   
LEFT JOIN `data-warehouse-289815.salesforce_clean.college_application_clean` AS CollegeApp 
        ON Contact.contact_id = CollegeApp.student_c 
  WHERE
    grade_c = '12th Grade'
    AND college_track_status_c = '11A'