 SELECT 
    full_name_c,
    contact_id,
    site_short,
    gpa_growth_prev_semester_c,
    CASE WHEN gpa_growth_prev_semester_c>0 THEN 1 ELSE 0 AS gpa_growth_indicator,
    Prev_AT_Term_GPA
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE
       AY_Name = 'AY 2020-21'
       AND Term_c = 'Spring'
       AND AT_Record_Type_Name = 'High School Semester'
       AND AY_2020_21_student_served_c = 'High School Student'
       AND region_short = 'Colorado'
       
    GROUP BY
        site_short,
        contact_id,
        AT_Term_GPA,
        full_name_c,
        gpa_growth_prev_semester_c