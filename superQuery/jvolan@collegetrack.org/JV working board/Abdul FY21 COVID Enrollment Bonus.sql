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
    -- PLACEHOLDER for adding in + ct advised here --
   
    
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
    *,
    CASE
        WHEN eligble_covid_bonus > available_1600_cap THEN available_1600_cap
        ELSE eligble_covid_bonus
    END AS final_covid_bonus_value
    
    FROM join_data
