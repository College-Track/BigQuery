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
    C.annual_household_income_c,
    C.Current_school_name,
    C.current_academic_semester_c,
    C.summer_experiences_previous_summer_c,
    
    C.total_bank_book_balance_contact_c,
    
    C.community_service_hours_c,
    
    C.current_at_url,
    C.FA_Req_FAFSA_c


    
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template` C
    LEFT JOIN `data-warehouse-289815.salesforce.contact` PC ON PC.Id = C.primary_contact_c
    -- LEFT JOIN `data-warehouse-289815.salesforce.npe_4_relationship_c` R ON R.npe_4_contact_c = C.Contact_Id
    -- LEFT JOIN `data-warehouse-289815.salesforce.contact` EC ON EC.Id = R.npe_4_related_contact_c
  WHERE
    C.college_track_status_c IN ('15A', '16A')
    AND C.indicator_completed_ct_hs_program_c = true
    -- AND R.emergency_contact_c = true
),

join_data AS(
  SELECT
    GCD.*,
    
  FROM
    gather_contact_data GCD
    
)
SELECT
  *
FROM
  join_data