WITH gather_data AS (
  SELECT
    Contact_Id,
    site_short,
    grade_c,
    FA_Req_Expected_Financial_Contribution_c,
    fa_req_efc_source_c,
    CASE
        WHEN (FA_Req_Expected_Financial_Contribution_c IS NOT NULL) AND (fa_req_efc_source_c = 'FAFSA4caster') THEN 1
        ELSE 0
    END AS hs_EFC_10th,
    
    (SELECT student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS subquery_collegeapp
        LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template`AS subquery_contact
            ON subquery_contact.contact_id = subquery_collegeapp.student_c 
        #WHERE subq.admission_status_c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred")
        WHERE College_Fit_Type_Applied_c IN ("Best Fit","Good Fit","Situational")
        AND Contact_Id=student_c
        group by subquery_collegeapp.student_c
        ) AS applied_best_good_situational,
        
FROM `data-warehouse-289815.salesforce_clean.contact_template` AS Contact   
LEFT JOIN `data-warehouse-289815.salesforce_clean.college_application_clean` AS CollegeApp 
        ON Contact.contact_id = CollegeApp.student_c 
        
AND college_track_status_c = '11A'
)
  SELECT
    site_short,
    COUNT(DISTINCT applied_best_good_situational) AS cc_hs_best_good_situational,
    SUM(hs_EFC_10th) AS cc_hs_EFC_10th
  FROM
    gather_data
  GROUP BY
    site_short



