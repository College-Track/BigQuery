SELECT      
    site_region_team,
    Role,
    kpis_by_role,
    what_is_the_type_of_target_,
    target_fy22
FROM `data-warehouse-289815.google_sheets.team_kpi_target` AS raw_submitted_kpis
LEFT JOIN `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis` AS shared_kpis
    ON Shared_kpis.kpis_by_role = raw_submitted_kpis.select_kpi
WHERE kpis_by_role = kpis_by_role AND( what_is_the_type_of_target_ <> (SELECT what_is_the_type_of_target_ AS what_is_the_type_of_target_2
                                                                    FROM `data-warehouse-289815.google_sheets.team_kpi_target` AS raw_submitted_kpis_2
                                                                    LEFT JOIN `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis` AS shared_kpis_2
                                                                    ON Shared_kpis.kpis_by_role = raw_submitted_kpis.select_kpi))