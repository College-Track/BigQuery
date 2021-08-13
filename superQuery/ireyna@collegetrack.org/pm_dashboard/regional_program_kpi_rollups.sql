function AS regional_function,
role AS regional_role,
CASE 
    WHEN kpis_by_role = '% of all students with GPA 3.25+' THEN '% of students with a 3.25+ cumulative HS GPA'
    ELSE kpis_by_role
END AS regional_rollup_kpi,
site_or_region

FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE region_function = 1