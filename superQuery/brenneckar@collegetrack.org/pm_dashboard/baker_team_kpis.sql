-- CREATE
-- OR REPLACE TABLE `data-studio-260217.performance_mgt.fy22_team_kpis` OPTIONS (
--   description = "KPIs submitted by Team for FY22. References List of KPIs by role Ghseet, and Targets submitted thru FormAssembly Team KPI"
-- ) AS -- CREATE OR REPLACE TABLE `data-studio-260217.performance_mgt.fy22_team_kpis`
-- -- OPTIONS
-- --     (
-- --     description="KPIs submitted by Team for FY22. References List of KPIs by role Ghseet, and Targets submitted thru FormAssembly Team KPI"
-- --     )
-- -- AS
WITH prep_kpi_targets AS (
  SELECT
    team_kpi,
    region_kpi,
    site_kpi,
    select_role,
    select_kpi,
    what_is_the_type_of_target_,
    CASE
      WHEN KPI_Target.select_role IS NOT NULL THEN true
      ELSE false
    END AS target_submitted,
    CASE
      WHEN enter_the_target_numeric_ IS NOT NULL THEN enter_the_target_numeric_
      WHEN enter_the_target_percent_ iS NOT NULL THEN enter_the_target_percent_
      WHEN what_is_the_type_of_target_ = "Goal is met" THEN 1 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_
      ELSE NULL
    END AS target_fy22,
  FROM
    `data-warehouse-289815.google_sheets.team_kpi_target` KPI_Target
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
    *
  FROM
    `data-studio-260217.performance_mgt.expanded_role_kpi_selection` KPI_by_role
    LEFT JOIN prep_kpi_targets Non_Program_Targets ON KPI_by_role.role = Non_Program_Targets.select_role
    AND KPI_by_role.kpis_by_role = Non_Program_Targets.select_kpi
  WHERE
    KPI_by_role.function NOT IN (
      'Non-Mature Site Staff',
      'Mature Site Staff',
      'Mature Regional Staff',
      'Non-Mature Regional Staff'
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
    Projections.site_short,
    Projections.student_count
  FROM
    `data-studio-260217.performance_mgt.expanded_role_kpi_selection` KPI_by_role
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
    Projections.site_short,
    Projections.student_count
  FROM
    `data-studio-260217.performance_mgt.expanded_role_kpi_selection` KPI_by_role
    LEFT JOIN prep_kpi_targets Non_Program_Targets ON KPI_by_role.role = Non_Program_Targets.select_role
    AND KPI_by_role.kpis_by_role = Non_Program_Targets.select_kpi
    AND KPI_by_role.site_or_region = Non_Program_Targets.site_kpi
    LEFT JOIN join_projections Projections ON Projections.site_short = KPI_by_role.site_or_region AND Projections.student_type = KPI_by_role.student_group
  WHERE
    KPI_by_role.function IN ('Mature Site Staff', 'Non-Mature Site Staff')
 
)

SELECT *
FROM modify_regional_kpis
