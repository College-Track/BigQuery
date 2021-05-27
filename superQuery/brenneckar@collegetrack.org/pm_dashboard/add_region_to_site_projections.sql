WITH gather_projection_data AS (
SELECT *,
CASE WHEN site_short IN ('Aurora', 'Denver') THEN "CO"
WHEN site_short IN ('Watts', "Boyle Heights", 'Crenshaw') THEN "LA"
WHEN site_short IN ('New Orleans') THEN "NOLA"
WHEN site_short IN ("The Durant Center", "Ward 8") THEN "DC"
WHEN site_short IN ('San Francisco', "Oakland", "East Palo Alto", 'Sacramento') THEN "NOR CAL"
ELSE NULL
END AS region_abrev

FROM `data-studio-260217.performance_mgt.fy22_projections` P

)

SELECT *
FROM gather_projection_data
