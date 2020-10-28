WITH current_as AS (
  SELECT
    Contact_Id,
    On_Track__c
  FROM
    `data-warehouse-289815.sfdc_templates.contact_at_template`
  WHERE
    Current_AS__c = True
    AND College_Track_Status__c IN ('15A')
),
previous_as AS (
  SELECT
    Contact_Id,
    On_Track__c
  FROM
    `data-warehouse-289815.sfdc_templates.contact_at_template`
  WHERE
    Previous_AS__c = True
    AND College_Track_Status__c IN ('15A')
),
prev_prev_as AS (
  SELECT
    Contact_Id,
    On_Track__c
  FROM
    `data-warehouse-289815.sfdc_templates.contact_at_template`
  WHERE
    Prev_Prev_As__c = True
    AND College_Track_Status__c IN ('15A')
),
joined_on_track AS (
  SELECT
    CS.Contact_Id,
    CS.On_Track__c AS current_as_on_track,
    PS.On_Track__c AS previous_as_on_track,
    PPS.On_Track__c AS prev_prev_as_on_track
  FROM
    current_as CS
    LEFT JOIN previous_as PS ON PS.Contact_Id = CS.Contact_ID
    LEFT JOIN prev_prev_as PPS ON PPS.Contact_Id = CS.Contact_ID
)
SELECT
  Contact_Id,
  current_as_on_track,
  previous_as_on_track,
  prev_prev_as_on_track,
  CASE
    WHEN current_as_on_track IS NOT NULL THEN current_as_on_track
    WHEN previous_as_on_track IS NOT NULL THEN previous_as_on_track
    WHEN prev_prev_as_on_track IS NOT NULL THEN prev_prev_as_on_track
    ELSE NULL
  END AS most_recent_on_track
FROM
  joined_on_track