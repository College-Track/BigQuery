SELECT
  .site_short, COUNT(Contact_Id)
FROM
  `data-studio-260217.rosters.filtered_roster` AS Master
  GROUP BY site_short