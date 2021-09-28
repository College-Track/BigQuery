SELECT
    ca.id,
    ca.college_university_c,
    student_c,
    admission_status_c,
    CASE
        WHEN admission_status_c IN ("Accepted", "Accepted and Enrolled","Accepted and Deferred") THEN 1
        ELSE 0
    END AS admitted_y_n,
    a.name AS admit_college_name,
    a.id AS admit_college_id,
    
    
    FROM `data-warehouse-289815.salesforce_clean.college_application_clean` ca
    LEFT JOIN `data-warehouse-289815.salesforce.account` a ON a.id = ca.college_university_c
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` c ON c.Contact_Id - student_c
    WHERE application_status_c = "Applied"
    AND admission_status_c IN ("Accepted", "Accepted and Enrolled","Accepted and Deferred") 
    AND college_first_enrolled_school_c = TEXT(ca.college_university_c)