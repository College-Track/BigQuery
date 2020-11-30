WITH gather_data AS (
  SELECT
    Contact_Id,
    site_short,
    Gender_c,
    annual_household_income_c,
    mailing_city,
    mailing_postal_code,
    mailing_postal_code,
    mailing_state,
    mailing_street,
    CASE
      WHEN primary_contact_language_c LIKE '%English%' THEN true
      ELSE false
    END AS english_primary_language,
    CASE
      WHEN first_generation_fy_20_c = 'Yes' THEN true
      ELSE false
    END AS first_gen,
    CASE
      WHEN citizen_c_c = 'US Citizen' THEN true
      ELSE false
    END AS is_a_us_citizen
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template`
  WHERE
    college_track_status_c IN ('11A')
)
SELECT
  *
FROM
  gather_data