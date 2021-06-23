  SELECT
    KPI_by_role.*,
    KPI_Tagets.*,
    Projections.region_abrev,
    Projections.site_short,
    Projections.student_count
  FROM
    `data-studio-260217.performance_mgt.expanded_role_kpi_selection` KPI_by_role
    LEFT JOIN prep_kpi_targets KPI_Tagets ON KPI_by_role.role = KPI_Tagets.select_role
    AND KPI_by_role.kpis_by_role = KPI_Tagets.select_kpi
    AND KPI_by_role.site_or_region = KPI_Tagets.site_kpi
    LEFT JOIN join_projections Projections ON Projections.site_short = KPI_by_role.site_or_region AND Projections.student_type = KPI_by_role.student_group
  WHERE
    KPI_by_role.function IN ('Mature Site Staff', 'Non-Mature Site Staff')