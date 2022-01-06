--gather students who had ct status of onboarding or current ct hs student at end of prev term. Create indicator for students who had 80% attendance. 

WITH gather_students AS
( 
    SELECT
    Contact_Id,
    attendance_rate_c,
    CASE
        WHEN attendance_rate_c >= .9 THEN 200 
        ELSE 0
    END AS eligble_covid_attendance_bonus

    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE 
    GAS_Name IN ("Fall 2021-22 (Semester)")
    AND student_audit_status_c IN ("Current CT HS Student","Onboarding")
    AND attended_workshops_c > 0
),

--gather bb apps to determine students overall bb earnings to date for total service earnings + total CT Advised earnings 
--to determine how much, if any, students still have under that $1600 cap for those arning types commbined. 
gather_bb_apps AS    
(   
    SELECT
    student_c,
    id AS bb_app_id,
    MAX(total_service_earnings_c + total_ct_advised_earnings_c) AS total_service_plus_ct_advised_earnings,
    MAX(1600 - (total_service_earnings_c + total_ct_advised_earnings_c)) AS available_1600_cap
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    WHERE scholarship_application_record_type_name = "Bank Book"
    GROUP BY student_c, bb_app_id
),

join_data AS
(
    SELECT
    * except (student_c),

    FROM gather_students
    LEFT JOIN gather_bb_apps ON student_c = Contact_Id
),

upload_prep AS
(   
    SELECT
    Contact_Id AS student,
    bb_app_id AS scholarship,
    CASE
        WHEN available_1600_cap <= 0 THEN NULL
        WHEN eligble_covid_attendance_bonus > available_1600_cap THEN available_1600_cap
        ELSE eligble_covid_attendance_bonus
    END AS final_covid_attendance_amount,
    "01246000000ZNhtAAG" AS record_type_id,
    "CT Advised" AS earning_type,
    CURRENT_DATE() AS date_c,
    TRUE AS OP_Manual_Disbursement,
    "COVID attendance related BB award, granted in response to decreased opportunities for CS engagements during the pandemic. See FY22 Service Cap Plan for details" AS OP_Manual_Disbursement_notes,
    
    --just to have visibile in upload file if we need to audit down the road
    attendance_rate_c,
    eligble_covid_attendance_bonus,
    total_service_plus_ct_advised_earnings,
    available_1600_cap,
    FROM join_data
)

    SELECT 
    *
    FROM upload_prep
    WHERE final_covid_attendance_amount > 0