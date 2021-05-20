SELECT
    function,
    kpi AS team_kpi
FROM  `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` 
GROUP BY 
    function,
    kpi
),