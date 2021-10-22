
WITH gather_new_approved_sla AS
(
    SELECT 
    student_c AS sla_student,
    id AS sla_id,
    created_date,
    hours_of_service_completed_c,
    hours_of_service_completed_c*16 AS hours_dollar_amount,
    
    
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
    *,

    FROM gather_new_approved_sla
    LEFT JOIN gather_students ON Contact_Id = sla_student
    LEFT JOIN gather_bb_apps ON student_c = sla_student
)

    SELECT
    sla_student,
    sla_id,
    created_date,
    hours_of_service_completed_c,
    hours_dollar_amount,
    bb_elig_cs_hours,
    cs_1600_cap,
    0 AS dummy_data_row,

    FROM join_data
    
  UNION ALL 
    
    SELECT
    sla_student,
    NULL AS sla_id,
    MAX(DATE_SUB(created_date, INTERVAL 1 Day)) AS created_date,
    NULL AS hours_of_service_completed_c,
    MAX(cs_1600_cap) AS hours_dollar_amount,
    NULL AS bb_elig_cs_hours,
    MAX(cs_1600_cap),
    1 AS dummy_data_row,

    FROM join_data
    GROUP BY SLA_student

    
/*    
    SELECT
    * except (student_c),
    (cs_1600_cap + hours_dollar_amount)
    OVER 
        (PARTITION BY sla_student
        ORDER BY sla_student, created_date ASC)
    FROM join_data
*/