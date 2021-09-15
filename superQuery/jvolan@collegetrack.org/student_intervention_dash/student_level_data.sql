WITH recent_logged_activities AS
(
    SELECT
    Who_Id,
    What_Id AS Related_to,
    CASE
        WHEN date_of_contact_c IS NOT NULL THEN date_of_contact_c
        Else activity_date
    END AS Date,
    Subject,
    Description,
    Id AS activity_id,
    reciprocal_communication_c,
    Owner_Id AS assigned_to,
    pte_staff_name_optional_c AS PTE_staff,

    FROM `data-warehouse-289815.salesforce.task`
    WHERE NOT (Subject LIKE '%List Email%')
    AND DATE(created_date) BETWEEN DATE_SUB(CURRENT_DATE(),INTERVAL 12 MONTH) AND CURRENT_DATE()
),

recent_logged_activites_users AS
(
SELECT  
    id,
    CONCAT(first_name," ",last_name) AS assigned_to_name,
    recent_logged_activities.Who_Id,
    recent_logged_activities.Related_to,
    recent_logged_activities.Date,
    recent_logged_activities.Subject,
    recent_logged_activities.Description,
    recent_logged_activities.activity_id,
    recent_logged_activities.reciprocal_communication_c,
    recent_logged_activities.assigned_to,
    recent_logged_activities.PTE_staff,
    FROM `data-warehouse-289815.salesforce_clean.user_clean`
    LEFT JOIN recent_logged_activities ON recent_logged_activities.assigned_to = id
),

most_recent_attended_workshop AS    
(
SELECT
    max(date_c) AS most_recent_attended_workshop,
    academic_semester_c,
    FROM `data-warehouse-289815.salesforce_clean.class_template`
    WHERE Attendance_Numerator_c = 1
    GROUP BY academic_semester_c
    
),    
workshop_enrollments AS
(
SELECT
    COUNT(class_c) AS workshops_enrolled,
    academic_semester_c,
    FROM `data-warehouse-289815.salesforce.class_registration_c`
    WHERE status_c = 'Enrolled'
    GROUP BY academic_semester_c
),

