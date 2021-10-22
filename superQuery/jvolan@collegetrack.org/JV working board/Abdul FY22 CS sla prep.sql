
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
    id AS bb_app_id,
    
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
),

dummy_row_add AS
(
    SELECT
    sla_student,
    bb_app_id,
    sla_id,
    created_date,
    hours_of_service_completed_c,
    hours_dollar_amount,
    cs_1600_cap,
    bb_elig_cs_hours,

    0 AS dummy_data_row,

    FROM join_data
    
  UNION ALL 
    
    SELECT
    sla_student,
    MAX(bb_app_id),
    NULL AS sla_id,
    MAX(DATE_SUB(created_date, INTERVAL 7 Day)) AS created_date,
    NULL AS hours_of_service_completed_c,
    MAX(cs_1600_cap) AS hours_dollar_amount,
    NULL AS cs_1600_cap,
    NULL AS bb_elig_cs_hours,

    1 AS dummy_data_row,

    FROM join_data
    GROUP BY SLA_student
),

running_1600_cap_calc AS
(
    SELECT
    *,
    SUM(hours_dollar_amount)
    OVER
    (PARTITION BY sla_student
    ORDER BY sla_student, created_date ASC) AS running_cs_1600_cap_value
    FROM dummy_row_add
),

bb_earn_calc AS
(
    SELECT
    *, 
    ROUND(CASE
        WHEN dummy_data_row = 1 THEN NULL
        WHEN running_cs_1600_cap_value < 1600 THEN hours_dollar_amount
        WHEN 
        (running_cs_1600_cap_value >= 1600
        AND (running_cs_1600_cap_value - 1600) > hours_dollar_amount) THEN NULL
        WHEN 
        (running_cs_1600_cap_value >= 1600
        AND (running_cs_1600_cap_value - 1600) <= hours_dollar_amount) THEN hours_dollar_amount - (running_cs_1600_cap_value - 1600)
        ELSE NULL
    END,2) AS bb_earnings_amount
    
    FROM running_1600_cap_calc
),

bonus_cs_hours_upload_file_prep AS
(
    SELECT 
    sla_student AS student,
    MAX(bb_app_id) AS scholarship_application,
    CURRENT_DATE() AS date_c,
     "Service" AS earning_type,
    "01246000000ZNhtAAG" AS record_type_id,
    "a" AS academic_term,
    MAX(FLOOR(bb_elig_cs_hours/100)-1) AS expected_cs_hours_bonus,
    MAX(FLOOR((cs_1600_cap - 1600)/100)) AS actual_cs_hours_bonus,
    MAX(
    (FLOOR(bb_elig_cs_hours/100) - FLOOR((cs_1600_cap - 1600)/100 - 1))) AS cs_bonus_amount_still_needed,
    MAX(bb_elig_cs_hours),
    MAX(cs_1600_cap),
    
    FROM join_data
    WHERE bb_elig_cs_hours >=200
    GROUP BY sla_student
)

    SELECT
    *
    FROM bonus_cs_hours_upload_file_prep


/*

main_upload_file_prep AS
(
    SELECT
    sla_student AS student,
    bb_app_id AS scholarship_application,
    created_date AS date_c,
    "Service" AS earning_type,
    "01246000000ZNhtAAG" AS record_type_id,
    "a" AS academic_term,
    bb_earnings_amount,
    sla_id AS community_service,
    
    FROM bb_earn_calc
),


*/