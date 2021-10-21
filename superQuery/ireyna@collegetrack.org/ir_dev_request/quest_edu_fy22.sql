SELECT at_id,full_name_c,internship_facilitated_by_c,internship_organization_c,internship_compensation_c,internship_related_to_career_interests_c
    
FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
 WHERE 
        AT_Record_Type_Name = 'College/University Semester'
        AND full_name_c IN( 
                        'Natalie Alfaro Rivas', 
                        'Karen Roman-Vite',
                        'Yanira Soto',
                        'Faustina Ngo'
                        )
        AND internship_current_term_c = TRUE