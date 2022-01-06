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