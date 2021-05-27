

WITH gather_kpi_submissions AS (
  SELECT
    KPI_Selection.*,
    Region,
    CASE
      WHEN KPI_Target.select_role IS NOT NULL THEN true
      ELSE false
    END AS target_submitted,
    CASE
      WHEN enter_the_target_numeric_ IS NOT NULL THEN enter_the_target_numeric_
      WHEN enter_the_target_percent_ iS NOT NULL THEN enter_the_target_percent_
    --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_
      ELSE NULL
    END AS target_fy22,
    --CASE
    --  WHEN site_kpi = 0 THEN NULL
    --  ELSE site_kpi
    --END AS site,
    CASE
      WHEN KPI_Selection.function IN ('Talent Acquisition','Talent Development','Employee Experience')
      THEN 1
      ELSE 0
    END AS hr_people,
    CASE 
      WHEN KPI_Selection.function IN ('Finance','Strategic Initiatives','Org Performance','IT','Marketing','Program Development','Operations')
      THEN 1
      ELSE 0
    END AS national,
    CASE
      WHEN KPI_Selection.function IN ('Partnerships','Fund Raising')
      THEN 1
      ELSE 0
    END AS development,
    CASE
      WHEN KPI_Selection.function IN ('Mature Site Staff','Non-Mature Site Staff')
      THEN 1
      ELSE 0
    END AS program,
    CASE
      WHEN site_kpi NOT IN ('East Palo Alto','Oakland','San Francisco','Sacramento','Boyle Heights','Watts','Crenshaw','Aurora','Denver','The Durant Center','Ward 8')
      THEN 'National'
      ELSE site_kpi
    END AS Site
  FROM
    `data-studio-260217.performance_mgt.role_kpi_selection` KPI_Selection --List of KPIs by Team/Role
    LEFT JOIN `data-warehouse-289815.google_sheets.team_kpi_target` KPI_Target --ON KPI_Target.team_kpi = REPLACE(KPI_Selection.function, ' ', '_')  #FormAssembly 
    ON KPI_Target.select_role = KPI_Selection.role
    AND KPI_Target.select_kpi = KPI_Selection.KPI
    LEFT JOIN `data-warehouse-289815.performance_mgt.fy22_roles_to_kpi` as c
    ON c.kpi = KPI_Selection.KPI
    AND c.role = KPI_Selection.role
   
)
SELECT
  *
FROM
  gather_kpi_submissions