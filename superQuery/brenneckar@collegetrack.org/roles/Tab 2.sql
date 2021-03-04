WITH gather_group_members AS (
  SELECT
    user_or_group_id,
    group_id
  FROM
    `data-warehouse-289815.salesforce.group_member`
  WHERE
    group_id IN (
      SELECT
        Id
      FROM
        `data-warehouse-289815.salesforce.group`
      WHERE
        name LIKE "%Shared CC Advising%"
    )
),
determine_new_roles AS (
  SELECT
    U.*,
    GRI.user_role_id AS new_role
  FROM
    gather_group_members GM
    LEFT JOIN `data-warehouse-289815.salesforce_clean.user_clean` U ON U.id = GM.user_or_group_id
    LEFT JOIN `data-warehouse-289815.roles.group_role_id` GRI ON GRI.group_id = GM.group_id
)
SELECT
  U.* EXCEPT(user_role_id),
  CASE
    WHEN DNR.new_role IS NULL THEN U.user_role_id
    ELSE DNR.new_role
  END AS user_role_id
FROM
  `data-warehouse-289815.salesforce_clean.user_clean` U
  LEFT JOIN determine_new_roles DNR ON DNR.id = U.Id