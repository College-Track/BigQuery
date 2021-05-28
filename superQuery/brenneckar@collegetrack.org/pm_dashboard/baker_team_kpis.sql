
-- CREATE OR REPLACE TABLE `data-studio-260217.performance_mgt.fy22_team_kpis`
-- OPTIONS
--     (
--     description="KPIs submitted by Team for FY22. References List of KPIs by role Ghseet, and Targets submitted thru FormAssembly Team KPI"
--     )
-- AS
	


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
      WHEN what_is_the_type_of_target_ = "Goal is met" THEN 1
    --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_
      ELSE NULL
    END AS target_fy22,
    --CASE
    --  WHEN site_kpi = 0 THEN NULL
    --  ELSE site_kpi
    --END AS site,
    -- CASE
    --   WHEN KPI_Selection.function IN ('Talent Acquisition','Talent Development','Employee Experience')
    --   THEN 1
    --   ELSE 0
    -- END AS hr_people,
    -- CASE 
    --   WHEN KPI_Selection.function IN ('Finance','Strategic Initiatives','Org Performance','IT','Marketing','Program Development','Operations')
    --   THEN 1
    --   ELSE 0
    -- END AS national,
    -- CASE
    --   WHEN KPI_Selection.function IN ('Partnerships','Fund Raising')
    --   THEN 1
    --   ELSE 0
    -- END AS development,
    --     CASE
    --   WHEN KPI_Selection.function IN ('Mature Region Staff','Non-Mature Region Staff')
    --   THEN 1
    --   ELSE 0
    -- END AS region_function,
    -- CASE
    --   WHEN KPI_Selection.function IN ('Mature Site Staff','Non-Mature Site Staff')
    --   THEN 1
    --   ELSE 0
    -- END AS program,
    -- CASE
    --   WHEN site_kpi NOT IN ('East Palo Alto','Oakland','San Francisco','Sacramento','Boyle Heights','Watts','Crenshaw','Aurora','Denver','The Durant Center','Ward 8')
    --   THEN 'National'
    --   ELSE site_kpi
    -- END AS Site,
    
  FROM
  `data-warehouse-289815.google_sheets.team_kpi_target` KPI_Target
    -- `data-studio-260217.performance_mgt.expanded_role_kpi_selection` KPI_Selection --List of KPIs by Team/Role
    -- LEFT JOIN `data-warehouse-289815.google_sheets.team_kpi_target` KPI_Target --ON KPI_Target.team_kpi = REPLACE(KPI_Selection.function, ' ', '_')  #FormAssembly 
    -- ON KPI_Target.select_role = KPI_Selection.role
    -- AND KPI_Target.select_kpi = KPI_Selection.kpis_by_role
    -- AND KPI_Target.site_kpi = KPI_Selection.site_or_region
    -- -- LEFT JOIN `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` as c
    -- ON c.kpi = KPI_Selection.kpis_by_role
    -- AND c.role = KPI_Selection.role
   
),
prep_non_program_kpis AS (
SELECT 
*
FROM `data-studio-260217.performance_mgt.expanded_role_kpi_selection` KPI_by_role
LEFT JOIN prep_kpi_targets Non_Program_Targets

ON KPI_by_role.role = Non_Program_Targets.select_role
AND KPI_by_role.kpis_by_role = Non_Program_Targets.select_kpi

WHERE KPI_by_role.function NOT IN ('Non-Mature Site Staff', 'Mature Site Staff', 'Mature Regional Staff', 'Non-Mature Regional Staff')
),

prep_regional_kpis AS (
SELECT 
*
FROM `data-studio-260217.performance_mgt.expanded_role_kpi_selection` KPI_by_role
LEFT JOIN prep_kpi_targets Non_Program_Targets

ON KPI_by_role.role = Non_Program_Targets.select_role
AND KPI_by_role.kpis_by_role = Non_Program_Targets.select_kpi
AND KPI_by_role.site_or_region = Non_Program_Targets.region_kpi


WHERE KPI_by_role.function IN ('Mature Regional Staff', 'Non-Mature Regional Staff')
)

SELECT
  *
FROM
  prep_regional_kpis
WHERE target_submitted = true