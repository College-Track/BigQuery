SELECT
    student_c AS d_contact_id,
    SUM(amount_awarded_c) AS fy21_DOOR_total,
 
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    WHERE scholarship_c = 'DOOR'
    AND academic_year_c = 'AY 2020-21'
    AND status_c = 'Won'
    GROUP BY student_c