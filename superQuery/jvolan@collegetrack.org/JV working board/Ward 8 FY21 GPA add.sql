 SELECT
    Contact_Id,
    AT_Id,
    start_date_c
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE site_short = 'Ward 8'
    AND ay_2020_21_student_served_c = "High School Student"
    AND AT_Term_GPA IS NOT NULL
    ORDER BY start_date_c ASC
    LIMIT 1