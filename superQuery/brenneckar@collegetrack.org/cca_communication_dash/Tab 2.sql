WITH gather_data AS (
  SELECT
    Contact_Id,
    value.*
  FROM
    `data-studio-260217.cca_communication.filtered_cca_communication` rubric_colors,
    UNNEST(
      `data-warehouse-289815.UDF.unpivot`(rubric_colors, 'sort_Advising_Rubric_')
    ) value
)
SELECT
  *,

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