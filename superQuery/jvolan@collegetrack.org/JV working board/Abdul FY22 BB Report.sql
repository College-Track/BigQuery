WITH gather_students AS
(   
    SELECT
    Contact_Id,
    College_Track_Status_Name,
    high_school_graduating_class_c,
    community_service_hours_c AS bb_elig_cs_hours,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE College_Track_Status_Name = "Current CT HS Student"
),

gather_bb_apps AS    
(   
    SELECT
    student_c,
    CONCAT("https://ctgraduates.lightning.force.com/lightning/r/Scholarship_Application__c/", id, "/view") AS bb_app_url,
    
    total_bank_book_earnings_current_c,
    total_service_earnings_c,
    total_attendance_earnings_c,
    total_gpaearnings_c,
    
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