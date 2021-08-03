/*
CREATE
OR REPLACE TABLE `data-studio-260217.performance_mgt.fy22_national_program_kpis_rollup`  OPTIONS (
  description = "Aggregates  Program-based KPIs that roll up at the national level. Calculations/rollup totald done in Data Studio"
)
AS 
*/

WITH
national_program_kpi AS (
--aggregate student counts without dupe student counts
    SELECT MAX(student_count) AS student_count_prep, FUNCTION, kpis_by_role, site_or_region
    from  `data-studio-260217.performance_mgt.fy22_team_kpis` 
    where program=1
    --and target_submitted = 'Submitted'
    group by FUNCTION, kpis_by_role, site_or_region
)
SELECT SUM(student_count_prep) national_kpi_rollup,
kpis_by_role
FROM national_program_kpi
group by FUNCTION, kpis_by_role

;


/*
WITH  site_program_rollups AS(
SELECT 
kpis_by_role AS program_kpi
FROM `data-studio-260217.performance_mgt.fy22_team_kpis` AS baker_team_kpis
WHERE program = 1
AND student_count IS NOT NULL
GROUP BY function, kpis_by_role, site_or_region
)

--national_kpis_mapped_to_program AS (
SELECT program_kpi AS national_program_kpi
FROM site_program_rollups AS t1
LEFT JOIN  `data-studio-260217.performance_mgt.fy22_team_kpis` AS baker_team_kpis 
    ON baker_team_kpis.kpis_by_role = t1.program_kpi 
WHERE national =1
GROUP BY t1.program_kpi
*/