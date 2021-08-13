SELECT 
function AS regional_function,
role AS regional_role,
kpis_by_role AS regional_rollup_kpi,
site_or_region

FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE region_function = 1