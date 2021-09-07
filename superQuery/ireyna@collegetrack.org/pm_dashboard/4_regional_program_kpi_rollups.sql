

CREATE
OR REPLACE TABLE `data-studio-260217.performance_mgt.fy22_regional_kpis`  OPTIONS (
  description = "KPIs submitted by Regional teams for FY22. This also rolls up the numerator and denominator for KPIs that are based on weighted Program KPI targets. References List of KPIs by role Ghseet, and Targets submitted thru FormAssembly Team KPI"
)
AS 


WITH 

--pull KPIs that are only program KPIs, transform function for College Success Advisors, to map to regions later
--If college success advisor in LA or CO, then regional role
prep_kpis AS (
SELECT 
kpis_by_role,
student_count,
target_numerator,
count_of_targets,
role,
target_submitted,
program,
target_fy22,
development,
CASE
    WHEN site_or_region = 'East Palo Alto' THEN 'NOR CAL'
    WHEN site_or_region = 'Oakland' THEN 'NOR CAL'
    WHEN site_or_region = 'San Francisco' THEN 'NOR CAL'
    WHEN (site_or_region = 'Sacramento' AND region_function = 1) THEN 'Sacramento'
    WHEN (site_or_region = 'Sacramento' AND program = 1) THEN 'NOR CAL'
    WHEN site_or_region = 'Sacramento' THEN 'NOR CAL'
    WHEN site_or_region = 'Boyle Heights' THEN 'LA'
    WHEN site_or_region = 'Watts' THEN 'LA'
    WHEN site_or_region = 'Crenshaw' THEN 'LA'
    WHEN site_or_region = 'Aurora' THEN 'CO'
    WHEN site_or_region = 'Denver' THEN 'CO'
    WHEN site_or_region = 'New Orleans' THEN 'NOLA' 
    WHEN site_or_region = 'The Durant Center' THEN 'DC'
    WHEN site_or_region = 'Ward 8' THEN 'DC'
    ELSE site_or_region
END AS site_or_region,
CASE
    WHEN role = 'College Completion Advisor/College Success Advisor' AND site_or_region IN ('Boyle Heights','Watts','Denver','Aurora')
    THEN 'Mature Regional Staff'
    ELSE function
END AS function,
CASE
    WHEN role = 'College Completion Advisor/College Success Advisor' AND site_or_region IN ('Boyle Heights','Watts','Denver','Aurora')
    THEN 1
--Remove select KPIs from Nikki Wardlaw Director of Development & Partnerships role. Fulfilling 2 roles in FY22, allowed to remove KPIs 
    WHEN role = 'Director of Development & Partnerships' AND site_or_region = 'Sacramento' AND region_function = 1 AND kpis_by_role = '% of secured out-year revenue'
    THEN 0
    WHEN role = 'Director of Development & Partnerships' AND site_or_region = 'Sacramento' AND region_function = 1 AND kpis_by_role = '% of Visit Report/Touchpoints goals for the year'
    THEN 0
    ELSE region_function
END AS region_function

FROM `data-studio-260217.performance_mgt.fy22_team_kpis`  
),

--pull in transformed program KPIs into new table to union later
--this table will also be used to pull in student count and target numerators to sum up
program_kpis AS (

SELECT
role,
kpis_by_role,
student_count,
target_numerator,
count_of_targets,
site_or_region,
region_function,
function

FROM prep_kpis AS t1
WHERE program = 1

GROUP BY 
kpis_by_role,
role,
function,
site_or_region,
student_count,
target_numerator,
count_of_targets,
region_function
),

--pull program roles that are regional (CSA) to union with regional roles further down
program_union AS (
SELECT 
function,
role,
kpis_by_role,
site_or_region

FROM program_kpis 
WHERE region_function = 1
),
--pull roles that are only regional roles
regional_kpis AS (

SELECT 
regional_team_kpis.function AS regional_function,
regional_team_kpis.role AS regional_role,
regional_team_kpis.kpis_by_role AS regional_rollup_kpi,
regional_team_kpis.site_or_region

FROM `data-studio-260217.performance_mgt.fy22_team_kpis` AS regional_team_kpis

WHERE regional_team_kpis.region_function = 1
),

