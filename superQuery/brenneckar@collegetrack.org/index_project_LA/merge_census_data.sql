WITH gather_census_data AS (
  SELECT
    ACS.geo_id,
    ACS.total_pop,
    ACS.total_pop - ACS.children AS total_adults,
    ACS.pop_25_years_over,
    ACS.bachelors_degree,
    ACS.different_house_year_ago_different_city,
    ACS.different_house_year_ago_same_city,
    ACS.high_school_diploma,
    ACS.high_school_including_ged,
    ACS.households,
    ACS.households_public_asst_or_food_stamps,
    ACS.housing_units_renter_occupied,
    ACS.income_per_capita,
    ACS.median_income,
    ACS.not_in_labor_force,
    ACS.not_us_citizen_pop,
    ACS.occupied_housing_units,
    ACS.percent_income_spent_on_rent,
    ACS.pop_in_labor_force,
    ACS.speak_only_english_at_home,
    ACS.unemployed_pop,
    ACS.vacant_housing_units
  FROM `bigquery-public-data.census_bureau_acs.censustract_2018_5yr` ACS 
), calc_census_metrics AS (
SELECT
  geo_id, bachelors_degree / 10 AS percent_bachelors_degree
  
FROM
  gather_census_data
  )
  
SELECT
C.*, CENSUS.*
FROM
`learning-agendas.index_project.student_with_census` C
LEFT JOIN calc_census_metrics CENSUS ON C.census_track_id = CENSUS.geo_id