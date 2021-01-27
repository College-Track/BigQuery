SELECT  (SELECT app2.student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app2
        WHERE app2.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting" AND app.student_c=app2.student_c
        AND app2.admission_status_c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred")
        group by app2.student_c
        ) AS  contact_id_accepted_4_year

FROM `data-warehouse-289815.salesforce_clean.college_application_clean` AS app

group by
contact_id_accepted_4_year