SELECT
    student_c,
    college_university_c,
    admission_status_c,
    
    
    FROM `data-warehouse-289815.salesforce_clean.college_application_clean`
    WHERE application_status_c = "Applied"