WITH gather_students AS
(   
    SELECT
    Contact_Id,
    College_Track_Status_Name,
    high_school_graduating_class_c,
    site_short,
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
    gather_students.*
    
    FROM `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
    LEFT JOIN gather_students ON Contact_Id = student_c
    WHERE scholarship_application_record_type_name = "Bank Book"
)

    SELECT
    *
    FROM gather_bb_apps