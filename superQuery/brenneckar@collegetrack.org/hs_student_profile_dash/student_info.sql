WITH gather_contact_data AS (
SELECT
  Contact_Id,
  full_name_c,
  contact_url,
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
  dream_statement_filled_out_c,
  of_high_school_terms_on_intervention_c,
  indicator_high_risk_for_dismissal_c,
  student_has_iep_c,
  Current_HS_CT_Coach_c,
  community_service_form_link_c,
  summer_experience_form_link_c,
  current_academic_semester_c,
  CONCAT(
    "https://ctgraduates.lightning.force.com/",
    current_academic_semester_c
  ) AS current_at_url,
  co_vitality_scorecard_color_most_recent_c,
  starting_semester_c,
  student_s_start_academic_year_c,
  total_bank_book_balance_contact_c,
  college_applications_all_fit_types_c,
  community_service_hours_c
  
FROM
  `data-warehouse-289815.salesforce_clean.contact_template`
WHERE
  college_track_status_c IN ('18a', '11A', '12A', '13A')
  AND years_since_hs_grad_c <= 0
 )
 
 SELECT 
 *
 FROM gather_contact_data