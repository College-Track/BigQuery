
WITH gather_new_approved_sla AS
(
    SELECT 
    student_c AS sla_student,
    id AS sla_id,
    created_date,
    hours_of_service_completed_c,
    
    
    FROM `data-warehouse-289815.salesforce.student_life_activity_c`
    WHERE eligible_for_bank_book_service_earnings_c = TRUE
    AND status_c = "Approved"
    AND DATE(created_date) > DATE(2021,10,01)
    
    -- PLACEHOLDER for OP Processed Record for BB = FALSE --
    --PLACEHOLDER removed after testing--
    AND student_c = '0031M000031XjisQAC'
    ORDER BY sla_student,created_date ASC
),

gather_students AS
(   
    SELECT
    Contact_Id,
    College_Track_Status_Name,
    high_school_graduating_class_c,
    site_short,
    community_service_hours_c AS bb_elig_cs_hours,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
),

gather_bb_apps AS    
(   
    SELECT
    student_c,
    
    --PLACEHOLDER for CT Advised -- 
    total_service_earnings_c + 0 AS cs_1600_cap,

    FROM `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    WHERE scholarship_application_record_type_name = "Bank Book"
),

join_data AS
(
    SELECT
    *
    
    FROM gather_new_approved_sla
    LEFT JOIN gather_students ON Contact_Id = sla_student
    LEFT JOIN gather_bb_apps ON student_c = sla_student
)

    
    SELECT
    * 
    FROM join_data