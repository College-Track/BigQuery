SELECT
CASE
    WHEN kpis_by_role = '% of entering 9th grade students who are low-income AND first-gen'
    THEN program = 1
    ELSE FALSE
END AS program

FROM `data-studio-260217.performance_mgt.fy22_team_kpis` 