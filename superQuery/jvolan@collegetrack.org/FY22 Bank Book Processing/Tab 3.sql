--context this is all needed b/c we turned off the automation that takes approved SLAs and then calculates how much in service earnings student should get due to complexity with covid bonuses

--first step is to gather all the eligble, approved SLAs that are in the system since we turned off automation
-- those are distingueshed by having the OP Needs Manual Processing checkbox check / TRUE. This is default now, so as new SLAs get submitted & approved this box will be checked until we manually process that record
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

--gathering wide list of students + current total bb elig community service hours from the contact for each student. Used later on in calculating if students need any 100+ hour bonuses awarded based on overall CS hours
gather_students AS
(   
    SELECT
    Contact_Id,
    community_service_hours_c AS bb_elig_cs_hours,
    current_academic_semester_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    
),

-- this step is to gather every BB app and to pull in total service & ct advised earnings to date
gather_bb_apps AS    
(   
    SELECT
    student_c,
    id AS bb_app_id,
    total_service_earnings_c,
    CASE
        WHEN total_ct_advised_earnings_c IS NULL THEN 0
        ELSE total_ct_advised_earnings_c
    END AS total_ct_advised_earnings_c

    FROM `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    WHERE scholarship_application_record_type_name = "Bank Book"
),

--needed to do this seperate do to the case statement to convert NULL to 0 for total ct advised earnings. Besides that, this is just adding the 2 totals and comparing it to 1600 cap
cs_1600_cap AS
(
    SELECT 
    *,
    total_service_earnings_c + total_ct_advised_earnings_c AS cs_1600_cap
    
    FROM gather_bb_apps
),

join_data AS
(
    SELECT
    gsla.* except (student_c),
    gs.*,
    csc.* except (student_c)

    FROM gather_new_approved_sla gsla
    LEFT JOIN gather_students gs ON Contact_Id = gsla.student_c
    LEFT JOIN cs_1600_cap csc ON csc.student_c = gsla.student_c
    
),

-- need to review the next 3 CTEs with BR, as he and I went back and forth on this strategy. want to make sure it's solid and we understand what we did here. I need a refresher
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
)

    SELECT
    *
    FROM running_1600_cap_calc

/*
--this compares total hours/eligble bb dollars from newly approved SLAs vs student's 1600 cap to determine how much, if any, new service BB earnings the student will get
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

--this is used to determine if the new hours + students already existing total CS BB hours pulled at beginining of query should result in any $100 service bonus awards
--as a reminder those are awarded starting when students hit 200 hours (they get $100) and then another $100 for every next 100 hours
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

-- this is just doing some final data cleaning and prep to get the upload file ready for upload
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
*/