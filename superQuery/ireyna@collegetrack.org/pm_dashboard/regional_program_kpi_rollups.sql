
/*
CREATE
OR REPLACE TABLE `data-studio-260217.performance_mgt.fy22_regional_kpis`  OPTIONS (
  description = "KPIs submitted by Regional teams for FY22. This also rolls up the numerator and denominator for KPIs that are based on weighted Program KPI targets. References List of KPIs by role Ghseet, and Targets submitted thru FormAssembly Team KPI"
)
AS 
*/

WITH 

--pull roles that are only National roles
regional_kpis AS (

SELECT 
function AS regional_function,
role AS regional_role,
kpis_by_role AS regional_rollup_kpi,
site_or_region
--SUM(student_count) AS national_rollup_student_sum

FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE region_function = 1
),

--pull KPIs that are only program KPIs, to map to National later
program_kpis AS (
SELECT
kpis_by_role,
site_or_region,
student_count,
target_numerator,
count_of_targets,
FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE program = 1

GROUP BY 
kpis_by_role,
site_or_region,
student_count,
target_numerator,
count_of_targets
),

--SUM up student count and target numerators for Program KPIs
sum_program_student_count AS(
SELECT 
    SUM(student_count) AS program_student_sum,
    SUM(target_numerator) AS program_target_numerator_sum,
    kpis_by_role,
    site_or_region
FROM program_kpis
WHERE count_of_targets = 1
GROUP BY kpis_by_role,
site_or_region
),

--Map program KPIs that rollup to Regions to regional_kpis table
identify_program_rollups_for_regional AS ( 
SELECT
    regional_function,
    regional_role,
    regional_rollup_kpi,
    regional.site_or_region,
    CASE 
        WHEN regional_rollup_kpi IS NOT NULL 
        THEN 1
        ELSE 0
    END AS indicator_program_rollup_for_regional

FROM regional_kpis AS regional
LEFT JOIN program_kpis AS program
    ON regional.regional_rollup_kpi = program.kpis_by_role
    AND regional.site_or_region=program.site_or_region
    
WHERE regional.regional_rollup_kpi = program.kpis_by_role
    AND regional.site_or_region=program.site_or_region
    AND program.kpis_by_role NOT IN ('% of students growing toward average or above social-emotional strengths',
                                    'Staff engagement score above average nonprofit benchmark',
                                    '% of students engaged in career exploration, readiness events or internships')
GROUP BY 
    regional.regional_function,
    regional_rollup_kpi,
    regional.regional_role,
    site_or_region
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
region.site_or_region

FROM identify_program_rollups_for_regional AS region
LEFT JOIN  `data-studio-260217.performance_mgt.fy22_team_kpis` AS team_kpis
    ON team_kpis.kpis_by_role = region.regional_rollup_kpi
    AND team_kpis.region = region.site_or_region
LEFT JOIN sum_program_student_count AS sum_student
    ON sum_student.kpis_by_role=region.regional_rollup_kpi
    AND sum_student.site_or_region = region.site_or_region

)

--final join
--Bring in all KPIs
--map program roll-ups and SUM of stuff to Regional KPIs
SELECT 
regional.site_or_region,
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
    AND regional.site_or_region = team_kpis.site_or_region
WHERE (region_function = 1)
GROUP BY 
regional.site_or_region,
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