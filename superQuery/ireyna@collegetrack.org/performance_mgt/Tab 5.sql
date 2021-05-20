
SELECT
    first_name,
    last_name,
    function,
    role
    
FROM (
  WITH kpi AS (SELECT kpi FROM `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` AS b 
                    WHERE a.function = b.function 
                    AND a.kpi <> b.kpi)