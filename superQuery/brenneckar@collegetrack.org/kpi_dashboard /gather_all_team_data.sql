WITH join_prep AS (
  SELECT
    *
  FROM
    `data-studio-260217.kpi_dashboard.join_prep`
),
join_team_kpis AS (
  SELECT
    JP.*,
    AA.*
  EXCEPT(site_short),
  SD.* EXCEPT(site_short),
  CC_HS.* EXCEPT(site_short)
  FROM
    join_prep JP
    LEFT JOIN `data-studio-260217.kpi_dashboard.academic_affairs` AA ON AA.site_short = JP.site_short
    LEFT JOIN `data-studio-260217.kpi_dashboard.site_directors` SD ON SD.site_short = JP.site_short
    LEFT JOIN `data-studio-260217.kpi_dashboard.cc_hs` CC_HS ON CC_HS.site_short = JP.site_short
)
SELECT
  *
FROM
  join_team_kpis