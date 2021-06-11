/*
 Contact And Academic Term Cleaning Process
 
 Script 1: Creates a Contact Template
 
 Script 2.a: Creates a clean Academic Term table. This table is not saved. 
 
 Script 2.b: Joins Contact Template and clean AT table to create Contact with AT Template
 
 */
-- Script 1: Contact Template
CREATE
OR REPLACE TABLE `data-warehouse-289815.salesforce_clean.contact_template` AS(
  -- Script 1: Contact Template
  WITH ValidStudentContact AS (
    SELECT
      C.Id AS Contact_Id,
      C.GPA_Cumulative_c AS college_eligibility_gpa_11th_grade,
      Test_opt_out.official_test_prep_withdrawal_c,
      -- want to rename to college_eligibility_gpa_11th_grade when ready
      C.*
    EXCEPT
      (
        -- Fields to remove because need to be recreated
        Id,
        Current_HS_CT_Coach_c,
        GPA_Cumulative_c,
        current_enrollment_status_c,
        -- Current_CC_Advisor2_c,
        Current_Major_c,
        current_major_specific_c,
        Current_Minor_c,
        age_c,
        current_second_major_c,
        co_vitality_scorecard_color_most_recent_c,
        -- Indicator_High_Risk_for_Dismissal__c - this field should probably be recreated, but I'm holding off for now.
        Current_School_c,
        Current_School_Type_c,
        first_generation_fy_20_c,
        credit_accumulation_pace_c,
        --   Community_Service_On_Track_c,
        most_recent_gpa_semester_c,
        Most_Recent_GPA_Cumulative_c,
        Gender_c,
        Ethnic_background_c,
        -- Fields to remove because not needed
        _fivetran_synced,
        co_vitality_indicator_c,
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
      A_school.Predominant_Degree_Awarded_c AS Current_School_Type_c_degree,
      -- Academic Term
      C_AT.Term_c AS Current_AT_Term,
      C_AT.gpa_semester_c AS Current_AT_Term_GPA,
      C_AT.GPA_semester_cumulative_c AS Current_AT_Cum_GPA,
      C_AT.second_major_c AS current_second_major_c,
      C_AT.school_c AS Current_School_c,
      C_AT.Minor_c AS Current_Minor_c,
      C_AT.Major_Other_c AS Current_Major_specific_c,
      C_AT.Major_c AS Current_Major_c,
      C_AT.CT_Coach_c AS Current_HS_CT_Coach_c,
      C_AT.Attendance_Rate_c / 100 AS Attendance_Rate_Current_AS_c,
      -- Previous AT
      Prev_AT.gpa_semester_c AS Prev_AT_Term_GPA,
      Prev_AT.GPA_semester_cumulative_c AS Prev_AT_Cum_GPA,
      -- Previous Previous AT
      Prev_Prev_AT.gpa_semester_c AS Prev_Prev_AT_Term_GPA,
      Prev_Prev_AT.gpa_semester_cumulative_c AS Prev_Prev_AT_Cum_GPA,
      -- Previous Previous Previous AT
      Prev_Prev_Prev_AT.gpa_semester_c AS Prev_Prev_Prev_AT_Term_GPA,
      Prev_Prev_Prev_AT.GPA_semester_cumulative_c AS Prev_Prev_Prev_AT_Cum_GPA,
      -- CT Status
      STATUS.Status AS College_Track_Status_Name,
      -- Rebuilding fields that need to be recreated
      CASE
        WHEN C_AT.Attendance_Rate_c <= 65 THEN "65% and Below"
        WHEN C_AT.Attendance_Rate_c < 80 THEN "65% - 79%"
        WHEN C_AT.Attendance_Rate_c < 90 THEN "80% - 89%"
        WHEN C_AT.Attendance_Rate_c >= 90 THEN "90% +"
        ELSE "No Data"
      END AS attendance_bucket_current_at,
      CASE
        WHEN Ethnic_background_c IS NULL THEN "Missing"
        ELSE Ethnic_background_c
      END AS Ethnic_background_c,
      CASE
        WHEN Gender_c IS NULL THEN "Decline to State"
        ELSE Gender_c
      END AS Gender_c,
      CASE
        WHEN first_generation_fy_20_c IS NULL THEN "Missing"
        ELSE first_generation_fy_20_c
      END AS first_generation_fy_20_c,
      CASE
        WHEN co_vitality_scorecard_color_most_recent_c IS NULL THEN "No Data"
        ELSE co_vitality_scorecard_color_most_recent_c
      END AS co_vitality_scorecard_color_most_recent_c,
      `data-warehouse-289815.UDF.calc_age`(CURRENT_DATE(), birthdate) As age_c,
      CASE
        WHEN years_since_hs_grad_c = 0
        AND (
          C_AT.Term_c = "Fall"
          OR (
            (
              EXTRACT(
                MONTH
                FROM
                  C_AT.start_date_c
              ) = 1
              AND Prev_AT.gpa_semester_c IS NULL
            )
            OR (
              EXTRACT(
                MONTH
                FROM
                  C_AT.start_date_c
              ) = 4
              AND Prev_AT.gpa_semester_c IS NULL
              AND Prev_Prev_AT.gpa_semester_c IS NULL
            )
            OR (
              EXTRACT(
                MONTH
                FROM
                  C_AT.start_date_c
              ) = 7
              AND Prev_AT.gpa_semester_c IS NULL
              AND Prev_Prev_AT.gpa_semester_c IS NULL
            )
          )
        ) THEN NULL
        WHEN C_AT.gpa_semester_c IS NOT NULL THEN C_AT.gpa_semester_c
        WHEN Prev_AT.gpa_semester_c IS NOT NULL THEN Prev_AT.gpa_semester_c
        WHEN Prev_Prev_AT.gpa_semester_c IS NOT NULL THEN Prev_Prev_AT.gpa_semester_c
        WHEN Prev_Prev_Prev_AT.gpa_semester_c IS NOT NULL THEN Prev_Prev_Prev_AT.gpa_semester_c
        ELSE NULL
      END AS most_recent_gpa_semester_c,
      CASE
        WHEN years_since_hs_grad_c = 0
        AND (
          C_AT.Term_c = "Fall"
          OR (
            (
              EXTRACT(
                MONTH
                FROM
                  C_AT.start_date_c
              ) = 1
              AND Prev_AT.GPA_semester_cumulative_c IS NULL
            )
            OR (
              EXTRACT(
                MONTH
                FROM
                  C_AT.start_date_c
              ) = 4
              AND Prev_AT.GPA_semester_cumulative_c IS NULL
              AND Prev_Prev_AT.GPA_semester_cumulative_c IS NULL
            )
            OR (
              EXTRACT(
                MONTH
                FROM
                  C_AT.start_date_c
              ) = 7
              AND Prev_AT.GPA_semester_cumulative_c IS NULL
              AND Prev_Prev_AT.GPA_semester_cumulative_c IS NULL
            )
          )
        ) THEN NULL
        WHEN C_AT.GPA_semester_cumulative_c IS NOT NULL THEN C_AT.GPA_semester_cumulative_c
        WHEN Prev_AT.GPA_semester_cumulative_c IS NOT NULL THEN Prev_AT.GPA_semester_cumulative_c
        WHEN Prev_Prev_AT.GPA_semester_cumulative_c IS NOT NULL THEN Prev_Prev_AT.GPA_semester_cumulative_c
        WHEN Prev_Prev_Prev_AT.GPA_semester_cumulative_c IS NOT NULL THEN Prev_Prev_Prev_AT.GPA_semester_cumulative_c
        ELSE NULL
      END AS Most_Recent_GPA_Cumulative_c,
      C_AT.enrollment_status_c AS current_enrollment_status_c,
      CASE
        WHEN credit_accumulation_pace_c IS NULL THEN "No Data"
        ELSE credit_accumulation_pace_c
      END AS credit_accumulation_pace_c,
      -- Creating New Fields
      CASE
        WHEN A_school.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting" THEN "4-Year"
        WHEN A_school.Predominant_Degree_Awarded_c = "Predominantly associate's-degree granting" THEN "2-Year"
        WHEN A_school.Predominant_Degree_Awarded_c = "Predominantly certificate-degree granting" THEN "Certificate-Degree Granting"
        ELSE "Unknown"
      END AS school_type,
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
      -- Creating Sorting Fields
      CASE
        WHEN A_Site.Name LIKE '%East Palo Alto%' THEN 1
        WHEN A_Site.Name LIKE '%Oakland%' THEN 2
        WHEN A_Site.Name LIKE '%San Francisco%' THEN 3
        WHEN A_Site.Name LIKE '%Sacramento%' THEN 4
        WHEN A_Site.Name LIKE '%New Orleans%' THEN 5
        WHEN A_Site.Name LIKE '%Aurora%' THEN 6
        WHEN A_Site.Name LIKE '%Denver%' THEN 7
        WHEN A_Site.Name LIKE '%Boyle Heights%' THEN 8
        WHEN A_Site.Name LIKE '%Watts%' THEN 9
        WHEN A_Site.Name LIKE '%Crenshaw%' THEN 10
        WHEN A_Site.Name LIKE '%Durant%' THEN 11
        WHEN A_Site.Name LIKE '%Ward 8%' THEN 12
        ELSE 13
      END AS site_sort,
      CASE
        WHEN C_AT.Attendance_Rate_c <= 65 THEN 1
        WHEN C_AT.Attendance_Rate_c < 80 THEN 2
        WHEN C_AT.Attendance_Rate_c < 90 THEN 3
        WHEN C_AT.Attendance_Rate_c >= 90 THEN 4
        ELSE 0
      END AS sort_attendance_bucket,
      CASE
        WHEN co_vitality_scorecard_color_most_recent_c = "Red" THEN 1
        WHEN co_vitality_scorecard_color_most_recent_c = "Blue" THEN 2
        WHEN co_vitality_scorecard_color_most_recent_c = "Green" THEN 3
        ELSE 0
      END AS sort_covitality,
      CASE
        WHEN credit_accumulation_pace_c IS NULL THEN 0
        WHEN credit_accumulation_pace_c = '4-Year Track' THEN 1
        WHEN credit_accumulation_pace_c = '5-Year Track' THEN 2
        WHEN credit_accumulation_pace_c = '6-Year Track' THEN 3
        WHEN credit_accumulation_pace_c = '6+ Years' THEN 4
        ELSE 0
      END AS sort_credit_accumulation_pace_c
    FROM
      `data-warehouse-289815.salesforce.contact` C
      LEFT JOIN `data-warehouse-289815.salesforce.record_type` RT ON C.record_type_id = RT.Id -- Left join from Contact on to Account for Site
      LEFT JOIN `data-warehouse-289815.salesforce.account` A_Site ON C.site_c = A_Site.Id -- Left join from Contact on to Account for Site
      LEFT JOIN `data-warehouse-289815.salesforce.account` A_region ON C.Region_c = A_region.Id
      LEFT JOIN `data-warehouse-289815.roles.ct_status` STATUS ON STATUS.api_name = C.College_Track_Status_c
      LEFT JOIN `data-warehouse-289815.salesforce.academic_semester_c` C_AT ON C_AT.id = C.current_academic_semester_c
      LEFT JOIN `data-warehouse-289815.salesforce.academic_semester_c` Prev_AT ON Prev_AT.id = C_AT.Previous_Academic_Semester_c
      LEFT JOIN `data-warehouse-289815.salesforce.academic_semester_c` Prev_Prev_AT ON Prev_Prev_AT.id = Prev_AT.Previous_Academic_Semester_c
      LEFT JOIN `data-warehouse-289815.salesforce.academic_semester_c` Prev_Prev_Prev_AT ON Prev_Prev_Prev_AT.id = Prev_Prev_AT.Previous_Academic_Semester_c
      LEFT JOIN `data-warehouse-289815.salesforce.account` A_school ON C_AT.School_c = A_school.Id
      LEFT JOIN `data-warehouse-289815.salesforce.academic_semester_c` Test_opt_out ON Test_opt_out.student_c = C.Id
    WHERE
      -- Filter out test records from the Contact object
      (C.SITE_c != '0011M00002GdtrEQAR') -- Filter out non-active student records from the Contact object
      AND (
        RT.Name = 'Student: High School'
        OR RT.Name = 'Student: Post-Secondary'
        OR RT.Name = 'Student: Alumni'
        OR RT.Name = 'Student: Applicant'
      )
      AND C.is_deleted = false
      AND (Test_opt_out.grade_c = '12th Grade' AND Test_opt_out.term_c = 'Spring')
  ),
  ValidStudentContact_new_fields AS (
    SELECT
      *,
      -- Creating New Fields that rely on the fields created in ValidStudentContact
      `data-warehouse-289815.UDF.determine_buckets`(Most_Recent_GPA_Cumulative_c,.25, 2.5, 3.75, "") AS Most_Recent_GPA_Cumulative_bucket,
      `data-warehouse-289815.UDF.sort_created_buckets`(Most_Recent_GPA_Cumulative_c,.25, 2.5, 3.75) AS sort_Most_Recent_GPA_Cumulative_bucket,
      `data-warehouse-289815.UDF.determine_buckets`(most_recent_gpa_semester_c,.25, 2.5, 3.75, "") AS most_recent_gpa_semester_bucket,
      `data-warehouse-289815.UDF.sort_created_buckets`(most_recent_gpa_semester_c,.25, 2.5, 3.75) AS sort_most_recent_gpa_semester_bucket,
      CONCAT(
        "https://ctgraduates.lightning.force.com/lightning/r/Contact/",
        Contact_Id,
        "/view"
      ) AS contact_url,
          CONCAT(
      'https://datastudio.google.com/u/0/reporting/c45028c2-c11c-4c75-8818-b023d7a8e570/page/PkIoB?params=%7B%22df51%22:%22include%25EE%2580%25800%25EE%2580%2580IN%25EE%2580%2580',
      contact_id,
      '%22%7D'
    ) AS student_dashboard_preview,
        CONCAT(
      "https://datastudio.google.com/u/0/reporting/75c5576b-bbeb-474b-be6a-e8a2111744e6/page/XrI7B?params=%7B%22df148%22:%22include%25EE%2580%25800%25EE%2580%2580IN%25EE%2580%2580",               
      contact_id,
      '%22%7D'
    ) AS hs_student_profile,
        CONCAT(
        "https://ctgraduates.lightning.force.com/lightning/r/Contact/",
        current_academic_semester_c,
        "/view"
      ) AS current_at_url,
      
              CONCAT(
      "https://datastudio.google.com/u/0/reporting/0289cb81-ed13-4633-8913-2def7f926019/page/XrI7B?params=%7B%22df148%22:%22include%25EE%2580%25800%25EE%2580%2580IN%25EE%2580%2580",               
      contact_id,
      '%22%7D'
    ) AS ps_student_profile,
      
    
    FROM
      ValidStudentContact
  ),
  -- Gathering data that relies on other objects
  -- Task Object
  gather_all_communication_data AS (
    SELECT
      who_id,
      reciprocal_communication_c,
      CASE
        WHEN activity_date = date_of_contact_c THEN date_of_contact_c
        WHEN date_of_contact_c IS NULL
        and activity_date IS NOT NULL THEN activity_date
        ELSE date_of_contact_c
      END AS date_of_contact_c,
    FROM
      `data-warehouse-289815.salesforce.task`
  ),
  most_recent_outreach AS (
    SELECT
      who_id,
      MAX(date_of_contact_c) AS most_recent_outreach
    FROM
      gather_all_communication_data
    GROUP BY
      who_id
  ),
  most_recent_reciprocal AS (
    SELECT
      who_id,
      MAX(date_of_contact_c) AS most_recent_reciprocal
    FROM
      gather_all_communication_data
    WHERE
      reciprocal_communication_c = True
    GROUP BY
      who_id
  )
  SELECT
    VSC.*,
    MRO.most_recent_outreach,
    CASE
      WHEN MRO.most_recent_outreach IS NULL THEN "No Data"
      WHEN DATE_DIFF(
        CURRENT_DATE(),
        MRO.most_recent_outreach,
        DAY
      ) <= 30 THEN "Less than 30 Days"
      WHEN DATE_DIFF(
        CURRENT_DATE(),
        MRO.most_recent_outreach,
        DAY
      ) <= 60 THEN "31 - 60 Days"
      WHEN DATE_DIFF(
        CURRENT_DATE(),
        MRO.most_recent_outreach,
        DAY
      ) > 60 THEN "61+ Days"
    END AS most_recent_outreach_bucket,
    MRR.most_recent_reciprocal,
    CASE
      WHEN MRR.most_recent_reciprocal IS NULL THEN "No Data"
      WHEN DATE_DIFF(
        CURRENT_DATE(),
        MRR.most_recent_reciprocal,
        DAY
      ) <= 30 THEN "Less than 30 Days"
      WHEN DATE_DIFF(
        CURRENT_DATE(),
        MRR.most_recent_reciprocal,
        DAY
      ) <= 60 THEN "31 - 60 Days"
      WHEN DATE_DIFF(
        CURRENT_DATE(),
        MRR.most_recent_reciprocal,
        DAY
      ) > 60 THEN "61+ Days"
    END AS most_recent_reciprocal_bucket,
  FROM
    ValidStudentContact_new_fields VSC
    LEFT JOIN most_recent_outreach MRO ON MRO.who_id = VSC.Contact_Id
    LEFT JOIN most_recent_reciprocal MRR ON MRR.who_Id = VSC.Contact_Id
);
-- Script 2 Contact AT Template
CREATE
OR REPLACE TABLE `data-warehouse-289815.salesforce_clean.contact_at_template` AS(
  WITH Clean_AT AS(
    SELECT
      A.Id AS AT_Id,
      A.Name AS AT_Name,
      A.record_type_id AS AT_RecordType_ID,
      A.Enrollment_Status_c AS AT_Enrollment_Status_c,
      A.Grade_c AS AT_Grade_c,
      A.GPA_semester_c AS AT_Term_GPA,
      -- want to rename to AT_Term_GPA when ready
      A.GPA_semester_cumulative_c AS AT_Cumulative_GPA,
      -- want to rename to AT_Cumulative_GPA when ready
      A.*
    EXCEPT(
        Id,
        GPA_semester_c,
        GPA_semester_cumulative_c,
        Name,
        record_type_id,
        created_date,
        created_by_id,
        last_modified_date,
        last_modified_by_id,
        last_activity_date,
        Anticipated_Date_of_Graduation_4_year_c,
        Admin_Temp_1_c,
        Enrollment_Status_c,
        Grade_c,
        Parent_Email_1_c,
        Parent_Email_2_c,
        Reason_For_Leaving_Dismissal_c,
        Site_c,
        Total_Bank_Book_Earnings_current_c,
        Credits_Accumulated_Most_Recent_c,
        Legacy_Salesforce_ID_c,
        Legacy_Import_ID_c,
        is_deleted,
        system_modstamp,
        last_viewed_date,
        last_referenced_date,
        Current_CCA_Viewing_c,
        current_as_c,
        previous_as_c,
        Prev_Prev_As_c,
        attendance_rate_c,
        Attendance_Rate_excluding_make_ups_c,
        Attendance_Rate_Previous_Term_c
      ),
      RT.Name AS AT_Record_Type_Name,
      A_School.Name AS AT_School_Name,
            CASE
        WHEN A_school.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting" THEN "4-Year"
        WHEN A_school.Predominant_Degree_Awarded_c = "Predominantly associate's-degree granting" THEN "2-Year"
        WHEN A_school.Predominant_Degree_Awarded_c = "Predominantly certificate-degree granting" THEN "Certificate-Degree Granting"
        ELSE "Unknown"
      END AS AT_school_type,
      GAS.Name AS GAS_Name,
      GAS.Start_Date_c AS GAS_Start_Date,
      GAS.End_Date_c AS GAS_End_Date,
      AY.Name AS AY_Name,
      AY.Start_Date_c as AY_Start_Date,
      AY.End_Date_c as AY_End_Date,
      --   Recreating Forumula Fields
      CASE
        WHEN enrolled_sessions_c = 0 THEN NULL
        ELSE Attended_Workshops_c / Enrolled_Sessions_c
      END AS attendance_rate_c,
      CASE
        WHEN Enrolled_Workshops_excluding_make_ups_c = 0 THEN NULL
        ELSE Attended_Workshops_excluding_make_ups_c / Enrolled_Workshops_excluding_make_ups_c
      END AS Attendance_Rate_excluding_make_ups_c,
      --   Creating New Fields
      `data-warehouse-289815.UDF.determine_buckets`(A.GPA_semester_c,.25, 2.5, 3.75, "") AS AT_Term_GPA_bucket,
      `data-warehouse-289815.UDF.sort_created_buckets`(A.GPA_semester_c,.25, 2.5, 3.75) AS sort_AT_Term_GPA_bucket,
      `data-warehouse-289815.UDF.determine_buckets`(A.GPA_semester_cumulative_c,.25, 2.5, 3.75, "") AS AT_Cumulative_GPA_bucket,
      `data-warehouse-289815.UDF.sort_created_buckets`(A.GPA_semester_cumulative_c,.25, 2.5, 3.75) AS sort_AT_Cumulative_GPA,
      CASE
        WHEN CURRENT_DATE() >= GAS.start_date_c
        AND CURRENT_DATE() <= GAS.end_date_c THEN true
        ELSE false
      END AS current_as_c,
      CASE
        WHEN advising_rubric_financial_success_v_2_c = "Red" THEN 1
        WHEN advising_rubric_financial_success_v_2_c = "Yellow" THEN 2
        WHEN advising_rubric_financial_success_v_2_c = "Green" THEN 3
        ELSE 4
      END AS sort_Advising_Rubric_Financial_Success_sort,
      CASE
        WHEN advising_rubric_academic_readiness_v_2_c = "Red" THEN 1
        WHEN advising_rubric_academic_readiness_v_2_c = "Yellow" THEN 2
        WHEN advising_rubric_academic_readiness_v_2_c = "Green" THEN 3
        ELSE 4
      END AS sort_Advising_Rubric_Academic_Readiness_sort,
      CASE
        WHEN advising_rubric_career_readiness_v_2_c = "Red" THEN 1
        WHEN advising_rubric_career_readiness_v_2_c = "Yellow" THEN 2
        WHEN advising_rubric_career_readiness_v_2_c = "Green" THEN 3
        ELSE 4
      END AS sort_Advising_Rubric_Career_Readiness_sort,
      CASE
        WHEN advising_rubric_wellness_v_2_c = "Red" THEN 1
        WHEN advising_rubric_wellness_v_2_c = "Yellow" THEN 2
        WHEN advising_rubric_wellness_v_2_c = "Green" THEN 3
        ELSE 4
      END AS sort_Advising_Rubric_Wellness_sort,
      CASE
        WHEN credits_accumulated_most_recent_c IS NULL THEN "Frosh"
        WHEN credits_accumulated_most_recent_c < 25 THEN "Frosh"
        WHEN credits_accumulated_most_recent_c < 50 THEN "Sophomore"
        WHEN credits_accumulated_most_recent_c < 75 THEN "Junior"
        WHEN credits_accumulated_most_recent_c >= 75 THEN "Senior"
      END AS college_class,
      CASE
        WHEN (
          advising_rubric_academic_readiness_v_2_c = "Red"
          OR advising_rubric_career_readiness_v_2_c = 'Red'
          OR advising_rubric_financial_success_v_2_c = "Red"
          OR advising_rubric_wellness_v_2_c = "Red"
        ) THEN "Red"
        WHEN (
          advising_rubric_academic_readiness_v_2_c = "Yellow"
          OR advising_rubric_career_readiness_v_2_c = 'Yellow'
          OR advising_rubric_financial_success_v_2_c = "Yellow"
          OR advising_rubric_wellness_v_2_c = "Yellow"
        ) THEN "Yellow"
        WHEN (
          advising_rubric_academic_readiness_v_2_c = "Green"
          OR advising_rubric_career_readiness_v_2_c = 'Green'
          OR advising_rubric_financial_success_v_2_c = "Green"
          OR advising_rubric_wellness_v_2_c = "Green"
        ) THEN "Green"
        ELSE "No Data"
      END AS Overall_Rubric_Color
    FROM
      `data-warehouse-289815.salesforce.academic_semester_c` A
      LEFT JOIN `data-warehouse-289815.salesforce.record_type` RT ON A.record_type_id = RT.Id -- Left join from Contact on to Account for Site
      LEFT JOIN `data-warehouse-289815.salesforce.account` A_School ON A.School_c = A_School.Id -- Left join from Contact on to Account for Site
      LEFT JOIN `data-warehouse-289815.salesforce.global_academic_semester_c` GAS ON A.Global_Academic_Semester_c = GAS.Id
      LEFT JOIN `data-warehouse-289815.salesforce.academic_year_c` AY ON A.Academic_Year_c = AY.Id
    WHERE
      A.is_deleted = false
  ),
  gather_prev_at AS (
    SELECT
      student_c,
      previous_academic_semester_c,
    FROM
      Clean_AT
    WHERE
      current_as_c = true
  ),
  prep_data AS (
    SELECT
      C.*,
      Clean_AT.*,
      CASE
        WHEN gather_prev_at.previous_academic_semester_c = AT_Id THEN true
        ELSE false
      END AS previous_as_c,
      CASE
        WHEN Clean_AT.Overall_Rubric_Color = "Red" THEN 1
        WHEN Clean_AT.Overall_Rubric_Color = "Yellow" THEN 2
        WHEN Clean_AT.Overall_Rubric_Color = "Green" THEN 3
        ELSE 4
      END AS Overall_Rubric_Color_sort,
    FROM
      `data-warehouse-289815.salesforce_clean.contact_template` C
      LEFT JOIN Clean_AT ON C.Contact_Id = Clean_AT.student_c
      LEFT JOIN gather_prev_at ON gather_prev_at.student_c = C.Contact_Id
  ),
  gather_prev_prev_at AS (
    SELECT
      Contact_Id,
      previous_academic_semester_c,
    FROM
      prep_data
    WHERE
      previous_as_c = true
  ),
  determine_prev_prev_at AS (
    SELECT
      prep_data.*,
      -- gather_prev_prev_at.previous_academic_semester_c,
      CASE
        WHEN gather_prev_prev_at.previous_academic_semester_c = prep_data.AT_Id THEN true
        ELSE false
      END AS prev_prev_as_c
    FROM
      prep_data
      LEFT JOIN gather_prev_prev_at ON gather_prev_prev_at.Contact_Id = prep_data.Contact_Id
  ),
  determine_previous_attendance_rate AS (
    SELECT
      DPPA.AT_Id,
      CASE WHEN DPPA.term_c = 'Fall' THEN Prev_Prev_DPPA.attendance_rate_c
      ELSE Prev_DPPA.attendance_rate_c
      END AS Attendance_Rate_Previous_Term_c
    FROM
      determine_prev_prev_at DPPA
      LEFT JOIN determine_prev_prev_at Prev_DPPA ON DPPA.previous_academic_semester_c = Prev_DPPA.AT_Id
      LEFT JOIN determine_prev_prev_at Prev_Prev_DPPA ON Prev_DPPA.previous_academic_semester_c = Prev_Prev_DPPA.AT_Id
  )
  
  SELECT
    DPPA.*,
    DPAR.Attendance_Rate_Previous_Term_c
  FROM
    determine_prev_prev_at DPPA
    LEFT JOIN determine_previous_attendance_rate DPAR ON DPPA.AT_Id = DPAR.AT_Id
    )