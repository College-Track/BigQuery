WITH merge_data AS (SELECT C.Contact_Id, C.census_track_id, ACS.geo_id, ACS.total_pop
FROM `learning-agendas.index_project.student_with_census` C
LEFT JOIN  `bigquery-public-data.census_bureau_acs.censustract_2018_5yr` ACS on ACS.geo_id = C.census_track_id
)

SELECT *
FROM merged_data
WHERE total_pop IS NULL