SELECT
  site_or_region, student_group, COUNT(*)
FROM
  `data-studio-260217.performance_mgt.expanded_role_kpi_selection`
  WHERE site_or_region IS NOT NULL
  GROUP BY site_or_region, student_group
  ORDER BY site_or_region, student_group