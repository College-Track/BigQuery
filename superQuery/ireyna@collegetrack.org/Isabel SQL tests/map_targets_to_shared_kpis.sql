#map targets to shared KPIs across teams 
#for sites
#for regional
#for non-program roles

/*
CREATE OR REPLACE TABLE 'data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis'
OPTIONS
    (
    description= "This table maps targets to KPIs shared across roles within Teams/Functions"
    )
AS
*/ 

--SELECT *
--FROM `data-warehouse-289815.google_sheets.team_kpi_target`
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

/*
targets_by_role AS (
SELECT submission_id,target_fy22,kpi_targets_submitted.team_kpi, kpi_targets_submitted.select_role, GAK.kpis_by_role,
    /*CASE WHEN 
        GAK.function = kpi_targets_submitted.team_kpi AND
        GAK.kpis_by_role = kpi_targets_submitted.select_kpi AND 
        submission_id IS NULL
        THEN target_fy22
        ELSE 0
    END AS mapped_targets --omit this line too
FROM gather_all_kpis GAK
LEFT JOIN kpi_targets_submitted 
ON GAK.kpis_by_role = kpi_targets_submitted.select_kpi
--WHERE GAFR.select_role != GAK.role
GROUP BY team_kpi,select_role,kpis_by_role,function,select_kpi,submission_id,target_fy22
)
*/

prep_site_targets_by_role AS (
SELECT submission_id,target_fy22,kpi_targets_submitted.team_kpi, kpi_targets_submitted.select_role, GAK.kpis_by_role,site_kpi
    /*CASE WHEN 
        GAK.function = kpi_targets_submitted.team_kpi AND
        GAK.kpis_by_role = kpi_targets_submitted.select_kpi AND 
        submission_id IS NULL
        THEN target_fy22
        ELSE 0
    END AS mapped_targets*/
FROM gather_all_kpis GAK
LEFT JOIN kpi_targets_submitted 
ON GAK.kpis_by_role = kpi_targets_submitted.select_kpi
WHERE site_kpi <> "0"
GROUP BY team_kpi,select_role,kpis_by_role,function,select_kpi,submission_id,target_fy22,site_kpi
),

site_targets_by_role AS (
SELECT site_kpi,target_fy22,team_kpi,kpis_by_role
FROM prep_site_targets_by_role
WHERE target_fy22 IS NOT NULL
GROUP BY  target_fy22,team_kpi,kpis_by_role,site_kpi
)

#identify KPIs that are shared, and pull in the KPI target submitted 
SELECT site_kpi,target_fy22,team_kpi,function, site_targets_by_role.kpis_by_role,role 
FROM gather_all_kpis
LEFT JOIN site_targets_by_role ON gather_all_kpis.function = site_targets_by_role.team_kpi 
AND site_targets_by_role.kpis_by_role = gather_all_kpis.kpis_by_role
    --AND gather_all_kpis.kpis_by_role = site_targets_by_role.KPIS_BY_ROLE
--  WHERE gather_all_kpis.function = site_targets_by_role.team_kpi
--  AND gather_all_kpis.Role = site_targets_by_role.select_role
--  AND gather_all_kpis.kpis_by_role = site_targets_by_role.select_kpi
group by site_kpi,target_fy22,team_kpi,function,role ,kpis_by_role