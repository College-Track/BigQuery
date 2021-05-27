WITH gather_projection_data AS (SELECT distinct P.*,
C.region_abrev
FROM `data-studio-260217.performance_mgt.fy22_projections` P
LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_template` C ON C.site_short = P.site_short
),
gather_regions AS (
SELECT distinct region_abrev, site_short
FROM `data-warehouse-289815.salesforce_clean.contact_template`
)

-- SELECT SUM(student_count)
-- FROM gather_data


SELECT P.*,
R.region_abrev
FROM gather_projection_data P
LEFT JOIN gather_regions R ON R.site_short = P.site_short