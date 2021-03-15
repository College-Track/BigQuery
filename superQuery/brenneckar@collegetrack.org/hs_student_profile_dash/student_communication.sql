SELECT
  id,
  who_id,
  CASE
    WHEN activity_date = date_of_contact_c THEN date_of_contact_c
    WHEN date_of_contact_c IS NULL
    and activity_date IS NOT NULL THEN activity_date
    ELSE date_of_contact_c
  END AS date_of_contact_c,
  subject,
  description,
  reciprocal_communication_c,
  type
FROM
  `data-warehouse-289815.salesforce.task`
WHERE
  who_id IN (
    SELECT
      Contact_Id
    FROM
      `data-warehouse-289815.salesforce_clean.contact_template`
  )