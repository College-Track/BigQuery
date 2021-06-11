SELECT
      C.Id AS Contact_Id,
      C.GPA_Cumulative_c AS college_eligibility_gpa_11th_grade,
      Test_opt_out.official_test_prep_withdrawal_c AS contact_official_test_prep_withdrawal,
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