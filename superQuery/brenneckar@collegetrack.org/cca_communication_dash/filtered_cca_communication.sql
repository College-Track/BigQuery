WITH gather_data AS(
  SELECT
    Contact_Id,
    full_name_c,
    on_track_c,
    current_cc_advisor_2_c,
    current_enrollment_status_c,
    Current_school_name,
    Most_Recent_GPA_Cumulative_bucket,
    most_recent_gpa_semester_bucket
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    current_as_c = True
    AND college_track_status_c = '15A'
)
SELECT
  *
FROM
  gather_data
LIMIT
  10