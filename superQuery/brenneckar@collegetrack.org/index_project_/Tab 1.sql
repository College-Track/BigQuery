WITH gather_data AS (
  SELECT
    Contact_Id,
    site_sort,
    Gender_c,
    annual_household_income_c,
    mailing_city,
    mailing_postal_code,
    mailing_postal_code,
    mailing_state,
    mailing_street,
    primary_contact_language_c,
    first_generation_fy_20_c,
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