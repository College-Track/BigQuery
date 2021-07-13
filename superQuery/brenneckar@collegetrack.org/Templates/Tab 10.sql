with gather_contact AS
(
 SELECT
    most_recent_valid_cumulative_gpa,
    Contact_Id,
    high_school_graduating_class_c,
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    -- WHERE indicator_completed_ct_hs_program_c = true
    -- AND college_track_status_c ='15A'
),
gather_at AS
(
SELECT
    Contact_Id AS a_contact_id,
    AT_Name,
    AT_Cumulative_GPA,
    gpa_required_date,
    next_gpa_required_date
    
    FROM  `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE GAS_Name IN ('Winter 2020-21 (Quarter)')
    AND indicator_completed_ct_hs_program_c = true
    AND college_track_status_c ='15A'
)
    SELECT
    *
    FROM gather_at
    LEFT JOIN gather_contact ON gather_contact.contact_id = gather_at.a_contact_id
    WHERE most_recent_valid_cumulative_gpa IS NULL
    AND AT_Cumulative_GPA IS NOT NULL