WITH gather_aggregate_data AS (
  SELECT
    current_enrollment_status_c,
    Most_Recent_GPA_Cumulative_bucket,
    most_recent_gpa_semester_bucket,
    grade_c,
    credit_accumulation_pace_c,
    high_school_graduating_class_c,
    site_short,
    site_sort,
    site_abrev,
    region_short,
    region_abrev,
    sort_days_between_outreach_bucket,
    days_between_outreach_bucket,
    days_between_reciprocal_bucket,
    sort_days_between_reciprocal_bucket,
    anticipated_date_of_graduation_ay_c,
    college_class,
    school_type,
    COUNT(Contact_Id) AS student_count,
    SUM(reciprocal_30_days_or_less) AS reciprocal_30_days_or_less,
    SUM(reciprocal_more_than_60_days) AS reciprocal_more_than_60_days,
    SUM(outreach_30_days_or_less) AS outreach_30_days_or_less,
    SUM(outreach_more_than_60_days) AS outreach_more_than_60_days,
    SUM(days_between_most_recent_reciprocal) AS days_between_reciprocal,
    SUM(avg_days_between_reciprocal) AS avg_days_between_reciprocal,
    SUM(avg_days_between_outreach) AS avg_days_between_outreach,
  FROM
    `data-studio-260217.cca_communication.filtered_cca_communication`
  GROUP BY
    current_enrollment_status_c,
    Most_Recent_GPA_Cumulative_bucket,
    most_recent_gpa_semester_bucket,
    grade_c,
    credit_accumulation_pace_c,
    high_school_graduating_class_c,
    site_short,
    site_sort,
    site_abrev,
    region_short,
    region_abrev,
    sort_days_between_outreach_bucket,
    days_between_outreach_bucket,
    days_between_reciprocal_bucket,
    sort_days_between_reciprocal_bucket,
    anticipated_date_of_graduation_ay_c,
    college_class,
    school_type
)
SELECT
  *
FROM
  gather_aggregate_data