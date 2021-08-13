WITH 

--pull roles that are only National roles
regional_kpis AS (

SELECT 
function AS regional_function,
role AS regional_role,
kpis_by_role AS regional_rollup_kpi,
region AS region_regionkpis
--SUM(student_count) AS national_rollup_student_sum

FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE region_function = 1
),

--pull KPIs that are only program KPIs, to map to National later
program_kpis AS (
SELECT
kpis_by_role,
region,
student_count,
target_numerator,
count_of_targets,
FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE program = 1

GROUP BY 
kpis_by_role,
region,
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
    region
FROM program_kpis
WHERE count_of_targets = 1
GROUP BY kpis_by_role,
region
)

--Map program KPIs that rollup to Regions to regional_kpis table
--identify_program_rollups_for_regional AS ( 
SELECT
    regional_function,
    regional_role,
    regional_rollup_kpi,
    CASE 
        WHEN regional_rollup_kpi IS NOT NULL 
        THEN 1
        ELSE 0
    END AS indicator_program_rollup_for_regional,
    CASE
        WHEN program.region IS NULL
        THEN region_regionkpis
    END AS region
    
FROM regional_kpis AS regional
LEFT JOIN program_kpis AS program
    ON regional.regional_rollup_kpi = program.region
    AND regional.region_regionkpis=program.region
    
WHERE regional.regional_rollup_kpi = program.kpis_by_role
    AND regional.region_regionkpis=program.region
    AND program.kpis_by_role NOT IN ('% of students growing toward average or above social-emotional strengths',
                                    'Staff engagement score above average nonprofit benchmark',
                                    '% of students engaged in career exploration, readiness events or internships')
GROUP BY 
    regional.regional_function,
    regional_rollup_kpi,
    regional.regional_role,
    program.region,
    region_regionkpis