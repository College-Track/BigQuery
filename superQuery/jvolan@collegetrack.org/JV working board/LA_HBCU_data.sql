SELECT
    d.student_c,
    SUM(amount_awarded_c) AS door_total,
    academic_year_c
 
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_application_clean` d
    WHERE scholarship_c = 'a3B46000000HWacEAG'
    AND status_c = 'Won'
    GROUP BY student_c, academic_year_c