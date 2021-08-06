
    SELECT
    Contact_Id,
    full_name_c,
    site_short,
    high_school_graduating_class_c,
    College_Track_Status_Name,
    CASE
        WHEN 
        (Current_Major_c IN ('Biological, Environmental, or Agricultural Sciences','Chemistry, Physics, or other Physical Sciences','Computer Science or Information Technology	','Engineering or Architecture','Health Sciences','Math or Statistics')
        OR current_second_major_c IN ('Biological, Environmental, or Agricultural Sciences','Chemistry, Physics, or other Physical Sciences','Computer Science or Information Technology	','Engineering or Architecture','Health Sciences','Math or Statistics')
        ) THEN 1 
        ELSE 0
    END AS stem_major_yn,
    CASE
        WHEN 
        (Current_Major_c = 'Engineering or Architecture'
        OR current_second_major_c = 'Engineering or Architecture'
        OR Current_Minor_c LIKE '%engineering%') THEN 1 
        ELSE 0
    END AS engineer_yn,
    Current_school_name,
    Current_School_Type_c_degree,
    Current_Major_c,
    Current_Major_specific_c,
    current_second_major_c,
    Current_Minor_c

    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_c = '15A'