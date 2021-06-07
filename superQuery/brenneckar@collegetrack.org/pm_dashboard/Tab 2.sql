SELECT
  site_short, grade, COUNT(*)
FROM
  `data-studio-260217.performance_mgt.fy22_projections`
  GROUP BY site_short, grade
  ORDER BY site_short, grade