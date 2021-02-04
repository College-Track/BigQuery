SELECT
    roles.site_short,
    roles.role
  FROM
    `data-warehouse-289815.salesforce.user` AS Users
  LEFT JOIN
    `data-warehouse-289815.roles.role_table` AS Roles
  ON
    Roles.Role_Id=Users.user_role_id