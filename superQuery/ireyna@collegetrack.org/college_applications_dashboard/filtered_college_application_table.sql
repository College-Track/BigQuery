student_c AS contact_id_admissions,
    accnt.name AS school_name_enrolled,
    app.id AS college_enrolled_app_id,
    Type_of_School_c as school_type_enrolled,
    
    CASE
        WHEN admission_status_c IS NULL THEN "Admission Status Not Yet Updated"
        ELSE admission_status_c
    END AS admission_status_c,
    
    CASE
        WHEN ((fit_type_enrolled_c = "None") AND (app.Predominant_Degree_Awarded_c IN ("Predominantly associate's-degree granting", "Predominantly certificate-degree granting", "Not classified")))  THEN "None - 2-year or technical"
        WHEN ((fit_type_enrolled_c = "None") AND (app.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting")) THEN "None - 4-year"
        ELSE fit_type_enrolled_c
    END AS fit_type_enrolled_c,
    
    CASE
        WHEN admission_status_c = "Accepted" THEN 1
        WHEN admission_status_c = "Accepted and Enrolled" THEN 2
        WHEN admission_status_c = "Accepted and Deferred" THEN 3
        WHEN admission_status_c = "Wait-listed" THEN 4
        WHEN admission_status_c = "Conditional" THEN 5
        WHEN admission_status_c = "Withdrew Application" THEN 6
        WHEN admission_status_c = "Undecided" THEN 7
        WHEN admission_status_c = "Denied" THEN 8
        WHEN admission_status_c = "Admission Status Not Yet Updated" THEN 9
        ELSE 0
    END AS sort_helper_admission_status,
    
    FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app
    LEFT JOIN `data-warehouse-289815.salesforce.account` AS accnt
        ON app.College_University_c = accnt.id
     
    WHERE admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")