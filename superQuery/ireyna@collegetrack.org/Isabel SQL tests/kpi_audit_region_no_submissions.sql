WITH 
#update function/site names/regional names to join
clean_shared_kpi_targets_table AS (
    SELECT * EXCEPT (mature_non_mature, site_region_team),
    CASE 
        WHEN site_region_team  ="Boyle_Heights" THEN "Boyle Heights"
        WHEN site_region_team = "East_Palo_Alto" THEN "East Palo Alto"
        WHEN site_region_team = "New_Orleans" THEN "New Orleans"
        WHEN site_region_team = "San_Francisco" THEN "San Francisco"
        WHEN site_region_team = "The_Durant_Center" THEN "The Durant Center"
        WHEN site_region_team = "Ward_8" THEN "Ward 8"
        WHEN site_region_team = "Bay_Area" THEN "Bay Area"
        WHEN site_region_team = "Org_Performance" THEN "Org Performance"
        WHEN site_region_team = "Employee_Experience" THEN "Employee Experience"
        WHEN site_region_team = "Talent_Acquisition" THEN "Talent Acquisition"
        WHEN site_region_team = "Talent_Development" THEN "Talent Development"
        WHEN site_region_team = "Strategic_Initiatives" THEN "Strategic Initiatives"
        ELSE site_region_team
    END AS site_region_team,
    CASE
        WHEN mature_non_mature = "Mature_Site_Staff" THEN "Mature Site Staff" 
        WHEN mature_non_mature = "Non-Mature_Site_Staff" THEN "Non-Mature Site Staff"
        WHEN mature_non_mature = "Mature_Regional_Staff" THEN "Mature Regional Staff" 
        WHEN mature_non_mature = "Non-Mature_Regional_Staff" THEN "Non-Mature Regional Staff"
        ELSE NULL
    END AS mature_non_mature
FROM `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis` 
),
prep_submitted_region_targets AS (
SELECT 
    site_or_region,
    function, --e.g. mature site staff
    shared_kpi_targets.mature_non_mature,
    kpis_submitted.role,
    kpis_submitted.kpis_by_role,
    shared_kpi_targets.target_fy22,
    shared_kpi_targets.site_region_team, --e.g. Finance, Watts
    CASE 
        WHEN shared_kpi_targets.target_fy22 IS NOT NULL AND target_submitted = "Not Submitted" 
        THEN "Submitted"
        ELSE target_submitted
    END AS target_submitted

 FROM `data-studio-260217.performance_mgt.fy22_team_kpis` kpis_submitted
 LEFT JOIN clean_shared_kpi_targets_table AS shared_kpi_targets
    ON kpis_submitted.function = shared_kpi_targets.mature_non_mature
    AND kpis_submitted.site_or_region = shared_kpi_targets.site_region_team
    AND kpis_submitted.kpis_by_role = shared_kpi_targets.kpis_by_role

WHERE region_function = 1
GROUP BY 
    site_or_region,
    function, --e.g. mature site staff
    shared_kpi_targets.mature_non_mature,
    kpis_submitted.role,
    kpis_submitted.kpis_by_role,
    shared_kpi_targets.target_fy22,
    kpis_submitted.target_submitted,
    shared_kpi_targets.site_region_team --e.g. Finance, Watts
)

SELECT *
FROM prep_submitted_region_targets
WHERE target_submitted = "Not Submitted"