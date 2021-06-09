WITH prep_kpi_targets AS (
  SELECT
    team_kpi,
    region_kpi,
    site_kpi,
    select_role,
    select_kpi,
    what_is_the_type_of_target_,
    CASE
      
      WHEN KPI_Target.select_role IS NOT NULL THEN "Submitted"
    --   WHEN site_kpi IN ("Sacramento", "Denver", "Watts") AND select_kpi = '% of students graduating from college within 6 years' THEN "Not Required"
      ELSE "Not Submitted"
    END AS target_submitted,
    CASE
      WHEN enter_the_target_numeric_ IS NOT NULL THEN enter_the_target_numeric_
      WHEN enter_the_target_percent_ iS NOT NULL THEN enter_the_target_percent_
      WHEN what_is_the_type_of_target_ = "Goal is met" THEN 1 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_
      ELSE NULL
    END AS target_fy22,
  FROM
    `data-warehouse-289815.google_sheets.team_kpi_target` KPI_Target
    -- WHERE email_kpi != 'test@collegetrack.org'
    -- WHERE email_kpi != 'test@collegetrack.org'-- `data-studio-260217.performance_mgt.expanded_role_kpi_selection` KPI_Selection --List of KPIs by Team/Role
    -- LEFT JOIN `data-warehouse-289815.google_sheets.team_kpi_target` KPI_Target --ON KPI_Target.team_kpi = REPLACE(KPI_Selection.function, ' ', '_')  #FormAssembly
    -- ON KPI_Target.select_role = KPI_Selection.role
    -- AND KPI_Target.select_kpi = KPI_Selection.kpis_by_role
    -- AND KPI_Target.site_kpi = KPI_Selection.site_or_region
    -- -- LEFT JOIN `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` as c
    -- ON c.kpi = KPI_Selection.kpis_by_role
    -- AND c.role = KPI_Selection.role
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
    LEFT JOIN prep_kpi_targets Non_Program_Targets ON KPI_by_role.role = Non_Program_Targets.select_role
    AND KPI_by_role.kpis_by_role = Non_Program_Targets.select_kpi
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
    LEFT JOIN prep_kpi_targets KPI_Tagets ON KPI_by_role.role = KPI_Tagets.select_role
    AND KPI_by_role.kpis_by_role = KPI_Tagets.select_kpi
    AND KPI_by_role.site_or_region = KPI_Tagets.region_kpi
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
    LEFT JOIN prep_kpi_targets KPI_Tagets ON KPI_by_role.role = KPI_Tagets.select_role
    AND KPI_by_role.kpis_by_role = KPI_Tagets.select_kpi
    AND KPI_by_role.site_or_region = KPI_Tagets.site_kpi
    LEFT JOIN join_projections Projections ON Projections.site_short = KPI_by_role.site_or_region AND Projections.student_type = KPI_by_role.student_group
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
  -- CASE
  --   WHEN site_kpi NOT IN ('East Palo Alto','Oakland','San Francisco','Sacramento','Boyle Heights','Watts','Crenshaw','Aurora','Denver','The Durant Center','Ward 8')
  --   THEN 'National'
  --   ELSE site_kpi
  -- END AS Site,
FROM
  join_tables
  WHERE kpis_by_role != "KPIs by role"
),

calculate_numerators AS (
SELECT *,
target_fy22 * student_count AS target_numerator
FROM identify_teams

),

correct_missing_site_region AS (SELECT CN.* EXCEPT(Region, Site),
CASE WHEN Region IS NULL AND site_or_region IS NOT NULL THEN Projections.region_abrev ELSE region
END AS Region,
CASE WHEN Site IS NULL AND site_or_region IS NOT NULL THEN Projections.site_short ELSE Site
END AS Site,
FROM calculate_numerators CN
LEFT JOIN `data-studio-260217.performance_mgt.fy22_projections` Projections ON CN.site_or_region = Projections.site_short
)

SELECT *
FROM correct_missing_site_region