student_data_at AS
(
SELECT
--basic contact info & demos
    Contact_Id,
    Full_Name_c,
    site_abrev AS Site,
    site_short,
    region_abrev AS region,
    high_school_graduating_class_c AS HS_Class,
    College_Track_Status_Name AS CT_Status,
    Current_school_name,
    Current_HS_CT_Coach_c,
    CASE
        WHEN Gender_c = "Decline to State" THEN "Other"
        ELSE Gender_c
    END AS Gender_c,    
    email,
    mobile_phone,
    CASE
        WHEN Ethnic_background_c = "Decline to State" THEN "Missing"
        Else Ethnic_background_c
    END AS Ethnic_background_c,
    CASE
        WHEN english_language_learner_c_c = true THEN "Yes"
        WHEN english_language_learner_c_c = false THEN "No"
        ELSE "" 
        END AS ELL,
    CASE
        WHEN studenthasaniep_c = true THEN "Yes"
        WHEN studenthasaniep_c = false THEN "No"
        Else ""
    END AS IEP,
    first_generation_c,
    indicator_low_income_c,
    co_vitality_scorecard_color_most_recent_c,
    CASE
        WHEN Indicator_Intervention_Previous_2_ATs_c = TRUE THEN 1
        ELSE 0
    END AS intervention_prev_2,
    CASE
        WHEN indicator_high_risk_for_dismissal_c = TRUE THEN 1
        ELSE 0
        END AS high_risk_dismissal,
    of_high_school_terms_on_intervention_c,
    latest_reciprocal_communication_date_c,
    
    --primary contact info
    primary_contact_name_mobile_formula_c,
    primary_contact_email_c,
    primary_contact_mobile_c,
    primary_home_language_c,
    primary_contact_c,
    
    --current AT attendance & gpa data
    AT_Id,
    AT_Name,
    GAS_Name,
    AY_Name,
    AT_Grade_c,
    attendance_rate_c,
    enrolled_sessions_c,
    attended_workshops_c,
    attendance_rate_previous_term_c,
    DEP_GPA_Prev_semester_c AS prev_term_GPA,
    gpa_prev_semester_cumulative_c AS prev_CGPA,
    CASE
      WHEN DEP_GPA_Prev_semester_c < 2.75 THEN "Below 2.75"
      WHEN DEP_GPA_Prev_semester_c < 3.5 THEN "2.75 - 3.5"
      WHEN DEP_GPA_Prev_semester_c >= 3.5 THEN "3.5+"
      ELSE "Missing"
    END AS prev_term_gpa_bucket,
     CASE
      WHEN gpa_prev_semester_cumulative_c < 2.75 THEN "Below 2.75"
      WHEN gpa_prev_semester_cumulative_c < 3.5 THEN "2.75 - 3.5"
      WHEN gpa_prev_semester_cumulative_c >= 3.5 THEN "3.5+"
      ELSE "Missing"
    END AS prev_cgpa_bucket,
    CASE
        WHEN indicator_prev_gpa_below_2_75_c = TRUE THEN 1
        Else 0
    END AS intervention_AT_gpa_2_75,    
    CASE
        WHEN indicator_sem_attendance_below_65_c = TRUE THEN 1
        Else 0
    End AS intervention_AT_attendance_65,
    CASE
        WHEN indicator_prev_gpa_below_2_75_c = TRUE AND indicator_sem_attendance_below_65_c = TRUE THEN 1
        ELSE 0
    END AS intervention_AT_both,
    CASE
        WHEN indicator_prev_gpa_below_2_75_c = TRUE AND indicator_sem_attendance_below_65_c = TRUE THEN "GPA & Attendance"
        WHEN indicator_prev_gpa_below_2_75_c = TRUE AND indicator_sem_attendance_below_65_c = FALSE THEN "GPA Only"
        WHEN indicator_prev_gpa_below_2_75_c = FALSE AND indicator_sem_attendance_below_65_c = TRUE THEN "Attendance Only"
        ELSE "None"
    END AS intervention_AT_bucket,
    CASE
        WHEN indicator_student_on_intervention_c = TRUE THEN 1
        Else 0
    End AS intervention_AT,
    academic_intervention_needed_c,
    academic_intervention_received_c,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = TRUE
    AND college_track_status_c IN ("11A", "12A")
    ),

student_data_with_activities AS
(    
    SELECT
    student_data_at.*,
    recent_logged_activites_users.Who_Id,
    recent_logged_activites_users.Related_to,
    recent_logged_activites_users.Date,
    recent_logged_activites_users.Subject,
    recent_logged_activites_users.Description,
    recent_logged_activites_users.activity_id,
    recent_logged_activites_users.assigned_to_name,
    recent_logged_activites_users.PTE_staff,
    CASE
        WHEN recent_logged_activites_users.reciprocal_communication_c = TRUE Then 1
        ELSE 0
        END AS indicator_reciprocal,
    CASE
        WHEN recent_logged_activites_users.reciprocal_communication_c = TRUE Then 'Yes'
        ELSE 'No'
        END AS reciprocal_y_n,
    FROM student_data_at
    LEFT JOIN recent_logged_activites_users ON recent_logged_activites_users.Who_Id = Contact_Id
    ),
    
student_data_with_activities_enrollments AS
(
    SELECT
    student_data_with_activities.*,
    workshop_enrollments.workshops_enrolled,
    most_recent_attended_workshop.most_recent_attended_workshop,
    
    FROM student_data_with_activities
    LEFT JOIN workshop_enrollments ON workshop_enrollments.academic_semester_c = AT_Id
    LEFT JOIN most_recent_attended_workshop ON most_recent_attended_workshop.academic_semester_c = AT_Id
    )
    
    SELECT
    *
    FROM student_data_with_activities_enrollments