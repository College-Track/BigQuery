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
    subject,
    id AS task_id,
    description,
    type
  FROM
    `data-warehouse-289815.salesforce.task`
),
gather_communication_data AS (
  SELECT
    GACD.*
    FROM
    gather_all_communication_data GACD
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT ON CAT.Contact_Id = who_id
  WHERE
--   date_of_contact_c BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)
    -- AND CURRENT_DATE()
  CAT.current_as_c = true AND ((CAT.grade_c != "Year 1" AND 
    date_of_contact_c BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)
    AND CURRENT_DATE()) OR (CAT.grade_c = "Year 1" AND 
    date_of_contact_c BETWEEN DATE_SUB(CAT.AY_Start_Date, INTERVAL 90 DAY)
    AND CURRENT_DATE()))
),
group_outreach_communication_data AS (
  SELECT
    who_id,
    format_date('%Y-%W', date_of_contact_c) AS year_week_outreach,
    COUNT(task_id) as count_unique_outreach
  FROM
    gather_communication_data
  GROUP BY
    who_id,
    format_date('%Y-%W', date_of_contact_c)
),
count_unique_outreach AS (
  SELECT
    who_id,
    COUNT(year_week_outreach) AS num_unique_outreach
  FROM
    group_outreach_communication_data
  GROUP BY
    who_id
) -- most_recent_outreach AS (
--   SELECT
--     who_id,
--     MAX(date_of_contact_c) AS most_recent_outreach_date,
--     MIN(date_of_contact_c) AS first_outreach_date,
--     COUNT(task_id) AS num_of_outreach_comms
--   FROM
--     gather_communication_data
--   GROUP BY
--     who_id
-- )
SELECT
  *
FROM
  gather_communication_data
  WHERE who_id IS NOT NULL 
  ORDER BY date_of_contact_c ASC
