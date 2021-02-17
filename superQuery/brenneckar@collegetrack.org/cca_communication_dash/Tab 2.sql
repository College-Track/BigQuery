WITH gather_data AS (
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
    anticipated_date_of_graduation_ay_c,
    site_short,
    site_sort,
    site_abrev,
    region_short,
    region_abrev,
    school_type,
    
    value.*
  FROM
    `data-studio-260217.cca_communication.filtered_cca_communication` rubric_colors,
    UNNEST(
      `data-warehouse-289815.UDF.unpivot`(rubric_colors, 'sort_Advising_Rubric_')
    ) value
)
SELECT
  * EXCEPT(key, value),

  CASE
    WHEN value IS NULL THEN "No Data"
    WHEN value = '4' THEN "No Data"
    WHEN value = '3' THEN "Green"
    WHEN value = '2' THEN "Yellow"
    WHEN value = '1' THEN "Red"
    ELSE "No Data"
  END AS rubric_section_color,
  CASE
    WHEN key = 'sort_Advising_Rubric_Career_Readiness_sort' THEN "Career"
    WHEN key = 'sort_Advising_Rubric_Wellness_sort' THEN 'Wellness'
    WHEN key = 'sort_Advising_Rubric_Financial_Success_sort' THEN "Finance"
    WHEN key = 'sort_Advising_Rubric_Academic_Readiness_sort' THEN "Academic"
  END AS rubric_section
FROM
  gather_data