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
    credits_accumulated_most_recent_c
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
    date_of_contact_c
  FROM
    `data-warehouse-289815.salesforce.task`
),
join_data AS (
  SELECT
    GD.*,
    GCD.reciprocal_communication_c,
    GCD.date_of_contact_c
  FROM
    gather_data GD
    LEFT JOIN gather_communication_data GCD ON GCD.who_id = GD.Contact_Id
)
SELECT
  *
FROM
  join_data
LIMIT
  100