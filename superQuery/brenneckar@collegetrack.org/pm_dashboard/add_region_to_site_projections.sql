WITH gather_projection_data AS (SELECT DISTINCT P.*,
R.region_abrev
FROM `data-studio-260217.performance_mgt.fy22_projections` P
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` R ON R.site_short = P.site_short
)

SELECT site_short, region_abrev, COUNT(*)
FROM gather_projection_data
WHERE (site_short = 'Oakland' AND region_abrev != "DC")
GROUP BY site_short, region_abrev