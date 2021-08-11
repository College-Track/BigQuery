#NEED TO CREATE SUM OF NUMERATOR NEXT!

/*
CREATE
OR REPLACE TABLE `ct-testing-op.testing_salesforce_raw.testing_fy22_team_kpi` OPTIONS (
  description = "KPIs submitted by Team for FY22. References List of KPIs by role Ghseet, and Targets submitted thru FormAssembly Team KPI"
)
AS 
*/




WITH prep_kpi_targets AS (
  SELECT
    CASE 
        WHEN indicator_disregard_entry_op_hard_coded IS NULL THEN 0
        ELSE indicator_disregard_entry_op_hard_coded	
    END AS indicator_disregard_entry_op_hard_coded,
    select_role,
    CASE 
        WHEN site_kpi = "Boyle_Heights" THEN "Boyle Heights"
        WHEN site_kpi = "East_Palo_Alto" THEN "East Palo Alto"
        WHEN site_kpi = "New_Orleans" THEN "New Orleans"
        WHEN site_kpi = "San_Francisco" THEN "San Francisco"
        WHEN site_kpi = "The_Durant_Center" THEN "The Durant Center"
        WHEN site_kpi = "Ward_8" THEN "Ward 8"
        ELSE site_kpi
    END AS site_kpi,
    CASE 
        WHEN region_kpi = "Bay_Area" THEN "Bay Area"
        WHEN region_kpi = "NOR_CAL" THEN "NOR CAL"
        ELSE region_kpi
    END AS region_kpi,
    CASE
        WHEN team_kpi = "Org_Performance" THEN "Org Performance"
        WHEN team_kpi = "Employee_Experience" THEN "Employee Experience"
        WHEN team_kpi = "Talent_Acquisition" THEN "Talent Acquisition"
        WHEN team_kpi = "Talent_Development" THEN "Talent Development"
        WHEN team_kpi = "Strategic_Initiatives" THEN "Strategic Initiatives"
        WHEN team_kpi = "Fund_Raising" THEN "Fund Raising"
        WHEN team_kpi = "Mature_Site_Staff" THEN "Mature Site Staff" 
        WHEN team_kpi = "Non-Mature_Site_Staff" THEN "Non-Mature Site Staff"
        WHEN team_kpi = "Mature_Regional_Staff" THEN "Mature Regional Staff" 
        WHEN team_kpi = "Non-Mature_Regional_Staff" THEN "Non-Mature Regional Staff"
        ELSE team_kpi
    END AS team_kpi,
    CASE
        WHEN select_kpi = 'Student Survey - % of students served by Wellness who "strongly agree" wellness services assisted them in managing their stress, helping them engage in self-care practices and/or enhancing their mental health'
            THEN 'Student Survey - % of students served by Wellness who "agree" or "strongly agree" wellness services assisted them in managing their stress, helping them engage in self-care practices and/or enhancing their mental health'
        WHEN select_kpi = '% of high school seniors who matriculate to Good, Best, or Situational Best Fit colleges'
            THEN '% of students matriculating to Best Fit, Good Fit, or Situational Best Fit colleges'
        WHEN select_kpi = '% of students graduating from college within 6 years'
            THEN '% of college students graduating from college within 6 years' 
        WHEN select_kpi like '% # of business days to close the month%'
            THEN '# of business days to close the month'
        WHEN select_kpi = 'Average score on Development Operations Services Quality Assessment survey, capturing satisfaction of supports and usefulness of tools and training'
            THEN 'Average score on role-specific Development Operations Services Quality Assessment survey, capturing satisfaction of supports and usefulness of tools and training'
        ELSE select_kpi
    END AS select_kpi,
    what_is_the_type_of_target_,
    CASE
      WHEN KPI_Target.select_role IS NOT NULL THEN "Submitted"
      ELSE "Not Submitted"
    END AS target_submitted,
    CASE
      WHEN enter_the_target_numeric_ IS NOT NULL THEN enter_the_target_numeric_
      WHEN enter_the_target_percent_ iS NOT NULL THEN enter_the_target_percent_
      WHEN what_is_the_type_of_target_ = "Goal is met" THEN 1 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_count
      ELSE NULL
    END AS target_fy22,
  FROM
    `data-warehouse-289815.google_sheets.audit_kpi_target_submissions` KPI_Target
    WHERE email_kpi != 'test@collegetrack.org'
),

