CREATE OR REPLACE TABLE `data-studio-260217.performance_mgt.audit_kpi_weird_targets`
OPTIONS
    (
    description= "This table pulls in targets that do not make sense for a numeric, percent or T/F target"
    )
AS 
 
 WITH 
 --Next 3 queries: Flag entries for % targets over 100%
 
 weird_percent_kpis_sites AS (
 SELECT 
    site_region_team,
    Role,
    kpis_by_role,
    what_is_the_type_of_target_,
    target_fy22
 FROM `data-warehouse-289815.google_sheets.team_kpi_target` AS raw_submitted_kpis
 LEFT JOIN `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis` AS shared_kpis
    ON shared_kpis.site_region_team = raw_submitted_kpis.site_kpi
 WHERE raw_submitted_kpis.enter_the_target_percent_  > 1
    AND what_is_the_type_of_target_ = 'Percent'
),

weird_percent_kpis_regions AS (    
SELECT 
    site_region_team,
    Role,
    kpis_by_role,
    what_is_the_type_of_target_,
    target_fy22
 FROM `data-warehouse-289815.google_sheets.team_kpi_target` AS raw_submitted_kpis
 LEFT JOIN `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis` AS shared_kpis
    ON shared_kpis.site_region_team = raw_submitted_kpis.region_kpi
 WHERE raw_submitted_kpis.enter_the_target_percent_  > 1
    AND what_is_the_type_of_target_ = 'Percent'
),

weird_percent_kpis_national AS (
SELECT 
    site_region_team,
    Role,
    kpis_by_role,
    what_is_the_type_of_target_,
    target_fy22
 FROM `data-warehouse-289815.google_sheets.team_kpi_target` AS raw_submitted_kpis
 LEFT JOIN `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis` AS shared_kpis
    ON shared_kpis.site_region_team = raw_submitted_kpis.team_kpi
 WHERE raw_submitted_kpis.enter_the_target_percent_  > 1
    AND region_kpi = "0"
    AND site_kpi = "0"
    AND what_is_the_type_of_target_ = 'Percent'
),

--Flag Numeric targets that are weird
weird_numeric_targets_national AS (
SELECT      
    site_region_team,
    Role,
    kpis_by_role,
    what_is_the_type_of_target_,
    target_fy22
 FROM `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis` AS shared_kpis
 LEFT JOIN `data-warehouse-289815.google_sheets.team_kpi_target` AS raw_submitted_kpis
    ON shared_kpis.site_region_team = raw_submitted_kpis.team_kpi
    AND Shared_kpis.kpis_by_role = raw_submitted_kpis.select_kpi
 WHERE target_fy22  > 100 
 OR target_fy22  < 1
    AND region_kpi = "0"
    AND site_kpi = "0"
    AND what_is_the_type_of_target_ = 'Numeric (but not percent)'
    AND raw_submitted_kpis.email_kpi <> "test@collegetrack.org"
GROUP BY 
    site_region_team,
    Role,
    kpis_by_role,
    what_is_the_type_of_target_,
    target_fy22
),

weird_numeric_targets_region AS (
SELECT      
    site_region_team,
    Role,
    kpis_by_role,
    what_is_the_type_of_target_,
    target_fy22
FROM `data-warehouse-289815.google_sheets.team_kpi_target` AS raw_submitted_kpis
 left join `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis` AS shared_kpis
 
    ON shared_kpis.site_region_team = raw_submitted_kpis.region_kpi
    AND Shared_kpis.kpis_by_role = raw_submitted_kpis.select_kpi
 WHERE target_fy22  > 100 
 OR target_fy22  < 1
    AND region_kpi IS NOT NULL
    AND site_kpi = "0"
    AND what_is_the_type_of_target_ = 'Numeric (but not percent)'
    AND raw_submitted_kpis.email_kpi <> "test@collegetrack.org"
),

weird_numeric_targets_site AS (
SELECT      
    site_region_team,
    Role,
    kpis_by_role,
    what_is_the_type_of_target_,
    target_fy22
FROM `data-warehouse-289815.google_sheets.team_kpi_target` AS raw_submitted_kpis
 left join `data-studio-260217.performance_mgt.fy22_targets_to_shared_kpis` AS shared_kpis
 
    ON shared_kpis.site_region_team = raw_submitted_kpis.region_kpi
    AND Shared_kpis.kpis_by_role = raw_submitted_kpis.select_kpi
 WHERE target_fy22  > 100 
 OR target_fy22  < 1
    AND region_kpi IS NULL
    AND site_kpi IS NOT NULL
    AND what_is_the_type_of_target_ = 'Numeric (but not percent)'
    AND raw_submitted_kpis.email_kpi <> "test@collegetrack.org"
)

SELECT *
FROM weird_numeric_targets_national

UNION ALL

SELECT *
FROM weird_numeric_targets_region

UNION ALL 

SELECT *
FROM weird_numeric_targets_site

UNION ALL 

SELECT *
FROM weird_percent_kpis_sites

UNION ALL

SELECT *
FROM weird_percent_kpis_regions

UNION ALL

SELECT *
FROM weird_percent_kpis_national