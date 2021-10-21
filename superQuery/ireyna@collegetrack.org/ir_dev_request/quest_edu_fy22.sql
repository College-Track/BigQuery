 SELECT 
        contact_id,
        full_name_c,
        College_Track_Status_Name,
        Most_Recent_GPA_Cumulative_c,
        anticipated_date_of_graduation_ay_c,
        academic_year_4_year_degree_earned_c,
        academic_year_term_4_year_degree_earned_c,
        CASE WHEN College_Track_Status_Name= 'Active: Post-Secondary' THEN Current_school_name
            ELSE college_4_year_degree_earned_c
            END AS college_attending_or_attended,
        CASE WHEN College_Track_Status_Name= 'Active: Post-Secondary' THEN Current_Major_c
            ELSE major_4_year_degree_earned_c
            END AS major,
        CASE WHEN College_Track_Status_Name= 'Active: Post-Secondary' THEN Current_Major_specific_c 
            ELSE major_other_4_year_degree_earned_c
            END AS major_other_specific,
        at_id,
        internship_sector_c,
        internship_organization_c,
        internship_organization_other_c,
        internship_compensation_c,
        internship_related_to_major_minor_c,
        internship_related_to_career_interests_c

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`

    WHERE
        full_name_c IN( 
                        'Natalie Alfaro Rivas', 
                        'Karen Roman-Vite',
                        'Yanira Soto',
                        'Faustina Ngo'
                        )
        AND AT_Record_Type_Name = 'College/University Semester'
        AND internship_current_term_c = TRUE