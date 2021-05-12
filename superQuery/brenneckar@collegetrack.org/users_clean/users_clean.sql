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
        name LIKE "%Regional CC Advising%"
    )