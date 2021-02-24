WITH gather_data AS (
  SELECT
    id,
    first_name,
    last_name,
    is_active,
    user_role_id,
    email
    
  FROM
    `data-warehouse-289815.salesforce.user`
  WHERE
    is_active = True
),
gather_valid_part_time AS (
  SELECT
    *
  FROM
    `data-warehouse-289815.salesforce_clean.tmp_pt_user`
  WHERE
    email NOT IN (
      SELECT
        email
      FROM
        gather_data
    )
)

SELECT *
FROM gather_data
-- UNION ALL (
-- SELECT *
-- FROM
-- gather_valid_part_time)