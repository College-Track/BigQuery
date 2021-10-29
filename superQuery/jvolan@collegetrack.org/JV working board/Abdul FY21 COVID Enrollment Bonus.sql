WITH gather_students AS
( 
    SELECT
    Contact_Id,
    COUNT(AT_Id) AS eligble_AT_count,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE 
    GAS_Name IN ("Spring 2019-20 (Semester)","Fall 2020-21 (Semester)", "Spring 2020-21 (Semester)")
    AND student_audit_status_c IN ("Current CT HS Student","Onboarding")
    AND attended_workshops_c > 0
    GROUP BY Contact_Id
),

gather_bb_apps AS    
(   
    SELECT
    student_c,
    id AS bb_app_id,
    MAX(total_service_earnings_c) AS total_service_earnings_c,
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    WHERE scholarship_application_record_type_name = "Bank Book"
    GROUP BY student_c, bb_app_id
),

join_data AS
(
    SELECT
    * except (student_c),
    (eligble_at_count * 200) AS eligble_covid_bonus,
    (1600 - total_service_earnings_c) AS available_1600_cap,

    FROM gather_students
    LEFT JOIN gather_bb_apps ON student_c = Contact_Id
)
    SELECT
    Contact_Id AS student,
    bb_app_id AS scholarship,
    CASE
        WHEN available_1600_cap <= 0 THEN NULL
        WHEN eligble_covid_bonus > available_1600_cap THEN available_1600_cap
        ELSE eligble_covid_bonus
    END AS final_covid_bonus_amount,
    "01246000000ZNhtAAG" AS record_type_id,
    "CT Advised" AS earning_type,
    CURRENT_DATE() AS date_c,
    TRUE AS OP_Manual_Disbursement,
    "COVID enrollment related BB award, granted in response to decreased opportunities for CS engagements during the pandemic. See FY22 Service Cap Plan for details" AS OP_Manual_Disbursement_notes,
    
    --just to have visibile in upload file if we need to audit down the road
    eligble_AT_count,
    total_service_earnings_c,
    eligble_covid_bonus,
    available_1600_cap,
    
    
    
    
    FROM join_data
