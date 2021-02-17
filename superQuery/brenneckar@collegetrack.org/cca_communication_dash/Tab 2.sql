WITH rubric_colors AS (
  SELECT
    Contact_Id,
    Advising_Rubric_Academic_Readiness_c,
    Advising_Rubric_Career_Readiness_c,
    Advising_Rubric_Financial_Success_c,
    Advising_Rubric_Wellness_c
  FROM
    `data-studio-260217.cca_communication.filtered_cca_communication`
)
SELECT
  rubric_colors.Contact_Id,
  value.*
FROM
rubric_colors,
   UNNEST(
    `data-warehouse-289815.UDF.unpivot`(rubric_colors, 'Advising_Rubric_')
  ) value