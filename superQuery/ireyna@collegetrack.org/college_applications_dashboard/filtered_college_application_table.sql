SELECT
    student_c AS contact_id_accepted, #contact id
    accnt.name AS school_name_accepted,
    app.id AS college_accepted_app_id,
    CASE 
        WHEN admission_status_c = "Accepted" OR admission_status_c = "Accepted and Enrolled" OR admission_status_c = "Accepted and Deferred" 
        THEN 1
        ELSE 0
    END AS accepted,
    
    CASE 
        WHEN ((admission_status_c = "Accepted") AND (College_Fit_Type_Applied_c = "None") AND (app.Predominant_Degree_Awarded_c IN ("Predominantly associate's-degree granting", "Predominantly certificate-degree granting", "Not classified")))  THEN "None - 2-year or technical"
        WHEN ((admission_status_c = "Accepted") AND (College_Fit_Type_Applied_c = "None") AND (app.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting")) THEN "None - 4-year"
        WHEN admission_status_c = "Accepted" THEN  College_Fit_Type_Applied_c
        WHEN ((admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")) AND (fit_type_enrolled_c = "None") AND (app.Predominant_Degree_Awarded_c IN ("Predominantly associate's-degree granting", "Predominantly certificate-degree granting", "Not classified")))  THEN "None - 2-year or technical"
        WHEN ((admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")) AND (fit_type_enrolled_c = "None") AND (app.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting")) THEN "None - 4-year"
        ELSE fit_type_enrolled_c
    END AS fit_type_accepted
    
FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app
LEFT JOIN `data-warehouse-289815.salesforce.account` AS accnt
        ON app.College_University_c = accnt.id