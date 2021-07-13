with gather_contact AS
(
 SELECT
    Contact_Id,
    high_school_graduating_class_c,
    CASE
        WHEN
        (indicator_completed_ct_hs_program_c = true
        AND college_track_status_c = '15A'
        AND most_recent_valid_cumulative_gpa >= 2.5) THEN 1
        ELSE 0
    END AS cc_ps_gpa_2_5_num,

    FROM `data-warehouse-289815.salesforce_clean.contact_template`
--needed widest reporting group to ensure I had all students I need to evaluate if they were in one of my custom denoms. Added in more detail filter logic into case statements above.
    WHERE indicator_completed_ct_hs_program_c = true
    AND college_track_status_c ='15A'
),
gather_at AS
(
SELECT 
    Contact_Id AS a_contact_id,
    AT_Name,
    AT_Cumulative_GPA,
    
    FROM  `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE global_academic_semester_c IN ('Fall 2020-21 (Semester)','Fall 2020-21 (Quarter)') 
    )
    
    SELECT 
    *,
    gather_at.AT_Name,
    gather_at.AT_Cumulative_GPA
    FROM gather_contact
    LEFT JOIN gather_at ON gather_at.a_contact_id = Contact_Id

