SELECT
* EXCEPT (site_or_region),
CASE WHEN (student_group IS NOT NULL AND site_or_region = "Bay Area") THEN "NOR CAL"
ELSE site_or_region
END AS site_or_region
FROM
    `data-studio-260217.performance_mgt.expanded_role_kpi_selection` KPI_by_role
WHERE
    KPI_by_role.function IN (
      'Mature Regional Staff',
      'Non-Mature Regional Staff'
    )    