
WITH 

--pull roles that are only National roles
regional_kpis AS (

SELECT 
function AS regional_function,
role AS regional_role,
kpis_by_role AS regional_rollup_kpi,
region
--SUM(student_count) AS national_rollup_student_sum

FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE region_function = 1
),

--pull KPIs that are only program KPIs, to map to National later
program_kpis AS (
SELECT
function, 
kpis_by_role,
region,
student_count,
target_numerator,
count_of_targets,
FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE program = 1

GROUP BY 
function, 
kpis_by_role,
region,
student_count,
target_numerator,
count_of_targets
)

--SUM up student count and target numerators for Program KPIs
--sum_program_student_count AS(
SELECT 
    SUM(student_count) AS program_student_sum,
    SUM(target_numerator) AS program_target_numerator_sum,
    kpis_by_role
FROM program_kpis
WHERE count_of_targets = 1
GROUP BY kpis_by_role,
region