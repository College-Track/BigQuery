 SELECT 
    contact_id,
    site_short,
    term_c,
    AT_Term_GPA,
    CASE 
        WHEN term_c = 'Fall' THEN AT_Term_GPA
    END AS fall_term_gpa,
    CASE 
        WHEN term_c = 'Spring' THEN AT_Term_GPA
    END AS spring_term_gpa
        
    FROM
   `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE
       AY_Name = 'AY 2020-21'
       AND Term_c <> 'Summer'
       AND AT_Record_Type_Name = 'High School Semester'
       AND AY_2020_21_student_served_c = 'High School Student'
       AND region_short = 'Colorado'
       
    GROUP BY
        site_short,
        AT_Term_GPA,
        term_c,
        contact_id