    SELECT
    student_c,
    amount_awarded_c,
    academic_year_c,
    ay.name AS ay_name,
    current_or_intended_college_university_c,
    a.name AS college_name,
    historically_black_college_univ_hbcu_c,
 
    FROM `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    LEFT JOIN `data-warehouse-289815.salesforce.account` a ON a.id = current_or_intended_college_university_c
    LEFT JOIN `data-warehouse-289815.salesforce.academic_year_c` ay ON  ay.id = academic_year_c
    WHERE scholarship_c = 'a3B46000000HWacEAG'
    AND status_c = 'Won'
    AND historically_black_college_univ_hbcu_c = TRUE


    