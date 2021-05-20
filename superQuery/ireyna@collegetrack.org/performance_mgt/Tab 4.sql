SELECT
    function AS function_team,
    kpi AS team_kpi,
    --role_all
FROM  `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` 
GROUP BY 
   function,
    kpi