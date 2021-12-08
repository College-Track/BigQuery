
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
    kpis_by_role AS national_rollup_kpi,

--Remove select KPIs from Nikki Wardlaw Director of Philanthropic Initiatives role. Fulfilling 2 roles in FY22, allowed to remove KPIs     
CASE
    WHEN role = 'Director of Philanthropic Initiatives' AND kpis_by_role = '% of Board giving (National or Local Advisory Board)'
    THEN 0
    ELSE national
END AS national
FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE (national = 1 or hr_people = 1)
),

--Prep mapping of program KPI from Regions: % low income AND first gen to National
region_kpis AS (
SELECT  
    target_submitted,
    function, 
    site_or_region,
    kpis_by_role,
    target_fy22,

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
    AND target_submitted= 'Submitted'

GROUP BY 
    function, 
    kpis_by_role,
    target_fy22,
    student_count,
    target_numerator,
    count_of_targets,
    site_or_region,
    target_submitted
),

--pull KPIs that are only program KPIs, to map to National later
program_kpis AS (
SELECT
    target_submitted,
    function, 
    site_or_region,
    kpis_by_role,
    target_fy22,
    student_count,
    target_numerator,
    count_of_targets
FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE program = 1 AND target_submitted = 'Submitted'
GROUP BY 
    function, 
    kpis_by_role,
    target_fy22,
    student_count,
    target_numerator,
    count_of_targets,
    site_or_region
    ,target_submitted
)

,combine_regional_program_kpis AS (
SELECT program_kpis.*
FROM program_kpis 

UNION DISTINCT 

SELECT region_kpis.*
FROM region_kpis
)

,identify_program_rollups_for_national AS ( #25 KPIs for FY22 --up to here looks accurate for roll up identification
SELECT
    DISTINCT national.* EXCEPT (national),
    target_fy22,
    program.target_submitted,
    site_or_region,
    CASE 
        WHEN national_rollup_kpi IS NOT NULL 
        THEN 1
        ELSE 0
    END AS indicator_program_rollup_for_national
FROM national_kpis AS national
LEFT JOIN combine_regional_program_kpis AS program
    ON national.national_rollup_kpi = program.kpis_by_role
    
WHERE national.national_rollup_kpi = program.kpis_by_role
    AND program.kpis_by_role NOT IN ('% of students growing toward average or above social-emotional strengths', --excluded for FY21 OR 
                                    'Staff engagement score above average nonprofit benchmark',
                                    '% of students engaged in career exploration, readiness events or internships')
GROUP BY 
    national_function,
    national_rollup_kpi,
    national_role,
    target_fy22,
    target_submitted
    ,site_or_region
)

--SUM up student count and target numerators for Program KPIs. Use this CTE to see which sites submitted what targets, their student count, to verify FY22 national rollup
,sum_program_student_count AS(
SELECT  
    kpis_by_role,
    SUM(program_target_numerator_sum)/SUM(program_student_sum) AS target_fy22, --national rollup (see subquery for logic)
    program_target_numerator_sum,
    program_student_sum AS program_student_sum_denom
FROM 
    (
        SELECT 
            CASE 
                WHEN student_count IS NULL THEN count_of_targets --if there is no student count, take the target that was set. Will be divided by count of targets to get the target_fy22
                WHEN student_count = 0 THEN NULL 
                ELSE SUM(student_count) END AS program_student_sum,
            CASE 
                WHEN target_numerator IS NULL THEN target_fy22 --if there is no student count (and therefore no numerator), take the count of targets
                WHEN target_numerator = 0 THEN NULL 
                ELSE SUM(target_numerator) END AS program_target_numerator_sum,
            kpis_by_role,
            target_fy22,
            count_of_targets
            --site_or_region #bring back in to see which sites set targets for each KPI that rolls up
        FROM combine_regional_program_kpis
        WHERE count_of_targets = 1 
        GROUP BY kpis_by_role,target_fy22,student_count,target_numerator,count_of_targets
    )
GROUP BY 
    kpis_by_role,
    program_target_numerator_sum,
    program_student_sum
    --site_or_region #bring back in to see which sites set targets for each KPI that rolls up
)
--Pull in fy22 targets for National rollups and pull in field: indicator_program_rollup_for_national (from identify_program_rollups_for_national CTE)
SELECT 
DISTINCT 
        team_kpis.function,
        role,
        CASE WHEN sum_student.target_fy22 IS NOT NULL THEN sum_student.target_fy22 ELSE team_kpis.target_fy22 END AS target_fy22,
        CASE WHEN indicator_program_rollup_for_national = 1 THEN natl_rollups.national_rollup_kpi ELSE team_kpis.kpis_by_role END AS kpis_by_role,
        natl_rollups.indicator_program_rollup_for_national,
        team_kpis.national,
        team_kpis.hr_people,
        program_target_numerator_sum,
        program_student_sum_denom
FROM  `data-studio-260217.performance_mgt.fy22_team_kpis` AS team_kpis
LEFT JOIN sum_program_student_count AS sum_student
    ON sum_student.kpis_by_role = team_kpis.kpis_by_role

LEFT JOIN identify_program_rollups_for_national AS natl_rollups 
    ON natl_rollups.national_rollup_kpi = team_kpis.kpis_by_role
    
WHERE (national =1 OR hr_people=1) 

GROUP BY 
team_kpis.function,
team_kpis.role,
kpis_by_role,
target_fy22,
hr_people,
national,
development,
indicator_program_rollup_for_national,
program_target_numerator_sum,
        program_student_sum_denom