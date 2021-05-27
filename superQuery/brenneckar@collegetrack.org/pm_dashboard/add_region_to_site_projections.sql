WITH gather_projection_data AS (
SELECT *,
CASE WHEN site_short IN ('Aurora', 'Denver') THEN "CO"
END AS region_abrev

FROM `data-studio-260217.performance_mgt.fy22_projections` P

)

SELECT *
FROM gather_projection_data
