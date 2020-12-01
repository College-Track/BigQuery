WITH merge_data AS (
  SELECT
    C.*,
    ACS.bachelors_degree,
    ACS.total_pop,
    ACS.not_us_citizen_pop,
    ACS.median_income,
    ACS.income_per_capita,
    ACS.housing_units_renter_occupied
    
  FROM
    `learning-agendas.index_project.student_with_census` C
    LEFT JOIN `bigquery-public-data.census_bureau_acs.censustract_2018_5yr` ACS on ACS.geo_id = C.census_track_id
)
SELECT
  *
FROM
  merge_data
  LIMIT 10