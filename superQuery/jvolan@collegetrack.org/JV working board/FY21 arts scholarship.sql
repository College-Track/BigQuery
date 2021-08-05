SELECT
    student_c AS d_contact_id,
    SUM(amount_awarded_c) AS fy21_DOOR_total,
 
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    WHERE scholarship_c = 'DOOR'
    AND academic_year_c = 'a1b46000000dRR8AAM'
    AND status_c = 'Won'
    GROUP BY student_c