WITH gather_data AS(
  SELECT
    Contact_Id,
    full_name_c,
    current_cc_advisor_2_c,
    current_enrollment_status_c,
    Current_school_name,
    Most_Recent_GPA_Cumulative_bucket,
    most_recent_gpa_semester_bucket,
    grade_c,
    credit_accumulation_pace_c,
    high_school_graduating_class_c,
    credits_accumulated_most_recent_c,
    site_short,
    site_sort,
    site_abrev,
    region_short,
    region_abrev
    
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    current_as_c = True
    AND college_track_status_c = '15A'
),
gather_communication_data AS (
  SELECT
    who_id,
    reciprocal_communication_c,
    date_of_contact_c,
    subject,
    id AS task_id,
    description,
    type
  FROM
    `data-warehouse-289815.salesforce.task`
),
most_recent_reciprocal AS (
  SELECT
    who_id,
    MAX(date_of_contact_c) AS most_recent_reciprocal_date
  FROM
    gather_communication_data
  WHERE
    reciprocal_communication_c = TRUE
  GROUP BY
    who_id
),
most_recent_outreach AS (
  SELECT
    who_id,
    MAX(date_of_contact_c) AS most_recent_outreach_date
  FROM
    gather_communication_data
  GROUP BY
    who_id
),
join_data AS (
  SELECT
    GD.*,
    -- GCD.*
    --   EXCEPT(who_id),
    MRR.most_recent_reciprocal_date,
    MRO.most_recent_outreach_date,
    ABS(
      DATE_DIFF(
        MRR.most_recent_reciprocal_date,
        CURRENT_DATE,
        DAY
      )
    ) AS days_between_reciprocal,
    ABS(
      DATE_DIFF(MRO.most_recent_outreach_date, CURRENT_DATE, DAY)
    ) AS days_between_outreach
  FROM
    gather_data GD -- LEFT JOIN gather_communication_data GCD ON GCD.who_id = GD.Contact_Id
    LEFT JOIN most_recent_reciprocal MRR ON MRR.who_id = GD.Contact_Id
    LEFT JOIN most_recent_outreach MRO ON MRO.who_id = GD.Contact_Id
)
SELECT
  *,
  CASE
    WHEN days_between_reciprocal <= 30 THEN 1
    ELSE 0
  END AS reciprocal_30_days_or_less,
  CASE
    WHEN days_between_reciprocal > 60 THEN 1
    ELSE 0
  END AS reciprocal_more_than_60_days,
  CASE
    WHEN days_between_outreach <= 30 THEN 1
    ELSE 0
  END AS outreach_30_days_or_less,
  CASE
    WHEN days_between_outreach > 60 THEN 1
    ELSE 0
  END AS outreach_more_than_60_days
FROM
  join_data