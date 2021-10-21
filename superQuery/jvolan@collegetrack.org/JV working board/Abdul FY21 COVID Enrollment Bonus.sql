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
    
    total_service_earnings_c,
    --placeholder for adding in + ct advised here --
   
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
),

join_data AS
(
    SELECT
    gather_students.*,
    gather_bb_apps.* except (student_c),
    
    FROM gather_students
    LEFT JOIN gather_bb_apps ON student_c = Contact_Id
)
    SELECT
    *
    FROM join_data