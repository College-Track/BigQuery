With overview_data AS
(
SELECT
--basic contact info & demos
    Contact_Id,
    GAS_Name,
    site_abrev AS Site,
    site_short,
    site_sort,
    region_abrev AS region,
    CASE
        WHEN Gender_c IN ("Decline to State","Other") THEN "Other"
        ELSE Gender_c
    END AS Gender_c, 
    CASE
        WHEN Ethnic_background_c = "Decline to State" THEN "Missing"
        Else Ethnic_background_c
    END AS Ethnic_background_c,
    CASE
        WHEN indicator_high_risk_for_dismissal_c = TRUE THEN 1
        ELSE 0
        END AS indicator_high_risk_dismissal,
    
    --current AT attendance & gpa data
    CASE
        WHEN AT_Grade_c = '12th Grade' Then '12th'
        WHEN AT_Grade_c = '11th Grade' Then '11th'
        WHEN AT_Grade_c = '10th Grade' Then '10th'
        WHEN AT_Grade_c = '9th Grade' Then '9th'
        ELSE 'na'
    END AS grade,    
    CASE
        WHEN indicator_prev_gpa_below_2_75_c = TRUE AND indicator_sem_attendance_below_65_c = TRUE THEN 1
        ELSE 0 
        END AS GPA_Attendance_count,
    CASE
        WHEN indicator_prev_gpa_below_2_75_c = TRUE AND indicator_sem_attendance_below_65_c = FALSE THEN 1
        ELSE 0
        END AS GPA_Only_count,
    CASE
        WHEN indicator_prev_gpa_below_2_75_c = FALSE AND indicator_sem_attendance_below_65_c = TRUE THEN 1
        ELSE 0
        END AS Attendance_Only_count,
    CASE
        WHEN indicator_prev_gpa_below_2_75_c = FALSE AND indicator_sem_attendance_below_65_c = FALSE THEN 1
        ELSE 0
        END AS no_intervention_count,
    CASE
        WHEN indicator_student_on_intervention_c = TRUE THEN 1
        Else 0
    End AS intervention_AT,
    attendance_bucket_current_at,
    sort_attendance_bucket,
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE current_as_c = TRUE
    AND college_track_status_c IN ("11A", "12A")
    )
    
    SELECT 
    GAS_Name,
    Site,
    site_short,
    site_sort,
    region,
    grade,
    Gender_c,
    Ethnic_background_c,
    intervention_AT,
    indicator_high_risk_dismissal,
    attendance_bucket_current_at,
    sort_attendance_bucket,
    COUNT(Contact_Id) AS student_count,
    sum(intervention_AT) AS intervention_AT_count,
    sum(indicator_high_risk_dismissal) AS high_risk_count,
    sum(GPA_Attendance_count) AS gpa_attendance_count,
    sum(GPA_Only_count) AS gpa_only_count,
    sum(Attendance_Only_count) AS attendance_only_count,
    sum(no_intervention_count) AS no_intervention_count,
    
    
    FROM overview_data
    GROUP BY
    GAS_Name,
    Site,
    site_short,
    site_sort,
    region,
    grade,
    Gender_c,
    Ethnic_background_c,
    intervention_AT,
    indicator_high_risk_dismissal,
    attendance_bucket_current_at,
    sort_attendance_bucket
    
    
    