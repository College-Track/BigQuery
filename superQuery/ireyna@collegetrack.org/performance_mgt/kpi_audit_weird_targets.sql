 SELECT *
 FROM `data-warehouse-289815.google_sheets.team_kpi_target` AS raw_submitted_kpis
 LEFT JOIN `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis` AS shared_kpis
    ON shared_kpis.site_region_team = raw_submitted_kpis.team_kpi
 WHERE raw_submitted_kpis.enter_the_target_percent_  > 1
    AND region_kpi = "0"
    AND site_kpi = "0"
    AND what_is_the_type_of_target_ = 'Percent'