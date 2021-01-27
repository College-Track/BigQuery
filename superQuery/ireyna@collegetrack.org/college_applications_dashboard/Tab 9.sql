SELECT site_short, (SELECT app2.student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app2
        WHERE app2.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting" AND app.student_c=app2.student_c
        AND app2.admission_status_c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred")
        group by app2.student_c
        ) AS  contact_id_accepted_4_year

FROM `data-warehouse-289815.salesforce_clean.college_application_clean` AS app
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` AS C   
ON app.student_c = C.Contact_Id

WHERE C.grade_c = '12th Grade'
AND C.College_Track_Status_Name = 'Current CT HS Student'
AND site_short = 'Aurora'

group by
contact_id_accepted_4_year,
site_short