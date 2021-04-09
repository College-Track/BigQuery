WITH gather_group_members AS (
  SELECT
    name,
    user_or_group_id,
    group_id
  FROM
    `data-warehouse-289815.salesforce.group_member`
--   WHERE
--     group_id IN (
--       SELECT
--         Id
--       FROM
--         `data-warehouse-289815.salesforce.group`
--       WHERE
--         name LIKE "%Shared CC Advising%"
--     )
)

SELECT *
FROM gather_group_members