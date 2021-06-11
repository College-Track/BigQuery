WITH gather_contact_data AS (
    SELECT region_abrev,
           region_short,
           site_short,
           Contact_Id,
--            gender_c,
--            ethnic_background_c,
--            high_school_graduating_class_c,
--            indicator_first_generation_c,
--            indicator_low_income_c,
--            birthdate,
--            mailing_postal_code,
--            Indicator_Completed_CT_HS_Program_c,
--            college_applications_all_fit_types_c,
--            Four_Year_College_Applications_c,
--            Dream_Statement_filled_out_c,
--            fa_req_fafsa_c,
--            Four_Year_College_Acceptances_c,
--            College_Acceptances_Affordable_c,
--            SAT_Official_Tests_Taken_c,
--            ACT_Official_Tests_Taken_c,
--            Readiness_10_th_Math_c,
--            Readiness_10_th_English_c,
--            Readiness_10_th_Composite_c,
--            Readiness_9_th_Math_c,
--            readiness_9_th_english_c,
--            Readiness_9_th_Composite_c,
--            Readiness_Math_Official_c,
--            Readiness_English_Official_c,
--            Readiness_Composite_Off_c,
--            Citizen_c_c,
           Academic_Year_4_Year_Degree_Earned_c,
           college_track_status_c
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
        WHERE college_track_status_c IN ('18a', '11A', '12A', '13A', '15A', '16A', '17A')
),

     gather_at_data AS (
         SELECT Contact_Id,
                AY_Name,
                AY_End_Date,
                SUM(attended_workshops_c) AS attended_workshops_c

         FROM `data-warehouse-289815.salesforce_clean.contact_at_template` A_T
         WHERE AY_End_Date <= CURRENT_DATE()
         GROUP BY Contact_Id, AY_Name, AY_End_Date
     ),
     gather_spring_at_status AS (SELECT Contact_Id,
                                        AY_Name,
                                        student_audit_status_c,
                                        AT_School_Name,
                                        AT_school_type,
                                        enrollment_status_c,
                                        fit_type_at_c
                                 FROM `data-warehouse-289815.salesforce_clean.contact_at_template` A_T
                                 WHERE term_c = 'Spring'),
  join_data AS (SELECT GCD.*,
                       GAD.* EXCEPT (Contact_Id),
    GSAS.* EXCEPT (Contact_Id, AY_Name, student_audit_status_c),
    CASE
    WHEN Academic_Year_4_Year_Degree_Earned_c = GAD.AY_Name THEN "Active: Post-Secondary"
    ELSE GSAS.student_audit_status_c
END
AS student_audit_status_c

FROM gather_contact_data GCD
         LEFT JOIN gather_at_data GAD ON GAD.Contact_Id = GCD.Contact_Id
         LEFT JOIN gather_spring_at_status GSAS ON GSAS.Contact_Id = GCD.Contact_Id AND GSAS.AY_Name = GAD.AY_Name

),
     create_list_of_ay AS
         (SELECT DISTINCT AY_Name
          FROM join_data
             WHERE AY_Name IS NOT NULL
         )


SELECT  create_list_of_ay.AY_Name,
                JD.*
    FROM create_list_of_ay
        LEFT JOIN join_data JD ON JD.AY_Name = create_list_of_ay.AY_Name

WHERE Academic_Year_4_Year_Degree_Earned_c = 'AY 2016-17'
AND JD.Contact_Id = '0034600001TQqR5AAL'
LIMIT 1000
--
-- SELECT
-- *
-- FROM create_list_of_ay
-- -- WHERE gather_at_data.Contact_Id ='0034600001TQqR5AAL'