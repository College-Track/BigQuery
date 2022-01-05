
WITH gather_new_approved_sla AS
(
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
),

gather_students AS
(   
    SELECT
    Contact_Id,
    community_service_hours_c AS bb_elig_cs_hours,
    current_academic_semester_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    --TEMP TROUBLESHOOTING PLACEHOLDER
    WHERE Contact_Id = 'a3D8Y000001v9hAUAQ'
),

gather_bb_apps AS    
(   
    SELECT
    student_c,
    id AS bb_app_id,
    
    --PLACEHOLDER for CT Advised -- 
    total_service_earnings_c + total_ct_advised_earnings_c AS cs_1600_cap,

    FROM `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    WHERE scholarship_application_record_type_name = "Bank Book"
),

join_data AS
(
    SELECT
    gsla.* except (student_c),
    gs.*,
    gbb.* except (student_c)

    FROM gather_new_approved_sla gsla
    LEFT JOIN gather_students gs ON Contact_Id = gsla.student_c
    LEFT JOIN gather_bb_apps gbb ON gbb.student_c = gsla.student_c
    
),

dummy_row_add AS
(
    SELECT
    Contact_Id,
    bb_app_id,
    sla_id,
    current_academic_semester_c,
    created_date,
    hours_of_service_completed_c,
    hours_dollar_amount,
    cs_1600_cap,
    bb_elig_cs_hours,
    0 AS dummy_data_row,

    FROM join_data
    
  UNION ALL 
    
    SELECT
    Contact_Id,
    MAX(bb_app_id),
    NULL AS sla_id,
    NULL AS current_academic_semester_c,
    MAX(DATE_SUB(created_date, INTERVAL 7 Day)) AS created_date,
    NULL AS hours_of_service_completed_c,
    MAX(cs_1600_cap) AS hours_dollar_amount,
    NULL AS cs_1600_cap,
    NULL AS bb_elig_cs_hours,
    1 AS dummy_data_row,

    FROM join_data
    GROUP BY Contact_Id
),

running_1600_cap_calc AS
(
    SELECT
    *,
    SUM(hours_dollar_amount)
    OVER
    (PARTITION BY Contact_Id
    ORDER BY Contact_Id, created_date ASC) AS running_cs_1600_cap_value
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

bonus_cs_hours_calc AS
(
    SELECT 
    Contact_Id AS student,
    MAX(bb_app_id) AS scholarship_application,
    CURRENT_DATE() AS date_c,
     "Service" AS earning_type,
    "01246000000ZNhtAAG" AS record_type_id,
    MAX(current_academic_semester_c) AS academic_term,
    MAX(FLOOR(bb_elig_cs_hours/100)-1) AS expected_cs_hours_bonus,
    MAX(FLOOR((cs_1600_cap - 1600)/100)) AS actual_cs_hours_bonus,
    MAX(
    (FLOOR((bb_elig_cs_hours/100)-1) - FLOOR((cs_1600_cap - 1600)/100))) AS cs_bonus_amount_still_needed,
    MAX(bb_elig_cs_hours) AS bb_elig_cs_hours ,
    MAX(cs_1600_cap) AS cs_1600_cap,
    
    FROM join_data
    WHERE bb_elig_cs_hours >=200
    GROUP BY Contact_Id
),

upload_file_prep AS
(
    SELECT
    student,
    scholarship_application,
    date_c,
    earning_type,
    record_type_id,
    academic_term,
    cs_bonus_amount_still_needed*100 AS bb_earnings_amount,
    NULL AS community_service,
    1 AS bonus_cs_award,
    
    FROM bonus_cs_hours_calc

UNION ALL

    SELECT
    Contact_Id AS student,
    bb_app_id AS scholarship_application,
    DATE(created_date) AS date_c,
    "Service" AS earning_type,
    "01246000000ZNhtAAG" AS record_type_id,
    current_academic_semester_c AS academic_term,
    bb_earnings_amount,
    sla_id AS community_service,
    0 AS bonus_cs_award,
    
    FROM bb_earn_calc
)

    SELECT
    *
    FROM upload_file_prep
    WHERE bb_earnings_amount >0