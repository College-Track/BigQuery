WITH student_list_denom AS
(   
    SELECT  
    contact_id,
    College_Track_Status_Name,
    region_short,
    site_short,
    high_school_graduating_class_c,
    Ethnic_background_c,
    Gender_c,
    Current_School_Type_c_degree,
    current_cc_advisor_2_c, 
    CASE
        WHEN completed_ct_2020_21_survey_c = "PS Survey" THEN 1
        Else 0
    END AS took_survey_yn
    
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
    WHERE college_track_status_c IN ('15A')
    AND Contact_Id NOT IN (
        SELECT
        Contact_c
      FROM
        `data-warehouse-289815.salesforce.contact_pipeline_history_c`
      WHERE
        created_date >= '2021-03-15T22:00:00.000Z'
        AND Name = 'Became Active Post-Secondary'
    )
)

    SELECT
    sum(took_survey_yn) AS took_survey_count,
    count(Contact_Id) AS student_count
    
    FROM student_list_denom
    GROUP BY
    region_short,
    site_short,
    Ethnic_background_c,
    Gender_c,
    Current_School_Type_c_degree