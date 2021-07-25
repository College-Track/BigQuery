/*
CREATE
OR REPLACE TABLE `data-studio-260217.performance_mgt.fy22_team_kpis` OPTIONS (
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
    LEFT JOIN join_projections Projections 
        ON Projections.region_abrev = KPI_by_role.site_or_region 
        AND Projections.student_type = KPI_by_role.student_group
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
  kpis_by_role,
  site_or_region,
  target_fy22,
  region_abrev AS Region,
  site_short AS Site,
  student_count,
--   target_submitted,
  
  CASE
    WHEN target_fy22 IS NOT NULL THEN "Submitted"
    WHEN site_or_region IN ("Sacramento", "Denver", "Watts") AND kpis_by_role = '% of students graduating from college within 6 years' THEN "Not Required"
    WHEN kpis_by_role = "% of students engaged in career exploration, readiness events or internships" THEN "Not Required"
    WHEN kpis_by_role = "% of students growing toward average or above social-emotional strengths" THEN "Not Required"
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
  WHERE kpis_by_role != "KPIs by role"
),

prep_calculate_numerators AS (
SELECT *,
target_fy22 * student_count AS prep_target_numerator
FROM identify_teams
),

calculate_numerators AS (
SELECT * EXCEPT (prep_target_numerator), SUM(prep_target_numerator) AS target_numerator
FROM prep_calculate_numerators
GROUP BY 
    function,
    role,
    kpis_by_role,
    site_or_region,
    target_fy22,
    Region,
    Site,
    student_count,
    target_submitted,
    hr_people,
    national,
    development,
    region_function,
    program
),

calculate_national_numerators AS (
SELECT 
    function,
    role,
    kpis_by_role,
    site_or_region,
    target_fy22,
    Region,
    Site,
    student_count,
    target_submitted,
    national,
    region_function,
CASE 
        WHEN target_numerator = 0 THEN NULL
        ELSE target_numerator
    END AS target_numerator,
SUM(student_count) AS target_denom
FROM calculate_numerators
GROUP BY 
    target_numerator,
    function,
    role,
    kpis_by_role,
    site_or_region,
    target_fy22,
    Region,
    Site,
    student_count,
    target_submitted,
    --hr_people,
    national,
    --development,
    --program
    region_function
    
),
correct_missing_site_region AS (
SELECT CN.* EXCEPT(Region, Site),
CASE WHEN Region IS NULL AND site_or_region IS NOT NULL THEN Projections.region_abrev ELSE region
END AS Region,
CASE WHEN Site IS NULL AND site_or_region IS NOT NULL THEN Projections.site_short ELSE Site
END AS Site,
FROM prep_calculate_numerators AS CN --calculate_numerators CN
LEFT JOIN `data-studio-260217.performance_mgt.fy22_projections` Projections ON CN.site_or_region = Projections.site_short
),

national_fy22_target_rollup AS (
SELECT
    calculate_national_numerators.* EXCEPT(Region, Site,role,function,kpis_by_role,target_denom,site_or_region),
    modify_regional_kpis.function,
    modify_regional_kpis.role,
    modify_regional_kpis.kpis_by_role,
    site,
    region,
    target_numerator/target_denom AS fy22_target_rollup,
      CASE 
        WHEN target_denom = 0 THEN NULL
        ELSE target_denom
    END AS target_denom,
    CASE 
        WHEN Region IS NULL AND calculate_national_numerators.site_or_region IS NOT NULL THEN Projections.region_abrev ELSE region
    END AS Region,
    CASE 
        WHEN Site IS NULL AND calculate_national_numerators.site_or_region IS NOT NULL THEN Projections.site_short ELSE Site
    END AS Site
FROM calculate_national_numerators 
LEFT JOIN modify_regional_kpis 
    ON calculate_national_numerators.site = modify_regional_kpis.site_or_region
    AND calculate_national_numerators.region = modify_regional_kpis.site_or_region
    AND calculate_national_numerators.kpis_by_role = modify_regional_kpis.kpis_by_role
LEFT JOIN `data-studio-260217.performance_mgt.fy22_projections` Projections 
    ON calculate_national_numerators.site_or_region = Projections.site_short



/*SELECT CN.* EXCEPT(Region, Site),
CASE WHEN Region IS NULL AND site_or_region IS NOT NULL THEN Projections.region_abrev ELSE region
END AS Region,
CASE WHEN Site IS NULL AND site_or_region IS NOT NULL THEN Projections.site_short ELSE Site
END AS Site,
FROM prep_calculate_numerators AS CN --calculate_numerators CN
LEFT JOIN */
)


SELECT distinct *,
CASE WHEN target_submitted = 'Submitted' THEN 1
ELSE 0
END AS count_of_submitted_targets,
CASE WHEN target_submitted != "Not Required" THEN 1
ELSE 0
END AS count_of_targets,
CASE WHEN SUM(student_count) IS NOT NULL THEN ROUND(SUM(target_numerator)/SUM(student_count),2)
ELSE SUM(target_fy22)/COUNT(role)
END AS ir_test_2
FROM national_fy22_target_rollup --correct_missing_site_region
GROUP BY
    target_submitted,
    student_count,
    target_fy22,
    fy22_target_rollup,
    role,
    function,
    kpis_by_role,
    region,
    site,
    target_denom
    