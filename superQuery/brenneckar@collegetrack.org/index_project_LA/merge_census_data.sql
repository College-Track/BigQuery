WITH merge_data AS (
  SELECT
    C.*,
    
    -- ACS.households,
    ACS.total_pop,
    ACS.children,
    ACS.pop_25_years_over,
    ACS.total_pop - ACS.children AS adults
    -- ACS.bachelors_degree,
    -- ACS.not_us_citizen_pop,
    -- ACS.median_income,
    -- ACS.income_per_capita,
    -- ACS.housing_units_renter_occupied,
    -- ACS.percent_income_spent_on_rent,
    -- ACS.different_house_year_ago_different_city,
    -- ACS.different_house_year_ago_same_city,
    -- ACS.speak_only_english_at_home,
    -- ACS.vacant_housing_units,
    -- ACS.households_public_asst_or_food_stamps
  FROM
    `learning-agendas.index_project.student_with_census` C
    LEFT JOIN `bigquery-public-data.census_bureau_acs.censustract_2018_5yr` ACS on ACS.geo_id = C.census_track_id
)
SELECT
  *
FROM
  merge_data