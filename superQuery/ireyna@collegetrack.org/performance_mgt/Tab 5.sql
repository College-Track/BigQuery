SELECT 
    role,
    kpi
FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi`
GROUP BY 
    role,kpi