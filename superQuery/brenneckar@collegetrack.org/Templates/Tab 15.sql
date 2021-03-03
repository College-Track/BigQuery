WITH gather_all_communication_data AS (
  SELECT
    who_id,
    reciprocal_communication_c,
    CASE
      WHEN activity_date = date_of_contact_c THEN date_of_contact_c
      WHEN date_of_contact_c IS NULL
      and activity_date IS NOT NULL THEN activity_date
      ELSE date_of_contact_c
    END AS date_of_contact_c,
  FROM
    `data-warehouse-289815.salesforce.task`)
  
  
  SELECT
    who_id, (SELECT
      MAX(date_of_contact_c) AS most_recent_outreach
      FROM
        gather_all_communication_data
      GROUP BY
        who_id
    )
  FROM
    gather_all_communication_data
