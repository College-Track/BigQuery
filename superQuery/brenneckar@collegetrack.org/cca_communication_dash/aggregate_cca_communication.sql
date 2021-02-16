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
    reciprocal_30_days_or_less,
    reciprocal_more_than_60_days,
    outreach_30_days_or_less,
    outreach_more_than_60_days,
  COUNT(Contact_Id) AS student_count
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
    reciprocal_30_days_or_less,
    reciprocal_more_than_60_days,
    outreach_30_days_or_less,
    outreach_more_than_60_days