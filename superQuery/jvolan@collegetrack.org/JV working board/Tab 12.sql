with gather_contact AS
(
 SELECT
    Contact_Id,
    high_school_graduating_class_c,
    most_recent_valid_cumulative_gpa,
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE indicator_completed_ct_hs_program_c = true
    AND college_track_status_c ='15A'
),
gather_at AS
(
SELECT 
    Contact_Id AS a_contact_id,
    AT_Name,
    AT_Cumulative_GPA,
    
    FROM  `data-warehouse-289815.salesforce_clean.contact_at_template` AS atc
    WHERE GAS_Name IN ('Fall 2020-21 (Semester)','Fall 2020-21 (Quarter)') 
    AND indicator_completed_ct_hs_program_c = true
    AND college_track_status_c ='15A'
)
    
    SELECT
    *
    FROM gather_at
    LEFT JOIN gather_contact ON gather_contact.contact_id = a_contact_Id