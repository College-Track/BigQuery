 SELECT *
 FROM `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis` AS shared_kpis
 LEFT JOIN `data-warehouse-289815.google_sheets.team_kpi_target` AS raw_submitted_kpis
    ON shared_kpis.site_region_team = raw_submitted_kpis.site_kpi
 WHERE shared_kpis.target_fy22 > 1 OR shared_kpis.target_fy22 = .1
    AND what_is_the_type_of_target_ = 'Percent'