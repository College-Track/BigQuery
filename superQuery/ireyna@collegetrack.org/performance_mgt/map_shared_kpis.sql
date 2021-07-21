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
        ELSE function 
        END AS function
FROM `data-studio-260217.performance_mgt.role_kpi_selection` #clean list of KPIs by Role
ORDER BY function, role
),

gather_unique_function_role AS (
SELECT DISTINCT function function, role, kpis_by_role,
FROM gather_all_kpis
),

prep_kpi_targets_submitted AS (
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

--kpi_targets_submitted AS (
    SELECT *,
    CASE
        WHEN target_fy22 IS NOT NULL THEN "Submitted"
        WHEN site_kpi IN ("Sacramento", "Denver", "Watts") AND select_kpi = '% of students graduating from college within 6 years' THEN "Not Required"
        WHEN select_kpi = "% of students engaged in career exploration, readiness events or internships" THEN "Not Required"
        WHEN select_kpi = "% of students growing toward average or above social-emotional strengths" THEN "Not Required"
        ELSE "Not Submitted"
  END AS target_submitted
    FROM prep_kpi_targets_submitted