SELECT 
    student_c,
    id AS sla_id,
    created_date,
    hours_of_service_completed_c,
    hours_of_service_completed_c*16 AS hours_dollar_amount,
    
    FROM `data-warehouse-289815.salesforce.student_life_activity_c`
    WHERE eligible_for_bank_book_service_earnings_c = TRUE
    AND status_c = "Approved"
    AND op_needs_manual_processing_c = TRUE
    ORDER BY student_c,created_date ASC