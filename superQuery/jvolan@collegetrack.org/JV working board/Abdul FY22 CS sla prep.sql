SELECT 
    student_c AS sla_student,
    id AS sla_id,
    created_date,
    hours_of_service_completed_c,
    
    
    FROM `data-warehouse-289815.salesforce.student_life_activity_c`
    WHERE eligible_for_bank_book_service_earnings_c = TRUE
    AND status_c = "Approved"
    AND DATE(created_date) > DATE(2021,10,01)
    ORDER BY sla_student,created_date ASC