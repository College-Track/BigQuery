SELECT
  site_short,
  (
    contextual_income - avg(contextual_income) over()
  ) / stddev(contextual_income) over() AS contextual_income,
  (avg_us_citizen - avg(avg_us_citizen) over()) / stddev(avg_us_citizen) over() AS us_citizen,
  -- positive
  (avg_first_gpa - avg(avg_first_gpa) over()) / stddev(avg_first_gpa) over() AS first_gpa,
  --positive
  (
    avg_first_covi_green - avg(avg_first_covi_green) over()
  ) / stddev(avg_first_covi_green) over() AS first_covi_green,
  --positive
  (
    avg_english_primary_language - avg(avg_english_primary_language) over()
  ) / stddev(avg_english_primary_language) over() AS english_primary_language,
  -- positive
  -(avg_first_gen - avg(avg_first_gen) over()) / stddev(avg_first_gen) over() AS first_gen,
  --negative
  (
    avg_househld_income_site - avg(avg_househld_income_site) over()
  ) / stddev(avg_househld_income_site) over() AS househld_income_site,
  --positive
  (
    avg_percent_bachelors_degree - avg(avg_percent_bachelors_degree) over()
  ) / stddev(avg_percent_bachelors_degree) over() AS bachelors_degree,
  --positive
  (
    avg_percent_high_school_diploma - avg(avg_percent_high_school_diploma) over()
  ) / stddev(avg_percent_high_school_diploma) over() AS high_school_diploma,
  --positive
  -(
    avg_percent_households_public_asst_or_food_stamps - avg(
      avg_percent_households_public_asst_or_food_stamps
    ) over()
  ) / stddev(
    avg_percent_households_public_asst_or_food_stamps
  ) over() AS households_public_asst_or_food_stamps,
  --negative
  -(
    avg_percent_housing_units_renter_occupied - avg(avg_percent_housing_units_renter_occupied) over()
  ) / stddev(avg_percent_housing_units_renter_occupied) over() AS housing_units_renter_occupied,
  --negative
  (
    avg_income_per_capita - avg(avg_income_per_capita) over()
  ) / stddev(avg_income_per_capita) over() AS income_per_capita,
  --positive
  (
    avg_median_income - avg(avg_median_income) over()
  ) / stddev(avg_median_income) over() AS median_income,
  --positive
  -(
    avg_percent_not_us_citizen_pop - avg(avg_percent_not_us_citizen_pop) over()
  ) / stddev(avg_percent_not_us_citizen_pop) over() AS percent_not_us_citizen_pop,
  --negative
  -(
    avg_percent_income_spent_on_rent - avg(avg_percent_income_spent_on_rent) over()
  ) / stddev(avg_percent_income_spent_on_rent) over() AS percent_income_spent_on_rent,
  --negative
  -(
    avg_percent_unemployed_pop - avg(avg_percent_unemployed_pop) over()
  ) / stddev(avg_percent_unemployed_pop) over() AS percent_unemployed_pop,
  --negative
  -(
    avg_percent_vacant_housing_units - avg(avg_percent_vacant_housing_units) over()
  ) / stddev(avg_percent_vacant_housing_units) over() AS percent_vacant_housing_units,
  --negative
FROM
  `learning-agendas.index_project.site_metric_averages`