WITH join_prep AS (
SELECT *
FROM `data-studio-260217.kpi_dashboard.join_prep`
),

academic_affairs AS (
SELECT JP.*,
AA.above_325_gpa
FROM join_prep JP
LEFT JOIN `data-studio-260217.kpi_dashboard.academic_affairs` AA ON AA.site_short = JP.site_short
)

SELECT *
FROM academic_affairs