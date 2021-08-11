SELECT
function, 
role,
kpis_by_role,
    (SELECT t2.role 
    FROM `data-studio-260217.performance_mgt.fy22_team_kpis` AS t2 
    WHERE  (t2.national = 1 or t2.hr_people = 1) and t2.kpis_by_role=t1.kpis_by_role
    GROUP BY t2.role) AS national_role_program_kpi_table,
student_count,
count_of_targets
FROM `data-studio-260217.performance_mgt.fy22_team_kpis` AS t1
WHERE program = 1