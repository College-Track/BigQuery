SELECT
  site_short, COUNT(*)
FROM
  `data-studio-260217.performance_mgt.fy22_projections`
  WHERE grade = '10th Grade'
  GROUP BY site_short
  ORDER BY site_short