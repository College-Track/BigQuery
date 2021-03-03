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
    `data-warehouse-289815.salesforce.task`
),
most_recent_outreach AS (
  SELECT
    who_id, MAX(date_of_contact_c) AS most_recent_outreach
  FROM
    gather_all_communication_data
    GROUP BY who_id
),

most_recent_reciprocal AS (
  SELECT
    who_id, MAX(date_of_contact_c) AS most_recent_reciprocal
  FROM
    gather_all_communication_data
    WHERE reciprocal_communication_c = True
    GROUP BY who_id
    
)

SELECT *
FROM most_recent_reciprocal
LIMIT 10