--Union College Success Advisor roles as part of regional roles
union_csa_regional AS (

SELECT *
FROM regional_kpis 

UNION ALL 

SELECT *
FROM program_union
),

--SUM up student count and target numerators for Program KPIs
sum_program_student_count AS(
SELECT 
    SUM(student_count) AS program_student_sum,
    SUM(target_numerator) AS program_target_numerator_sum,
    kpis_by_role,
    site_or_region
FROM program_kpis
WHERE kpis_by_role NOT IN ('Staff engagement score above average nonprofit benchmark',
                            '% of students engaged in career exploration, readiness events or internships',
                            '% of entering 9th grade students who are low-income AND first-gen'
                            )

GROUP BY 
    kpis_by_role,
    site_or_region
),

--Map program KPIs that rollup to Regions to regional_kpis table
regional_rollups AS ( 
SELECT
    regional_function,
    regional_role,
    regional_rollup_kpi,
    region.site_or_region,
    CASE 
        WHEN program_student_sum IS NOT NULL 
        THEN 1
        ELSE 0
    END AS indicator_program_rollup_for_regional,
    program_target_numerator_sum,
    program_student_sum


FROM union_csa_regional AS region
LEFT JOIN program_kpis AS program
    ON region.regional_rollup_kpi = program.kpis_by_role
    AND region.site_or_region=program.site_or_region
LEFT JOIN sum_program_student_count AS sums
    ON region.regional_rollup_kpi = sums.kpis_by_role
    AND region.site_or_region=sums.site_or_region

GROUP BY 
    regional_function,
    regional_rollup_kpi,
    regional_role,
    program.site_or_region,
    site_or_region,
    program_student_sum,
    program_target_numerator_sum
)
--final join AS(
--Bring in all KPIs
--map program roll-ups and SUM of stuff to Regional KPIs
SELECT
team_kpis.site_or_region,
function,
role,
kpis_by_role,
--target_fy22,
target_submitted,
development,
region_function,
program,
--student_count,
target_numerator,
--regional_target_numerator,
count_of_targets,
regional_rollup_kpi,

IF (regional_rollup_kpi = "% of entering 9th grade students who are low-income AND first-gen" 
    AND team_kpis.site_or_region = "LA",140,
    
IF(regional_rollup_kpi = "% of entering 9th grade students who are low-income AND first-gen" 
        AND team_kpis.site_or_region = "NOR CAL",200,
        
IF(regional_rollup_kpi = "% of entering 9th grade students who are low-income AND first-gen" 
        AND team_kpis.site_or_region = "CO",80,program_student_sum))) AS program_student_sum,
        
        
IF(target_fy22 IS NULL 
        AND team_kpis.kpis_by_role = '% of entering 9th grade students who are low-income AND first-gen' 
        AND team_kpis.site_or_region = 'DC',.82, 
IF (regional_rollup_kpi = '% of college students graduating from college within 6 years' 
        AND team_kpis.site_or_region = 'CO',.63,
IF(regional_rollup_kpi = '% of college students graduating from college within 6 years' 
        AND team_kpis.site_or_region = 'LA',.55,target_fy22))) AS target_fy22, 

program_target_numerator_sum,
--regional_student_count,
indicator_program_rollup_for_regional

FROM  prep_kpis AS team_kpis
LEFT JOIN regional_rollups AS regional
    ON regional.regional_rollup_kpi = team_kpis.kpis_by_role
    AND regional.regional_function = team_kpis.function
    AND regional.site_or_region = team_kpis.site_or_region
WHERE region_function = 1
GROUP BY 
team_kpis.site_or_region,
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
