WITH gather_group_members AS (
      SELECT
        Id,
        Name
      FROM
        `data-warehouse-289815.salesforce.group`
      WHERE
        name LIKE "%Regional CC Advising%"
)
SELECT *
FROM gather_group_members