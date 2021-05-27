WITH gather_projection_data AS (SELECT distinct P.*,
FROM `data-studio-260217.performance_mgt.fy22_projections` P
),
gather_regions AS (
SELECT distinct region_abrev, site_short
FROM `data-warehouse-289815.salesforce_clean.contact_template`
), join_data AS (

SELECT P.*,
R.region_abrev
FROM gather_projection_data P
LEFT JOIN gather_regions R ON R.site_short = P.site_short
ORDER BY P.site_short, high_school_class
)

SELECT *
FROM join_data
where site_short IN ('Oakland')