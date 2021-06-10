WITH gather_contact_data AS (
    SELECT region_abrev,
           region_short,
           site_short,
           contact_id,
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
--            Academic_Year_4_Year_Degree_Earned_c,
           college_track_status_c
    FROM `data-warehouse-289815.salesforce_clean.contact_template`
),

     gather_at_data AS (
         SELECT Contact_id,
                AT_id,
                AY_Name,
                AY_End_Date,
                SUM(attended_workshops_c) AS attended_workshops_c,
                (SELECT DISTINCT student_audit_status_c
                 FROM `data-warehouse-289815.salesforce_clean.contact_at_template` ST
                 WHERE ST.AY_Name = A_T.AY_Name
                   AND ST.term_c = 'Spring')

         FROM `data-warehouse-289815.salesforce_clean.contact_at_template` A_T
         GROUP BY Contact_id, AT_id, AY_Name, AY_End_Date
     )
SELECT GCD.*,
       GAD.AY_Name,
       GAD.AY_End_Date,
       GAD.attended_workshops_c
FROM gather_contact_data GCD
         LEFT JOIN gather_at_data GAD ON GAD.Contact_id = GCD.contact_id
WHERE college_track_status_c = '11A'
LIMIT 100