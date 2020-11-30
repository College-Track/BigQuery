WITH gather_data AS (
SELECT Contact_Id, site_sort, Gender_c, annual_household_income_c, mailing_city, mailing_postal_code, mailing_postal_code, mailing_state, mailing_street
FROM `data-warehouse-289815.salesforce_clean.contact_template`
WHERE college_track_status_c IN ('11A')

)

SELECT *
FROM gather_data