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
  FROM
    `bigquery-public-data.census_bureau_acs.censustract_2018_5yr` ACS
),
calc_census_metrics AS (
  SELECT
    C.*,
    bachelors_degree / pop_25_years_over AS percent_bachelors_degree,
    different_house_year_ago_different_city / pop_25_years_over AS percent_different_house_year_ago_different_city,
    different_house_year_ago_same_city / pop_25_years_over AS percent_different_house_year_ago_same_city,
    high_school_diploma / pop_25_years_over AS percent_high_school_diploma,
    high_school_including_ged / pop_25_years_over AS percent_high_school_including_ged,
    households_public_asst_or_food_stamps / households AS percent_households_public_asst_or_food_stamps,
    housing_units_renter_occupied / households AS percent_housing_units_renter_occupied,
    income_per_capita,
    median_income,
    not_in_labor_force / pop_25_years_over AS percent_not_in_labor_force,
    not_us_citizen_pop / pop_25_years_over AS percent_not_us_citizen_pop,
    --   occupied_housing_units / households AS percent_occupied_housing_units,
    percent_income_spent_on_rent / 100 AS percent_income_spent_on_rent,
    -- pop_in_labor_force / pop_25_years_over AS percent_pop_in_labor_force,
    --   speak_only_english_at_home / pop_25_years_over AS percent_speak_only_english_at_home,
    unemployed_pop / pop_25_years_over AS percent_unemployed_pop,
    vacant_housing_units / households AS percent_vacant_housing_units
  FROM
    `learning-agendas.index_project.student_with_census` C
    LEFT JOIN gather_census_data CENSUS ON C.census_track_id = CENSUS.geo_id
), calc_averages AS (
SELECT
  site_short,
  AVG(CAST(is_a_us_citizen AS INT64)) AS avg_us_citizen,
  AVG(CAST(english_primary_language AS INT64)) AS avg_english_primary_language,
  AVG(CAST(first_gen AS INT64)) AS avg_first_gen,
  AVG(annual_household_income_c) AS avg_househld_income_site,
  AVG(percent_bachelors_degree) AS avg_percent_bachelors_degree,
  AVG(percent_high_school_diploma) AS avg_percent_high_school_diploma,
  AVG(percent_households_public_asst_or_food_stamps) AS avg_percent_households_public_asst_or_food_stamps,
  AVG(percent_housing_units_renter_occupied) AS avg_percent_housing_units_renter_occupied,
  AVG(income_per_capita) AS avg_income_per_capita,
  AVG(median_income) AS avg_median_income,
  --   AVG(percent_not_in_labor_force) AS avg_percent_not_in_labor_force,
  AVG(percent_not_us_citizen_pop) AS avg_percent_not_us_citizen_pop,
  AVG(percent_income_spent_on_rent) AS avg_percent_income_spent_on_rent,
  AVG(percent_unemployed_pop) AS avg_percent_unemployed_pop,
  AVG(percent_vacant_housing_units) AS avg_percent_vacant_housing_units
FROM
  calc_census_metrics
GROUP BY
  site_short
  )
  
SELECT 
site_short, 
(avg_us_citizen - avg(avg_us_citizen) over()) / stddev(avg_us_citizen) over() as z_score_avg_us_citizen,
FROM calc_averages