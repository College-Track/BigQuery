WITH gather_contact_data AS (
  SELECT
    C.Contact_Id,
    C.full_name_c,
    C.contact_url,
    C.high_school_graduating_class_c,
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
    -- C.annual_household_income_c,
    C.Current_school_name,
    C.community_service_hours_c,
    C.current_at_url,
    C.FA_Req_FAFSA_c,
    C.current_enrollment_status_c,
    C.Current_School_Type_c_degree,
    C.current_cc_advisor_2_c,
    C.current_major_c,
    C.current_major_specific_c,
    C.credit_accumulation_pace_c,
    C.total_bb_earnings_as_of_hs_grad_contact_c,
    C.bb_disbursements_total_c,
    C.total_bank_book_balance_contact_c,
    C.most_recent_outreach,
    C.most_recent_reciprocal,
    C.PS_Internships_c,
    C.Credits_Accumulated_Most_Recent_c / 100 AS Credits_Accumulated_Most_Recent_c,
    -- ADG.GAS_Name AS anticipated_date_of_graduation_4_year_c
    

  FROM
    `data-warehouse-289815.salesforce_clean.contact_template` C
    LEFT JOIN `data-warehouse-289815.salesforce.contact` PC ON PC.Id = C.primary_contact_c -- LEFT JOIN `data-warehouse-289815.salesforce.npe_4_relationship_c` R ON R.npe_4_contact_c = C.Contact_Id
    -- LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` ADG ON  C.anticipated_date_of_graduation_4_year_c = ADG.global_academic_semester_c
    -- LEFT JOIN `data-warehouse-289815.salesforce.contact` EC ON EC.Id = R.npe_4_related_contact_c
  WHERE
    C.college_track_status_c IN ('15A', '16A')
    AND C.indicator_completed_ct_hs_program_c = true -- AND R.emergency_contact_c = true
),
count_scholarship_applications AS (
  SELECT
    student_c,
    COUNT(Id) as num_scholarship_applications,
  FROM
    `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
  WHERE
    is_deleted = false
    AND scholarship_application_record_type_name != 'Bank Book'
  GROUP BY
    student_c
),

sum_scholarship_applications AS (
  SELECT
    student_c,
    SUM(amount_awarded_c) AS sum_scholarship_applications

  FROM
    `data-warehouse-289815.salesforce_clean.scholarship_application_clean`
  WHERE
    is_deleted = false
    AND scholarship_application_record_type_name != 'Bank Book'
    AND status_c = 'Won'
  GROUP BY
    student_c
),

join_data AS(
  SELECT
    GCD.*,
    CSA.num_scholarship_applications,
    SSA.sum_scholarship_applications
  FROM
    gather_contact_data GCD
    LEFT JOIN count_scholarship_applications CSA ON CSA.student_c = GCD.Contact_Id
        LEFT JOIN sum_scholarship_applications SSA ON SSA.student_c = GCD.Contact_Id

)
SELECT
  *
FROM
  join_data