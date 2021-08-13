),

--Map aggregated values from Program KPIs (student_count, target_numerator) that rollup to regions here
regional_rollups AS (
SELECT 
regional_function,
regional_rollup_kpi,
regional_role,
--count_of_targets,
student_count AS regional_student_count,
program_student_sum,
target_numerator AS regional_target_numerator,
program_target_numerator_sum,
indicator_program_rollup_for_regional,
regional.region

FROM identify_program_rollups_for_regional AS regional
LEFT JOIN  `data-studio-260217.performance_mgt.fy22_team_kpis` AS team_kpis
    ON team_kpis.kpis_by_role = regional.regional_rollup_kpi
    AND team_kpis.region = regional.region
LEFT JOIN sum_program_student_count AS sum_student
    ON sum_student.kpis_by_role=regional.regional_rollup_kpi
    AND sum_student.region = regional.region

)

--final join
--Bring in all KPIs
--map program roll-ups and SUM of stuff to Regional KPIs
SELECT 
regional.region,
function,
role,
kpis_by_role,
target_fy22,
target_submitted,
development,
region_function,
program,
--student_count,
target_numerator,
--regional_target_numerator,
count_of_targets,
regional_rollup_kpi,
program_student_sum,
program_target_numerator_sum,
--regional_student_count,
indicator_program_rollup_for_regional

FROM  `data-studio-260217.performance_mgt.fy22_team_kpis` AS team_kpis
LEFT JOIN regional_rollups AS regional
    ON regional.regional_rollup_kpi = team_kpis.kpis_by_role
    AND regional.regional_function = team_kpis.function
    AND regional.region = team_kpis.region
WHERE (region_function = 1)
GROUP BY 
regional.region,
function,
role,
kpis_by_role,
target_fy22,
target_submitted,
development,
region_function,
program,
--student_count,
target_numerator,
--regional_target_numerator,
count_of_targets,
regional_rollup_kpi,
program_student_sum,
program_target_numerator_sum,
--regional_student_count,
indicator_program_rollup_for_regional