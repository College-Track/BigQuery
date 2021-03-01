SELECT
  Master.*
FROM
  `data-studio-260217.cca_communication.filtered_cca_communication` AS Master
RIGHT JOIN (
  SELECT
    roles.site_short,
    roles.role
  FROM
    `data-warehouse-289815.salesforce_clean.user_clean` AS Users
  LEFT JOIN
    `data-warehouse-289815.roles.role_table` AS Roles
  ON
    Roles.Role_Id=Users.user_role_id
  WHERE
    LOWER(Users.Email)=LOWER(SESSION_USER()) ) AS Permissions
ON
  Master.site_short=Permissions.site_short