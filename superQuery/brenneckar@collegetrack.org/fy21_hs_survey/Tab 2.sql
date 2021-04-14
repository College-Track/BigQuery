WITH gather_data AS(
  SELECT
    site_short,
    COUNT(Contact_Id) as student_count
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
  WHERE
    College_Track_Status_c IN ('11A', '12A', '18a')
    AND Contact_Id NOT IN (
      SELECT
        Contact_c
      FROM
        `data-warehouse-289815.salesforce.contact_pipeline_history_c`
      WHERE
        created_date >= '2021-02-18'
        AND Name = 'Started/Restarted CT HS Program'
    )
  GROUP BY
    site_short
)
SELECT
  SUM(student_count)
FROM
  gather_data