SELECT
  Contact_Id,
  high_school_graduating_class_c,
  site_short,
  College_Track_Status_Name,
  email,
  phone,
  primary_contact_language_c,
  primary_contact_c,
  Gender_c,
  Ethnic_background_c,
  first_generation_fy_20_c,
  birthdate,
  indicator_low_income_c,
  annual_household_income_c,
  Current_school_name,
  dream_statement_filled_out_c
FROM
  `data-warehouse-289815.salesforce_clean.contact_template`
WHERE
  college_track_status_c IN ('18a', '11A', '12A', '13A')
  AND years_since_hs_grad_c <= 0