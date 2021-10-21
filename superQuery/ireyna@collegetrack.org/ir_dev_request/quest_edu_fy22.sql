SELECT full_name_c,internship_facilitated_by_c,internship_organization_c,internship_compensation_c,internship_related_to_career_interests_c
    
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
 WHERE AY_Name = 'AY 2020-21'
        AND Term_c = 'Spring'
        AND AT_Record_Type_Name = 'College/University Semester'
        AND full_name_c IN( 
                        'Natalie Alfaro Rivas', 
                        'Karen Roman-Vite',
                        'Yanira Soto',
                        'Faustina Ngo'
                        )
        AND internship_current_term_c = TRUE