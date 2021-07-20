#map targets to shared KPIs across teams (Sites only so far)
#for sites
#for regional
#for non-program roles

/*
CREATE OR REPLACE TABLE `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis`
OPTIONS
    (
    description= "This table maps submitted targets to KPIs shared across roles within Teams/Functions"
    )
AS
*/

WITH gather_all_kpis AS (
SELECT role, kpis_by_role,
CASE 
        WHEN function = "Mature Site Staff" THEN "Mature_Site_Staff" 
        WHEN function = "Non-Mature Site Staff" THEN "Non-Mature_Site_Staff"
        WHEN function = "Mature Regional Staff" THEN "Mature_Regional_Staff" 
        WHEN function = "Non-Mature Regional Staff" THEN "Non-Mature_Regional_Staff"
        WHEN function = "Org Performance" THEN "Org_Performance"
        WHEN function = "Employee Experience" THEN "Employee_Experience"
        WHEN function = "Talent Acquisition" THEN "Talent_Acquisition"
        WHEN function = "Talent Development" THEN "Talent_Development"
        WHEN function = "Strategic Initiatives" THEN "Strategic_Initiatives"
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
    region_kpi,
    email_kpi,
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
)

--prep_national_targets_by_role AS (
SELECT target_fy22,kpi_targets_submitted.team_kpi, kpi_targets_submitted.select_role, all_kpis.kpis_by_role,email_kpi,region_kpi
FROM gather_all_kpis all_kpis
FULL JOIN kpi_targets_submitted 
ON all_kpis.kpis_by_role = kpi_targets_submitted.select_kpi
WHERE site_kpi = "0"
    AND region_kpi ="0"
GROUP BY team_kpi,select_role,kpis_by_role,select_kpi,target_fy22,email_kpi,region_kpi