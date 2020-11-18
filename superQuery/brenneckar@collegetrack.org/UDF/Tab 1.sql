/*
 Contact And Academic Term Cleaning Process
 
 Script 1: Creates a Contact Template
 
 Script 2.a: Creates a clean Academic Term table. This table is not saved. 
 
 Script 2.b: Joins Contact Template and clean AT table to create Contact with AT Template
 
 */
-- Script 1: Contact Template
WITH ValidStudentContact AS (
  SELECT
    C.Id AS Contact_Id,
    C.*
  EXCEPT
    (
      -- Fields to remove because need to be recreated
      Id,
      Current_HS_CT_Coach_c,
      -- Current_CC_Advisor2_c,
      Current_Major_c,
    --   Current_Major_other_c,
      Current_Minor_c,
      age_c,
      current_second_major_c,
      -- Indicator_High_Risk_for_Dismissal__c - this field should probably be recreated, but I'm holding off for now.
      Current_School_c,
      Current_School_Type_c,
    --   Community_Service_On_Track_c,
      most_recent_gpa_semester_c,
      -- Fields to remove because not needed
      _fivetran_synced,
    --   CoVitality_Indicator_c,
      active_board_membership_c,
      admin_temp_1_c,
      Description,
      board_member_c,
      current_cca_viewing_c,
      department,
      gw_volunteers_first_volunteer_date_c,
      gw_volunteers_last_volunteer_date_c,
      gw_volunteers_unique_volunteer_count_c,
      gw_volunteers_volunteer_hours_c,
      last_curequest_date,
      last_cuupdate_date,
      last_modified_by_id,
      last_modified_date,
      last_referenced_date,
      npe_01_last_donation_date_c,
      npe_01_lifetime_giving_history_amount_c,
      npo_02_last_close_date_hh_c,
      npo_02_opp_amount_last_year_hh_c,
      npo_02_opp_amount_this_year_hh_c,
      npo_02_total_household_gifts_c,
      preferred_address_gift_acknowledgment_c,
      rh_2_formula_test_c,
      salutation,
      same_owner_as_site_c,
      stayclassy_average_donation_c,
      system_modstamp,
      title,
      top_target_list_c,
      workshops_attended_last_7_days_c,
      workshops_attended_prior_week_c,
      last_viewed_date,
      last_visit_report_date_c,
      attended_c,
      attended_workshops_10_th_grade_c,
      attended_workshops_11_th_grade_c,
      attended_workshops_12_th_grade_c,
      attended_workshops_9_th_grade_c,
    --   Annual_Attendance_Rate_10th_Grade_c,
    --   Annual_Attendance_Rate_11th_Grade_c,
    --   Annual_Attendance_Rate_12th_Grade_c,
    --   Annual_Attendance_Rate_9th_Grade_c,
      Attendance_Rate_Annual_c,
      Attendance_Rate_Current_AS_c,
      Attendance_Rate_Current_AS_no_make_up_c,
      Attendance_Rate_Last_AS_c,
      Attendance_category_current_semester_c,
      Attendance_category_current_year_c,
      Attendance_category_previous_semester_c,
      Dosage_Rec_CC_c,
      Dosage_Rec_Math_c,
    --   Dosage_Rec_Overall_c,
      Dosage_Rec_SL_c,
      Dosage_Rec_Test_Prep_c,
      Dosage_Rec_Tutoring_c,
      Indicator_Meets_Attendance_Goal_c,
    --   Meets_Dosage_Recommendation_c,
      Program_Rec_NSO_c,
      Program_Rec_Summer_Writing_c
     
    ),
    -- Fields from other objects
    -- Record Type
    RT.Name AS Contact_Record_Type_Name,
    -- Account
    A_Site.Name AS site,
    A_Region.Name AS region,
    A_school.Name AS Current_school_name,
    A_school.Predominant_Degree_Awarded_c AS Current_School_Type_c,
    -- Academic Term
    C_AT.Term_c AS Current_AT_Term,
    C_AT.gpa_semester_c AS Current_AT_Term_GPA,
    C_AT.second_major_c AS current_second_major_c,
    C_AT.school_c AS Current_School_c,
    C_AT.Minor_c AS Current_Minor_c,
    C_AT.Major_Other_c AS Current_Major_specific_c,
    C_AT.Major_c AS Current_Major_c,
    C_AT.CT_Coach_c AS Current_HS_CT_Coach_c,
    -- Previous AT
    Prev_AT.gpa_semester_c AS Prev_AT_Term_GPA,
    -- Previous Previous AT
    Prev_Prev_AT.gpa_semester_c AS Prev_Prev_AT_Term_GPA,
    -- CT Status
    STATUS.Status AS College_Track_Status_Name,
    -- Rebuilding fields that need to be recreated
    `data-warehouse-289815.UDF.calc_age`(CURRENT_DATE(), birthdate) As age_c,
    CASE
      WHEN A_Region.Name LIKE '%Northern California%' THEN 'Northern California'
      WHEN A_Region.Name LIKE '%Colorado%' THEN 'Colorado'
      WHEN A_Region.Name LIKE '%Los Angeles%' THEN 'Los Angeles'
      WHEN A_Region.Name LIKE '%New Orleans%' THEN 'New Orleans'
      WHEN A_Region.Name LIKE '%DC%' THEN 'Washington DC'
      ELSE A_Region.Name
    END AS region_short,
    CASE
      WHEN A_Region.Name LIKE '%Northern California%' THEN 'NOR CAL'
      WHEN A_Region.Name LIKE '%Colorado%' THEN 'CO'
      WHEN A_Region.Name LIKE '%Los Angeles%' THEN 'LA'
      WHEN A_Region.Name LIKE '%New Orleans%' THEN 'NOLA'
      WHEN A_Region.Name LIKE '%DC%' THEN 'DC'
      ELSE A_Region.Name
    END AS region_abrev,
    CASE
      WHEN A_Site.Name LIKE '%Denver%' THEN 'DEN'
      WHEN A_Site.Name LIKE '%Aurora%' THEN 'AUR'
      WHEN A_Site.Name LIKE '%San Francisco%' THEN 'SF'
      WHEN A_Site.Name LIKE '%East Palo Alto%' THEN 'EPA'
      WHEN A_Site.Name LIKE '%Sacramento%' THEN 'SAC'
      WHEN A_Site.Name LIKE '%Oakland%' THEN 'OAK'
      WHEN A_Site.Name LIKE '%Watts%' THEN 'WATTS'
      WHEN A_Site.Name LIKE '%Boyle Heights%' THEN 'BH'
      WHEN A_Site.Name LIKE '%Ward 8%' THEN 'WARD 8'
      WHEN A_Site.Name LIKE '%Durant%' THEN 'PGC'
      WHEN A_Site.Name LIKE '%New Orleans%' THEN 'NOLA'
      WHEN A_Site.Name LIKE '%Crenshaw%' THEN 'CREN'
      ELSE A_Site.Name
    END AS site_abrev,
    CASE
      WHEN A_Site.Name LIKE '%Denver%' THEN 'Denver'
      WHEN A_Site.Name LIKE '%Aurora%' THEN 'Aurora'
      WHEN A_Site.Name LIKE '%San Francisco%' THEN 'San Francisco'
      WHEN A_Site.Name LIKE '%East Palo Alto%' THEN 'East Palo Alto'
      WHEN A_Site.Name LIKE '%Sacramento%' THEN 'Sacramento'
      WHEN A_Site.Name LIKE '%Oakland%' THEN 'Oakland'
      WHEN A_Site.Name LIKE '%Watts%' THEN 'Watts'
      WHEN A_Site.Name LIKE '%Boyle Heights%' THEN 'Boyle Heights'
      WHEN A_Site.Name LIKE '%Ward 8%' THEN 'Ward 8'
      WHEN A_Site.Name LIKE '%Durant%' THEN 'The Durant Center'
      WHEN A_Site.Name LIKE '%New Orleans%' THEN 'New Orleans'
      WHEN A_Site.Name LIKE '%Crenshaw%' THEN 'Crenshaw'
      ELSE A_Site.Name
    END AS site_short,
  FROM
    `data-warehouse-289815.salesforce.contact` C 
    LEFT JOIN `data-warehouse-289815.salesforce.record_type` RT ON C.record_type_id = RT.Id -- Left join from Contact on to Account for Site
    LEFT JOIN `data-warehouse-289815.salesforce.account` A_Site ON C.site_c = A_Site.Id -- Left join from Contact on to Account for Site
    LEFT JOIN `data-warehouse-289815.salesforce.account` A_region ON C.Region_c = A_region.Id
    LEFT JOIN `data-warehouse-289815.salesforce.account` A_school ON C.Current_school_c = A_school.Id
    LEFT JOIN `data-warehouse-289815.roles.ct_status` STATUS ON STATUS.api_name = C.College_Track_Status_c
    LEFT JOIN `data-warehouse-289815.salesforce.academic_semester_c` C_AT ON C_AT.id = C.current_academic_semester_c
    LEFT JOIN `data-warehouse-289815.salesforce.academic_semester_c` Prev_AT ON Prev_AT.id = C_AT.Previous_Academic_Semester_c
    LEFT JOIN `data-warehouse-289815.salesforce.academic_semester_c` Prev_Prev_AT ON Prev_Prev_AT.id = Prev_AT.Previous_Academic_Semester_c
  WHERE
    -- Filter out test records from the Contact object
    (C.SITE_c != '0011M00002GdtrEQAR') -- Filter out non-active student records from the Contact object
    AND (
      RT.Name = 'Student: High School'
      OR RT.Name = 'Student: Post-Secondary'
      OR RT.Name = 'Student: Alumni'
      OR RT.Name = 'Student: Applicant'
    )
)
SELECT
  co_vitality_indicator_c
FROM
  ValidStudentContact
  WHERE college_track_status_c = '11A'