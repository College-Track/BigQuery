WITH gather_data AS (
  SELECT
    id,
    first_name,
    last_name,
    CAST(is_active AS BOOL) as is_active,
    user_role_id,
    email
  FROM
    `data-warehouse-289815.salesforce.user`
  WHERE
    is_active = True AND user_role_id IS NOT NULL
),
gather_valid_part_time AS (
  SELECT
    id,
    first_name,
    last_name,
    CAST(is_active AS BOOL) as is_active,
    user_role_id,
    email
  FROM
    `data-warehouse-289815.salesforce_clean.tmp_pt_user`
  WHERE
    email NOT IN (
      SELECT
        email
      FROM
        gather_data
    )
),
union_data AS (SELECT
  *
FROM
  gather_data
UNION ALL
  (
    SELECT
      *
    FROM
      gather_valid_part_time
  )
  )
--   ,
  
-- gather_group_members AS (
--   SELECT
--     user_or_group_id,
--     group_id
--   FROM
--     `data-warehouse-289815.salesforce.group_member`
--   WHERE
--     group_id IN (
--       SELECT
--         Id
--       FROM
--         `data-warehouse-289815.salesforce.group`
--       WHERE
--         name LIKE "%Regional CC Advising%"
--     )
-- ),
-- determine_new_roles AS (
--   SELECT
--     U.*,
--     GRI.user_role_id AS new_role
--   FROM
--     gather_group_members GM
--     LEFT JOIN union_data U ON U.id = GM.user_or_group_id
--     LEFT JOIN `data-warehouse-289815.roles.group_role_id` GRI ON GRI.group_id = GM.group_id
-- ),

-- new_roles AS (
-- SELECT
--   U.*
-- EXCEPT(user_role_id),
--   CASE
    
--     WHEN DNR.new_role IS NULL THEN U.user_role_id
    
--     ELSE DNR.new_role
    
--   END AS user_role_id,
-- FROM
--   union_data U
--   LEFT JOIN determine_new_roles DNR ON DNR.id = U.Id

-- )

SELECT *
FROM union_data