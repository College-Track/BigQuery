SELECT 
function,
role,
    (SELECT t2.kpis_by_role 
    FROM `data-studio-260217.performance_mgt.fy22_team_kpis` AS t2 
    WHERE t2.kpis_by_role = t1.kpis_by_role 
    AND t1.program =1 
    GROUP BY t2.kpis_by_role,t1.program) AS national_rollup_kpi
--SUM(student_count) AS national_rollup_student_sum

FROM `data-studio-260217.performance_mgt.fy22_team_kpis` AS t1
WHERE national = 1 or hr_people = 1
GROUP BY 
kpis_by_role,
program,
function,
role