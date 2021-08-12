/*

CREATE
OR REPLACE TABLE `data-studio-260217.performance_mgt.fy22_national_kpis`  OPTIONS (
  description = "KPIs submitted by National teams for FY22. This also rolls up the numerator and denominator for National KPIs that are based on weighted Program KPI targets. References List of KPIs by role Ghseet, and Targets submitted thru FormAssembly Team KPI"
)
AS 
*/

WITH 

--pull roles that are only National roles
national_kpis AS (

SELECT 
function AS national_function,
role AS national_role,
kpis_by_role AS national_rollup_kpi
--SUM(student_count) AS national_rollup_student_sum

FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE (national = 1 or hr_people = 1)
),

--pull KPIs that are only program KPIs, to map to National later
program_kpis AS (
SELECT
function, 
kpis_by_role,
student_count,
target_numerator,
count_of_targets,
FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE program = 1

GROUP BY 
function, 
kpis_by_role,
student_count,
target_numerator,
count_of_targets
),

--SUM up student count and target numerators for Program KPIs
sum_program_student_count AS(
SELECT 
    SUM(student_count) AS program_student_sum,
    SUM(target_numerator) AS program_target_numerator_sum,
    kpis_by_role
FROM program_kpis
WHERE count_of_targets = 1
GROUP BY kpis_by_role
),

--Map program KPIs that rollup to National to national_kpis table
identify_program_rollups_for_national AS ( #25 KPIs for FY22
SELECT
    national.*,
    CASE 
        WHEN national_rollup_kpi IS NOT NULL 
        THEN 1
        ELSE 0
    END AS indicator_program_rollup_for_national

FROM national_kpis AS national
LEFT JOIN program_kpis AS program
    ON national.national_rollup_kpi = program.kpis_by_role
    
WHERE national.national_rollup_kpi = program.kpis_by_role
    AND program.kpis_by_role NOT IN ('% of students growing toward average or above social-emotional strengths',
                                    'Staff engagement score above average nonprofit benchmark',
                                    '% of students engaged in career exploration, readiness events or internships')
GROUP BY 
    national.national_function,
    national_rollup_kpi,
    national.national_role
),

--Map aggregated values from Program KPIs (student_count, target_numerator) that rollup to National here
national_rollups AS (
SELECT 
national_function,
national_rollup_kpi,
national_role,
--count_of_targets,
student_count AS natl_student_count,
program_student_sum,
target_numerator AS natl_target_numerator,
program_target_numerator_sum,
indicator_program_rollup_for_national

FROM identify_program_rollups_for_national AS natl
LEFT JOIN  `data-studio-260217.performance_mgt.fy22_team_kpis` AS team_kpis
    ON team_kpis.kpis_by_role = natl.national_rollup_kpi
LEFT JOIN sum_program_student_count AS sum_student
    ON sum_student.kpis_by_role=natl.national_rollup_kpi

)

--final join
--Bring in all KPIs
--map program roll-ups and SUM of stuff to National KPIs that rollup
SELECT 
distinct * EXCEPT (national_function,
                    national_role)

FROM  `data-studio-260217.performance_mgt.fy22_team_kpis` AS team_kpis
LEFT JOIN national_rollups AS natl
    ON natl.national_rollup_kpi = team_kpis.kpis_by_role
    AND natl.national_function = team_kpis.function
WHERE (national =1 OR hr_people=1)
GROUP BY 
function,
role,
kpis_by_role,
site_or_region,
target_fy22,
target_submitted,
hr_people,
national,
development,
region_function,
program,
Region,
Site,
student_count,
target_numerator,
natl_target_numerator,
count_of_targets,
national_rollup_kpi,
program_student_sum,
program_target_numerator_sum,
natl_student_count,
indicator_program_rollup_for_national