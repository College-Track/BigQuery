SELECT 

    (SELECT t2.function 
    FROM `data-studio-260217.performance_mgt.fy22_team_kpis` AS t2 
    WHERE  t2.national = 1 or t2.hr_people = 1 and t2.function=t1.function
    GROUP BY t2.function) AS national_function,
    
    (SELECT t2.role 
    FROM `data-studio-260217.performance_mgt.fy22_team_kpis` AS t2 
    WHERE t2.national = 1 or t2.hr_people = 1 and t2.role=t1.role
    GROUP BY t2.role) AS national_role,
    
    (SELECT t2.kpis_by_role 
    FROM `data-studio-260217.performance_mgt.fy22_team_kpis` AS t2 
    WHERE t2.kpis_by_role = t1.kpis_by_role 
    AND t1.program =1 
    GROUP BY t2.kpis_by_role,t1.program) AS national_rollup_kpi
--SUM(student_count) AS national_rollup_student_sum

FROM `data-studio-260217.performance_mgt.fy22_team_kpis` AS t1
--WHERE national = 1 or hr_people = 1
GROUP BY 
kpis_by_role,
program,
function,
role