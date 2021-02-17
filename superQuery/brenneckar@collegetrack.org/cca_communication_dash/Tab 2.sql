WITH gather_data AS (
  SELECT
    Contact_Id,
        Advising_Rubric_Academic_Readiness_c,
    Advising_Rubric_Career_Readiness_c,
    Advising_Rubric_Financial_Success_c,
    Advising_Rubric_Wellness_c,
    value.*
  FROM
    `data-studio-260217.cca_communication.filtered_cca_communication` rubric_colors,
    UNNEST(
      `data-warehouse-289815.UDF.unpivot`(rubric_colors, 'sort_Advising_Rubric_')
    ) value
)
SELECT
  *
FROM
  gather_data