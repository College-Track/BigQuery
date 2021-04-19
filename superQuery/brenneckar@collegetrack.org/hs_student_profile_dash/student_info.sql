WITH gather_contact_data AS (
  SELECT
    C.Contact_Id,
    C.full_name_c,
    C.contact_url,
    C.high_school_graduating_class_c,
    --   SPLIT(composite_readiness_most_recent_c, '.')[OFFSET(1)] as composite_readiness_most_recent_c,
    C.composite_readiness_most_recent_c,
    C.site_short,
    C.College_Track_Status_Name,
    C.email,
    C.phone,
    C.primary_contact_language_c,
    PC.full_name_c AS primary_contact_name,
    -- EC.full_name_c AS emergency_contact_name,
    C.Gender_c,
    C.Ethnic_background_c,
    C.first_generation_fy_20_c,
    C.birthdate,
    C.indicator_low_income_c,
    C.annual_household_income_c,
    C.Current_school_name,
    C.dream_statement_filled_out_c,
    C.of_high_school_terms_on_intervention_c,
    C.indicator_high_risk_for_dismissal_c,
    C.student_has_iep_c,
    C.Current_HS_CT_Coach_c,
    C.community_service_form_link_c,
    C.summer_experience_form_link_c,
    C.current_academic_semester_c,
    C.summer_experiences_previous_summer_c,
    CONCAT(
      "https://ctgraduates.lightning.force.com/",
      C.current_academic_semester_c
    ) AS current_at_url,
    C.co_vitality_scorecard_color_most_recent_c,
    C.starting_semester_c,
    C.student_s_start_academic_year_c,
    C.total_bank_book_balance_contact_c,
    C.college_applications_all_fit_types_c,
    C.community_service_hours_c,
    C.student_dashboard_preview,
    C.current_at_url


    
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template` C
    LEFT JOIN `data-warehouse-289815.salesforce.contact` PC ON PC.Id = C.primary_contact_c
    -- LEFT JOIN `data-warehouse-289815.salesforce.npe_4_relationship_c` R ON R.npe_4_contact_c = C.Contact_Id
    -- LEFT JOIN `data-warehouse-289815.salesforce.contact` EC ON EC.Id = R.npe_4_related_contact_c
  WHERE
    C.college_track_status_c IN ('18a', '11A', '12A', '13A')
    AND C.years_since_hs_grad_c <= 0
    -- AND R.emergency_contact_c = true
),
count_college_aspirations AS (
  SELECT
    student_c,
    Count(Id) as num_college_aspirations
  FROM
    `data-warehouse-289815.salesforce.college_aspiration_c`
  WHERE
    is_deleted = false
  GROUP BY
    student_c
),
count_scholarship_applications AS (
  SELECT
    student_c,
    COUNT(Id) as num_scholarship_applications
  FROM
    `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
  WHERE
    is_deleted = false
    AND scholarship_application_record_type_name != 'Bank Book'
  GROUP BY
    student_c
),
join_data AS(
  SELECT
    GCD.*,
    CCA.num_college_aspirations,
    CSA.num_scholarship_applications
  FROM
    gather_contact_data GCD
    LEFT JOIN count_college_aspirations CCA ON CCA.student_c = GCD.Contact_Id
    LEFT JOIN count_scholarship_applications CSA ON CSA.student_c = GCD.Contact_Id
)
SELECT
  *
FROM
  join_data