WITH join_prep AS (
  SELECT
    *
  FROM
    `data-studio-260217.kpi_dashboard_dev.join_prep`
),
join_team_kpis AS (
  SELECT
    JP.*,
    -- AA.* EXCEPT(site_short),
    SD.* EXCEPT(site_short, Ethnic_Background_c, Gender_c)
    -- SL.* EXCEPT(site_short),
    -- CC_HS.* EXCEPT(site_short),
    -- CC_PS.* EXCEPT(site_short),
    -- OM.* EXCEPT(site_short),
    -- RED.* EXCEPT(site_short),
    -- PRO_OPS.* EXCEPT(site_short),
    -- OM_ATTEND.* EXCEPT(site_short),
    -- WLLNSS.* EXCEPT(site_short),
    -- FP.* EXCEPT(site_short)
  FROM
    join_prep JP
    -- LEFT JOIN `data-studio-260217.kpi_dashboard.academic_affairs` AA ON AA.site_short = JP.site_short
    LEFT JOIN `data-studio-260217.kpi_dashboard_dev.site_directors` SD ON SD.site_short = JP.site_short AND SD.Gender_c = JP.Gender_c AND SD.Ethnic_Background_c = JP.Ethnic_Background_c
    -- LEFT JOIN `data-studio-260217.kpi_dashboard.cc_hs` CC_HS ON CC_HS.site_short = JP.site_short
    -- LEFT JOIN `data-studio-260217.kpi_dashboard.cc_ps` CC_PS ON CC_PS.site_short = JP.site_short
    -- LEFT JOIN `data-studio-260217.kpi_dashboard.student_life` SL ON SL.site_short = JP.site_short
    -- LEFT JOIN `data-studio-260217.kpi_dashboard.om` OM ON OM.site_short = JP.site_short
    -- LEFT JOIN `data-studio-260217.kpi_dashboard.red`RED ON RED.site_short = JP.site_short
    -- LEFT JOIN `data-studio-260217.kpi_dashboard.program_ops` PRO_OPS ON PRO_OPS.site_short = JP.site_short
    -- LEFT JOIN `data-studio-260217.kpi_dashboard.om_incomplete_attendance` OM_ATTEND ON OM_ATTEND.site_short = JP.site_short
    -- LEFT JOIN `data-studio-260217.kpi_dashboard.wellness` WLLNSS ON WLLNSS.site_short = JP.site_short
    -- LEFT JOIN `data-studio-260217.kpi_dashboard.fp` FP ON FP.site_short = JP.site_short

),
gather_capacity_metrics  AS (
  SELECT
    C.site_short,
    COUNT(Contact_Id) AS hs_capacity_numerator,
    MAX(Account.college_track_high_school_capacity_v_2_c) AS hs_cohort_capacity,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template` C
    LEFT JOIN `data-warehouse-289815.salesforce.account` Account ON Account.Id = C.site_c
    WHERE college_track_status_c = "11A"
  GROUP BY
    site_short
)

SELECT
  join_team_kpis.*,
  GCM.hs_capacity_numerator,
  GCM.hs_cohort_capacity
FROM
  join_team_kpis
  LEFT JOIN gather_capacity_metrics GCM ON GCM.site_short = join_team_kpis.site_short