prep_student_type_projections AS (
SELECT  
region_abrev,
site_short,
student_type,
SUM(student_count) AS student_count,

FROM `data-studio-260217.performance_mgt.fy22_projections`
GROUP BY site_short, 
region_abrev,
student_type

),

prep_grade_projections AS (
SELECT region_abrev, site_short,
grade AS student_type,
SUM(student_count) AS student_count
FROM `data-studio-260217.performance_mgt.fy22_projections`
GROUP BY site_short, 
region_abrev,
grade
),

join_projections AS (
SELECT PGP.*
FROM prep_grade_projections PGP
UNION ALL
SELECT PSTP.*
FROM prep_student_type_projections PSTP


),

prep_non_program_kpis AS (
  SELECT
    KPI_by_role.*,
    Non_Program_Targets.*,
    CAST(NULL AS STRING) AS region_abrev,
    CAST(NULL AS STRING) AS site_short,
    NULL AS student_count
  FROM
    `data-studio-260217.performance_mgt.expanded_role_kpi_selection` KPI_by_role
    LEFT JOIN prep_kpi_targets Non_Program_Targets ON KPI_by_role.function = Non_Program_Targets.team_kpi --KPI_by_role.role = Non_Program_Targets.select_role
    AND KPI_by_role.kpis_by_role = Non_Program_Targets.select_kpi
    AND indicator_disregard_entry_op_hard_coded	 <> 1
  WHERE
    KPI_by_role.function NOT IN (
      'Non-Mature Site Staff',
      'Mature Site Staff',
      'Mature Regional Staff',
      'Non-Mature Regional Staff',
      'Function'
    )
),

modify_regional_kpis AS (
SELECT
* EXCEPT (site_or_region),
CASE WHEN (student_group IS NOT NULL AND site_or_region = "Bay Area") THEN "NOR CAL"
ELSE site_or_region
END AS site_or_region
FROM
    `data-studio-260217.performance_mgt.expanded_role_kpi_selection` KPI_by_role
WHERE
    KPI_by_role.function IN (
      'Mature Regional Staff',
      'Non-Mature Regional Staff'
    )    
),

prep_regional_kpis AS (
  SELECT
   KPI_by_role.*,
   KPI_Tagets.*,
   Projections.region_abrev,
    Projections.site_short,
    Projections.student_count
  FROM
    modify_regional_kpis KPI_by_role
    LEFT JOIN prep_kpi_targets KPI_Tagets --ON KPI_by_role.role = KPI_Tagets.select_role
    ON KPI_by_role.kpis_by_role = KPI_Tagets.select_kpi --map on shared KPI
    AND KPI_by_role.site_or_region = KPI_Tagets.region_kpi --map Region to Region
    AND KPI_by_role.function = KPI_Tagets.team_kpi --map teams/functions (mature regional staff, non-mature regional staff)
    AND indicator_disregard_entry_op_hard_coded	 <> 1
    LEFT JOIN join_projections Projections ON Projections.region_abrev = KPI_by_role.site_or_region AND Projections.student_type = KPI_by_role.student_group
  WHERE
    KPI_by_role.function IN (
      'Mature Regional Staff',
      'Non-Mature Regional Staff'
    )
),
prep_site_kpis AS (
  SELECT
    KPI_by_role.*,
    KPI_Tagets.*,
    Projections.region_abrev,
    Projections.site_short,
    Projections.student_count
  FROM
    `data-studio-260217.performance_mgt.expanded_role_kpi_selection` KPI_by_role
    LEFT JOIN prep_kpi_targets KPI_Tagets --ON KPI_by_role.role = KPI_Tagets.select_role
    ON KPI_by_role.kpis_by_role = KPI_Tagets.select_kpi --map on shared KPI
    AND KPI_by_role.site_or_region = KPI_Tagets.site_kpi --map Site to Site
    AND KPI_by_role.function = KPI_Tagets.team_kpi --added to test shared_kpis. Map to team/function (mature site, non-mature site)
    AND indicator_disregard_entry_op_hard_coded	 <> 1
    LEFT JOIN join_projections Projections 
        ON Projections.site_short = KPI_by_role.site_or_region 
        AND Projections.student_type = KPI_by_role.student_group
        
  WHERE
    KPI_by_role.function IN ('Mature Site Staff', 'Non-Mature Site Staff')
 
),

