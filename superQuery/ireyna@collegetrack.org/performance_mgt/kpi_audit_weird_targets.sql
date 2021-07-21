SELECT      
    site_region_team,
    Role,
    kpis_by_role,
    what_is_the_type_of_target_,
    target_fy22
FROM `data-warehouse-289815.google_sheets.team_kpi_target` AS raw_submitted_kpis
 left join `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis` AS shared_kpis
 
    ON shared_kpis.site_region_team = raw_submitted_kpis.region_kpi
    AND Shared_kpis.kpis_by_role = raw_submitted_kpis.select_kpi
 WHERE target_fy22  > 100 
 OR target_fy22  < 1
    AND region_kpi IS NULL
    AND site_kpi IS NOT NULL
    AND what_is_the_type_of_target_ = 'Numeric (but not percent)'
    AND raw_submitted_kpis.email_kpi <> "test@collegetrack.org"