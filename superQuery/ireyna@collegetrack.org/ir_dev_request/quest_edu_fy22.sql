#Ticket: https://collegetrack.zendesk.com/agent/tickets/11874
/*
Students
Natalie Alfaro Rivas, 
Karen Roman-Vite,
Yanira Soto,
Faustina Ngo
*/

SELECT 
    contact_id,
    full_name_c,
    College_Track_Status_Name,
    college_4_year_degree_earned_c,
    major_4_year_degree_earned_c,
    major_other_4_year_degree_earned_c,
    Current_school_name,
    Current_Major_c,
    Current_Major_specific_c,
    anticipated_date_of_graduation_4_year_c,
    anticipated_date_of_graduation_ay_c,
    academic_year_4_year_degree_earned_c,
    academic_year_term_4_year_degree_earned_c

FROM `data-warehouse-289815.salesforce_clean.contact_at_template`

    WHERE
        AY_Name = 'AY 2020-21'
        AND Term_c = 'Spring'
        AND AT_Record_Type_Name = 'College/University Semester'
        AND AY_2020_21_student_served_c = 'Post-Secondary Student'
        AND full_name_c IN( 
                        'Natalie Alfaro Rivas', 
                        'Karen Roman-Vite',
                        'Yanira Soto',
                        'Faustina Ngo'
                        )