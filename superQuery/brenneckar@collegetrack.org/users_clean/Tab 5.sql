WITH gather_group_members AS (
      SELECT
 *
      FROM
        `data-warehouse-289815.salesforce.group`
      WHERE
        name LIKE "%Boyle%"
)
SELECT *
FROM gather_group_members