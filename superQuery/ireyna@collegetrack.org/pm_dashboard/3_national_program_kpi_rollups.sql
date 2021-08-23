

CREATE
OR REPLACE TABLE `data-studio-260217.performance_mgt.fy22_national_kpis`  OPTIONS (
  description = "KPIs submitted by National teams for FY22. This also rolls up the numerator and denominator for National KPIs that are based on weighted Program KPI targets. References List of KPIs by role Ghseet, and Targets submitted thru FormAssembly Team KPI"
)
AS 


WITH 

--pull roles that are only National roles
national_kpis AS (

SELECT 
function AS national_function,
role AS national_role,
kpis_by_role AS national_rollup_kpi,
--SUM(student_count) AS national_rollup_student_sum

FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE (national = 1 or hr_people = 1)
),

--Prep mapping of program KPI from Regions: % low income AND first gen to National
region_kpis AS (
SELECT  
    function, 
    site_or_region,
    kpis_by_role,

    --Crenshaw is a non-mature site and Site Director sets target. Use Site Director weighted target vs. LA RED weighted target. Blank out RED student_count
     CASE 
        WHEN site_or_region = 'LA' AND student_count = 50 AND target_numerator = 45 THEN NULL --Cresnhaw values
        ELSE student_count
    END AS student_count,

    --Crenshaw is a non-mature site and Site Director sets target. Use Site Director weighted target vs. LA RED weighted target. Blank out RED target_numerator
     CASE 
        WHEN site_or_region = 'LA' AND student_count = 50 AND target_numerator = 45 THEN NULL --Crenshaw values
        ELSE target_numerator
    END AS target_numerator,
    count_of_targets
   
FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE region_function = 1
AND kpis_by_role = '% of entering 9th grade students who are low-income AND first-gen'

GROUP BY 
function, 
kpis_by_role,
student_count,
target_numerator,
count_of_targets,
site_or_region
),

--pull KPIs that are only program KPIs, to map to National later
program_kpis AS (
SELECT
function, 
site_or_region,
kpis_by_role,
student_count,
target_numerator,
count_of_targets
FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE program = 1

GROUP BY 
function, 
kpis_by_role,
student_count,
target_numerator,
count_of_targets,
site_or_region
),

combine_regional_program_kpis AS (
SELECT program_kpis.*
FROM program_kpis 

UNION ALL 

SELECT region_kpis.*
FROM region_kpis
),

identify_program_rollups_for_national AS ( #25 KPIs for FY22
SELECT
    national.*,
    CASE 
        WHEN national_rollup_kpi IS NOT NULL 
        THEN 1
        ELSE 0
    END AS indicator_program_rollup_for_national
FROM national_kpis AS national
LEFT JOIN combine_regional_program_kpis AS program
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

--SUM up student count and target numerators for Program KPIs
sum_program_student_count AS(
SELECT 
    SUM(student_count) AS program_student_sum,
    SUM(target_numerator) AS program_target_numerator_sum,
    kpis_by_role
FROM combine_regional_program_kpis
WHERE count_of_targets = 1
GROUP BY kpis_by_role
),

--Map aggregated values from Program KPIs (student_count, target_numerator) that rollup to National here
national_rollups AS (
SELECT 
CASE
    WHEN site_or_region IS NOT NULL THEN "National"
    END AS National_location,
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

SELECT 
distinct * EXCEPT (national_function,
                    national_role, student_count)

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
indicator_program_rollup_for_national,
national_location,
regional_executive_rollup