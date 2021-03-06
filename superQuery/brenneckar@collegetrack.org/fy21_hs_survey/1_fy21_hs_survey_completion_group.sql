 WITH gather_data AS(
  SELECT
    site_short,
    high_school_graduating_class_c,
    Most_Recent_GPA_Cumulative_bucket,
    Ethnic_background_c,
    Gender_c,
    contact_id
    
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
  WHERE
    College_Track_Status_c IN ('11A', '12A', '18a')
    AND grade_c != '8th Grade'
    AND Contact_Id NOT IN (
      SELECT
        Contact_c
      FROM
        `data-warehouse-289815.salesforce.contact_pipeline_history_c`
      WHERE
        created_date >= '2021-02-17T21:59:59.000Z'
        AND Name = 'Started/Restarted CT HS Program'
    )

)

SELECT *
FROM gather_data