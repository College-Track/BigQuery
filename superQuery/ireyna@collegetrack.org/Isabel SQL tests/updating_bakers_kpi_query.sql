 SELECT
    CASE 
        WHEN disregard_entry_op_hard_coded IS NULL THEN 0
        ELSE disregard_entry_op_hard_coded
    END AS disregard_entry_op_hard_coded,
    select_role,
    CASE 
        WHEN site_kpi = "Boyle_Heights" THEN "Boyle Heights"
        WHEN site_kpi = "East_Palo_Alto" THEN "East Palo Alto"
        WHEN site_kpi = "New_Orleans" THEN "New Orleans"
        WHEN site_kpi = "San_Francisco" THEN "San Francisco"
        WHEN site_kpi = "The_Durant_Center" THEN "The Durant Center"
        WHEN site_kpi = "Ward_8" THEN "Ward 8"
        ELSE site_kpi
    END AS site_kpi,
    CASE 
        WHEN region_kpi = "Bay_Area" THEN "Bay Area"
        WHEN region_kpi = "NOR_CAL" THEN "NOR CAL"
        ELSE region_kpi
    END AS region_kpi,
    CASE
        WHEN team_kpi = "Org_Performance" THEN "Org Performance"
        WHEN team_kpi = "Employee_Experience" THEN "Employee Experience"
        WHEN team_kpi = "Talent_Acquisition" THEN "Talent Acquisition"
        WHEN team_kpi = "Talent_Development" THEN "Talent Development"
        WHEN team_kpi = "Strategic_Initiatives" THEN "Strategic Initiatives"
        WHEN team_kpi = "Fund_Raising" THEN "Fund Raising"
        WHEN team_kpi = "Mature_Site_Staff" THEN "Mature Site Staff" 
        WHEN team_kpi = "Non-Mature_Site_Staff" THEN "Non-Mature Site Staff"
        WHEN team_kpi = "Mature_Regional_Staff" THEN "Mature Regional Staff" 
        WHEN team_kpi = "Non-Mature_Regional_Staff" THEN "Non-Mature Regional Staff"
        ELSE team_kpi
    END AS team_kpi,
    CASE
        WHEN select_kpi = 'Student Survey - % of students served by Wellness who "strongly agree" wellness services assisted them in managing their stress, helping them engage in self-care practices and/or enhancing their mental health'
            THEN 'Student Survey - % of students served by Wellness who "agree" or "strongly agree" wellness services assisted them in managing their stress, helping them engage in self-care practices and/or enhancing their mental health'
        WHEN select_kpi = '% of high school seniors who matriculate to Good, Best, or Situational Best Fit colleges'
            THEN '% of students matriculating to Best Fit, Good Fit, or Situational Best Fit colleges'
        WHEN select_kpi = '% of students graduating from college within 6 years'
            THEN '% of college students graduating from college within 6 years' 
        WHEN select_kpi like '% # of business days to close the month%'
            THEN '# of business days to close the month'
        WHEN select_kpi = 'Average score on Development Operations Services Quality Assessment survey, capturing satisfaction of supports and usefulness of tools and training'
            THEN 'Average score on role-specific Development Operations Services Quality Assessment survey, capturing satisfaction of supports and usefulness of tools and training'
        ELSE select_kpi
    END AS select_kpi,
    what_is_the_type_of_target_,
    CASE
      
      WHEN KPI_Target.select_role IS NOT NULL THEN "Submitted"
    --   WHEN site_kpi IN ("Sacramento", "Denver", "Watts") AND select_kpi = '% of students graduating from college within 6 years' THEN "Not Required"
      ELSE "Not Submitted"
    END AS target_submitted,
    CASE
      WHEN enter_the_target_numeric_ IS NOT NULL THEN enter_the_target_numeric_
      WHEN enter_the_target_percent_ iS NOT NULL THEN enter_the_target_percent_
      WHEN what_is_the_type_of_target_ = "Goal is met" THEN 1 --   WHEN enter_the_target_non_numeric_ IS NOT NULL THEN enter_the_target_non_numeric_count
      ELSE NULL
    END AS target_fy22,
  FROM
    `data-warehouse-289815.google_sheets.audit_kpi_target_submissions` KPI_Target
    WHERE email_kpi != 'test@collegetrack.org'
    AND disregard_entry_op_hard_coded <> 1