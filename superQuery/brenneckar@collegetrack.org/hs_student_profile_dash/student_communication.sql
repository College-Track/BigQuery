SELECT
  id,
  who_id AS Contact_Id,
  CASE
    WHEN activity_date = date_of_contact_c THEN date_of_contact_c
    WHEN date_of_contact_c IS NULL
    and activity_date IS NOT NULL THEN activity_date
    ELSE date_of_contact_c
  END AS date_of_contact_c,
  subject,
  description,
  reciprocal_communication_c,
  type,
  CT.most_recent_outreach,
  CT.most_recent_reciprocal,
  ABS(
      DATE_DIFF(
        CT.most_recent_reciprocal,
        CURRENT_DATE,
        DAY
      )
    ) AS days_between_most_recent_reciprocal,
      ABS(
      DATE_DIFF(
        CT.most_recent_outreach,
        CURRENT_DATE,
        DAY
      )
    ) AS days_between_most_recent_outreach
FROM
  `data-warehouse-289815.salesforce.task` T
  LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` CT ON CT.Contact_Id = T.who_id
WHERE
  who_id IN (
    SELECT
      Contact_Id
    FROM
      `data-warehouse-289815.salesforce_clean.contact_template`
  )
  