 SELECT *
 FROM `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis` AS shared_kpis
 LEFT JOIN `data-studio-260217.performance_mgt.fy22_team_kpis` AS submitted_kpis
    ON shared_kpis.site_region_team = submitted_kpis.site_or_region
 WHERE shared_kpis.target_fy22 > 1 OR shared_kpis.target_fy22 = .1