WITH gather_data AS (
  SELECT
    Contact_Id,
    value.*
  FROM
    `data-studio-260217.cca_communication.filtered_cca_communication` rubric_colors,
    UNNEST(
      `data-warehouse-289815.UDF.unpivot`(rubric_colors, 'Advising_Rubric_')
    ) value
)
SELECT
  *
FROM
  gather_data
  WHERE value = 'Red'