sum_student_count_by_program_kpi AS (
SELECT distinct 
    kpis_by_role,
    (SELECT SUM(student_count) FROM prep_site_kpis AS t2 WHERE t2.kpis_by_role = t1.kpis_by_role AND t2.target_submitted = 'Submitted') AS student_count_sum
FROM prep_site_kpis  AS t1
),

join_tables AS (
  SELECT
    PSK.*
  FROM
    prep_site_kpis PSK
  UNION ALL
  SELECT
    PRK.*
  FROM
    prep_regional_kpis PRK
  UNION ALL
  SELECT
    PNPK.*
  FROM
    prep_non_program_kpis PNPK
),

identify_teams AS (
SELECT
  function,
  role,
  join_tables.kpis_by_role,
  student_count_sum,
  --student_count_sum_region,
  site_or_region,
  target_fy22,
  join_tables.region_abrev AS Region,
  site_short AS Site,
  student_count,
--   target_submitted,
  
  CASE
    WHEN target_fy22 IS NOT NULL THEN "Submitted"
    /*WHEN site_or_region IN ("Sacramento", "Denver", "Watts") AND kpis_by_role = '% of students graduating from college within 6 years' THEN "Not Required"
    WHEN kpis_by_role = "% of students engaged in career exploration, readiness events or internships" THEN "Not Required"
    WHEN kpis_by_role = "% of students growing toward average or above social-emotional strengths" THEN "Not Required"
    WHEN role IN ('Mental Health and Wellness Director','SL/MH&W Director (Non-Mature)','SL/MH&W Director') AND site_or_region IN ('San Francisco','Sacramento','Aurora','Denver','Boyle Heights') THEN "Not Required"
    WHEN role IN ('College Access Director (Fellow)','College Access Director (Non-Mature)') AND site_or_region IN ('Crenshaw','The Durant Center','Ward 8','East Palo Alto') THEN "Not Required"
    WHEN role = 'Regional College and Career Director' AND site_or_region = 'Sacramento' THEN "Not Required"
    --WHEN (kpis_by_role = "% of college students who persist into the following year (all college students, not just first-years)" AND site_or_region = "Watts") THEN "Not Required"*/
    ELSE "Not Submitted"
  END AS target_submitted,
  CASE
    WHEN function IN (
      'Talent Acquisition',
      'Talent Development',
      'Employee Experience'
    ) THEN 1
    ELSE 0
  END AS hr_people,
  CASE
    WHEN function IN (
      'Finance',
      'Strategic Initiatives',
      'Org Performance',
      'IT',
      'Marketing',
      'Program Development',
      'Operations'
    ) THEN 1
    ELSE 0
  END AS national,
  CASE
    WHEN function IN ('Partnerships', 'Fund Raising') THEN 1
    ELSE 0
  END AS development,
  CASE
    WHEN function IN ('Mature Regional Staff', 'Non-Mature Regional Staff') THEN 1
    ELSE 0
  END AS region_function,
  CASE
    WHEN function IN ('Mature Site Staff', 'Non-Mature Site Staff') THEN 1
    ELSE 0
  END AS program,
 
FROM
  join_tables
LEFT JOIN sum_student_count_by_program_kpi ON join_tables.kpis_by_role = sum_student_count_by_program_kpi.kpis_by_role
--LEFT JOIN sum_student_count_by_regional_kpi ON join_tables.kpis_by_role = sum_student_count_by_regional_kpi.kpis_by_role AND join_tables.region_abrev = sum_student_count_by_regional_kpi.region_abrev
  WHERE join_tables.kpis_by_role != "KPIs by role"
),

calculate_numerators AS (
SELECT 
*,
target_fy22 * student_count AS target_numerator
FROM identify_teams 
),

calculate_regional_rollups AS (
SELECT 
--Identify program kpis that roll-up regionally
(SELECT t2.kpis_by_role FROM prep_regional_kpis AS t2 WHERE t2.kpis_by_role = t1.kpis_by_role AND t1.program =1 GROUP BY kpis_by_role) AS regional_rollup_kpi,
--Map program kpis that roll-up regionally to the Region
(SELECT t2.region_abrev FROM prep_regional_kpis AS t2 WHERE t2.kpis_by_role = t1.kpis_by_role AND t2.region_abrev = t1.region AND t1.program =1 GROUP BY region_abrev /*t2.site_or_region,kpis_by_role,t2.region_abrev*/) AS rollup_kpi_region,
--Sum of students for regional rollups
(SELECT SUM(student_count) FROM prep_regional_kpis AS t2 WHERE t2.kpis_by_role = t1.kpis_by_role AND t1.program =1 AND t2.region_abrev = t1.region GROUP BY region_abrev) AS regional_rollup_student_sum,

FROM identify_teams AS t1
GROUP BY 
kpis_by_role,
t1.program,
t1.region

),

