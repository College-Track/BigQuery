SELECT t2.kpis_by_role 
    FROM `data-studio-260217.performance_mgt.fy22_team_kpis` AS t2 
    WHERE t2.kpis_by_role = t1.kpis_by_role 
    AND t1.program =1 
    GROUP BY t2.kpis_by_role,t1.program