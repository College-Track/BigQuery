#flag duplicate KPI entries with inconsistent targets
/*
CREATE OR REPLACE TABLE `data-studio-260217.performance_mgt.fy22_dupe_kpi_targets`
OPTIONS
    (
    description= "This table flags different targets for KPIs shared amongst same team. Targets should be the same "
    )
AS
*/
WITH gather_all_kpis AS (
SELECT role, kpis_by_role,
CASE 
        WHEN function = "Mature Site Staff" THEN "Mature_Site_Staff" 
        WHEN function = "Non-Mature Site Staff" THEN "Non-Mature_Site_Staff"
        ELSE NULL 
        END AS function
FROM `data-studio-260217.performance_mgt.role_kpi_selection` #clean list of KPIs by Role
ORDER BY function, role
),

gather_unique_function_role AS (
SELECT DISTINCT function function, role, kpis_by_role,
FROM gather_all_kpis
),

kpi_targets_submitted AS (
SELECT
    team_kpi, 
    select_role,
    select_kpi,
    site_kpi,
    submission_id,
CASE
      WHEN enter_the_target_numeric_ IS NOT NULL THEN enter_the_target_numeric_
      WHEN enter_the_target_percent_ iS NOT NULL THEN enter_the_target_percent_
      WHEN what_is_the_type_of_target_ = "Goal is met" THEN 1 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_
      ELSE NULL
    END AS target_fy22,
FROM `data-warehouse-289815.google_sheets.audit_kpi_target_submissions` kpi_targets
WHERE email_kpi <> "test@collegetrack.org"
AND disregard_entry_op_hard_coded IS NULL
),

#Targets submitted based on Role, Site and KPI (shared KPI)
site_targets_by_role AS (
SELECT site_kpi,target_fy22,team_kpi,select_kpi
FROM kpi_targets_submitted 
WHERE target_fy22 IS NOT NULL
    AND site_kpi <> "0"
GROUP BY  target_fy22,team_kpi,select_kpi,site_kpi
),

map_targets_shared_kpis AS (
#identify KPIs that are shared, and pull in the KPI target submitted for roles with same KPs (on same team)
SELECT site_kpi,target_fy22,team_kpI, site_targets_by_role.select_kpi,role 
FROM gather_all_kpis
LEFT JOIN site_targets_by_role ON gather_all_kpis.function = site_targets_by_role.team_kpi 
AND site_targets_by_role.select_kpi = gather_all_kpis.kpis_by_role
group by site_kpi,target_fy22,team_kpi,role ,select_kpi
),

#identify duplicate targets submitted for same KPI
dupe_kpi_target_submissions AS (
SELECT a.*
FROM map_targets_shared_kpis AS a
JOIN 
    (SELECT site_kpi,select_kpi, COUNT(*)
    FROM map_targets_shared_kpis 
    GROUP BY site_kpi,select_kpi
    HAVING COUNT(*) > 1) b
ON a.site_kpi = b.site_kpi
AND a.select_kpi = b.select_kpi
ORDER BY a.site_kpi
)

SELECT dupe.*
FROM dupe_kpi_target_submissions AS dupe
LEFT JOIN map_targets_shared_kpis shared_kpis 
    ON dupe.site_kpi = shared_kpis.site_kpi
    AND dupe.select_kpi = shared_kpis.select_kpi
WHERE dupe.target_fy22 <> shared_kpis.target_fy22
    