calculate_national_rollups AS (
SELECT 
--Identify program kpis that roll-up nationally
(SELECT t2.kpis_by_role FROM prep_non_program_kpis AS t2 WHERE t2.kpis_by_role = t1.kpis_by_role AND t1.program =1 GROUP BY kpis_by_role) AS national_rollup_kpi,
--Sum of students for national rollups
(SELECT SUM(student_count) FROM prep_regional_kpis AS t2 WHERE t2.kpis_by_role = t1.kpis_by_role AND t1.program =1) AS national_rollup_student_sum

FROM identify_teams AS t1
GROUP BY 
kpis_by_role,
t1.program

),

correct_missing_site_region AS (
SELECT CN.* EXCEPT(Region, Site, student_count, target_numerator), --student_count, target_numerator added by IR
CASE WHEN Region IS NULL AND site_or_region IS NOT NULL THEN Projections.region_abrev ELSE region
END AS Region,
CASE WHEN Site IS NULL AND site_or_region IS NOT NULL THEN Projections.site_short ELSE Site
END AS Site,

--added by IR
CASE WHEN target_submitted = 'Not Submitted' THEN NULL
ELSE cn.student_count
END AS student_count,
CASE WHEN target_submitted = 'Not Submitted' THEN NULL
ELSE target_numerator
END AS target_numerator

FROM calculate_numerators CN
LEFT JOIN `data-studio-260217.performance_mgt.fy22_projections` Projections ON CN.site_or_region = Projections.site_short
),

all_kpi_data AS (
SELECT distinct * except (student_count_sum),--,student_count_sum_region),
--CASE WHEN target_submitted = 'Submitted' THEN 1
--ELSE 0
--END AS count_of_submitted_targets,
CASE WHEN target_submitted = "Submitted" THEN 1 -- "Not Required" THEN 1
ELSE 0
END AS count_of_targets
FROM correct_missing_site_region AS t1
)

SELECT * --EXCEPT (kpis_by_role)
FROM all_kpi_data 
--LEFT JOIN sum_student_count_by_program_kpi ON all_kpi_data.kpis_by_role = sum_student_count_by_program_kpi.kpis_by_role
LEFT JOIN calculate_national_rollups ON all_kpi_data.kpis_by_role = national_rollup_kpi
LEFT JOIN calculate_regional_rollups ON all_kpi_data.kpis_by_role = regional_rollup_kpi  AND all_kpi_data.region = rollup_kpi_region
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
count_of_targets,
national_rollup_kpi,
national_rollup_student_sum,
regional_rollup_kpi,
rollup_kpi_region,
regional_rollup_student_sum

;

WITH 
national_kpis AS (

SELECT 
function AS national_function,
role AS national_role,
kpis_by_role AS national_rollup_kpi
--SUM(student_count) AS national_rollup_student_sum

FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 
WHERE (national = 1 or hr_people = 1)
),

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

sum_program_student_count AS(
SELECT 
    SUM(student_count) AS program_student_sum,
    SUM(target_numerator) AS program_target_numerator_sum,
    kpis_by_role
FROM program_kpis
WHERE count_of_targets = 1
GROUP BY kpis_by_role
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

national_rollups AS (
SELECT 
national_function,
national_rollup_kpi,
national_role,
count_of_targets,
program_student_sum,
program_target_numerator_sum,
indicator_program_rollup_for_national

FROM identify_program_rollups_for_national AS natl
LEFT JOIN  `data-studio-260217.performance_mgt.fy22_team_kpis` AS team_kpis
    ON team_kpis.kpis_by_role = natl.national_rollup_kpi
LEFT JOIN sum_program_student_count AS sum_student
    ON sum_student.kpis_by_role=natl.national_rollup_kpi

)
SELECT 
team_kpis.*,
national_rollup_kpi,
program_student_sum,
program_target_numerator_sum

FROM  `data-studio-260217.performance_mgt.fy22_team_kpis` AS team_kpis
LEFT JOIN national_rollups AS natl
    ON natl.national_rollup_kpi = team_kpis.kpis_by_role
    AND natl.national_function = team_kpis.function