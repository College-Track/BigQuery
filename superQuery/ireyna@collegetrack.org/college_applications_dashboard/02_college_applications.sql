#table 2
#Applicaiton prgoress, acceptance, and admission/enrollment data
/*CREATE OR REPLACE TABLE `data-studio-260217.college_applications.02_college_applications`
OPTIONS
    (
    description= "02 Applicaiton prgoress, acceptance, and admission/enrollment data. Second table."
    )
AS*/

WITH
acceptance_data AS 
(
SELECT
    student_c AS contact_id_accepted, #contact id
    accnt.name AS school_name_accepted,
    app.id AS college_accepted_app_id,
    CASE 
        WHEN admission_status_c = "Accepted" OR admission_status_c = "Accepted and Enrolled" OR admission_status_c = "Accepted and Deferred" 
        THEN 1
        ELSE 0
    END AS accepted,
    
    CASE
        WHEN admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")
        THEN  accnt.name
    END AS school_name_enrolled,
    
    CASE
        WHEN admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")
        THEN app.id
    END AS school_name_enrolled_record_id,
    
    CASE 
        WHEN (College_Fit_Type_Applied_c IS NULL OR application_status_c IS NULL) THEN 'Has Not Applied'
        WHEN ((admission_status_c = "Accepted") AND (College_Fit_Type_Applied_c = "None") AND (app.Predominant_Degree_Awarded_c IN ("Predominantly associate's-degree granting", "Predominantly certificate-degree granting", "Not classified")))  THEN "None - 2-year or technical"
        WHEN ((admission_status_c = "Accepted") AND (College_Fit_Type_Applied_c = "None") AND (app.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting")) THEN "None - 4-year"
        WHEN admission_status_c = "Accepted" THEN  College_Fit_Type_Applied_c
        WHEN ((admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")) AND (fit_type_enrolled_c = "None") AND (app.Predominant_Degree_Awarded_c IN ("Predominantly associate's-degree granting", "Predominantly certificate-degree granting", "Not classified")))  THEN "None - 2-year or technical"
        WHEN ((admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")) AND (fit_type_enrolled_c = "None") AND (app.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting")) THEN "None - 4-year"
        ELSE fit_type_enrolled_c
    END AS fit_type_accepted
    
FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app
LEFT JOIN `data-warehouse-289815.salesforce.account` AS accnt
        ON app.College_University_c = accnt.id
        
WHERE app.admission_status_c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred")
),

--combine accetpance and admission data to college application data
acceptance_and_admission AS (
SELECT
    app.name,
    app.Student_c AS contact_id_app_table, # With Applications on Application Progress (Overview) table. Pulls in all students with apps regardless of Application Status
    app.application_status_c AS application_status_app_table, 
        (SELECT app2.student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app2
        WHERE app.student_c=app2.student_c
        AND application_status_c = "Applied"
        group by app2.student_c
        ) AS  contact_id_applied_status, #For metric on "Admissions" Page of Dashboard. Will only pull in students with Status of Applied.
        
        (SELECT app2.id
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app2
        WHERE app.id=app2.id
        AND application_status_c = "Applied"
        group by app2.id
        ) AS  college_app_id_applied,
        
        (SELECT app2.student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app2
        WHERE app.student_c=app2.student_c
        AND application_status_c = "Applied"
        AND admission_status_c IS NULL
        group by app2.student_c
        ) AS  contact_id_applied_no_admission_status,
        /*
        (SELECT app2.student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app2
        WHERE app2.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting" AND app.student_c=app2.student_c
        AND application_status_c = "Applied"
        group by app2.student_c
        ) AS  contact_id_applied_4_year,
        */
        (SELECT app2.college_fit_type_applied_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app2
        WHERE application_status_c = "Applied"
        AND app.student_c=app2.student_c
        AND app.id=app2.id
        group by app2.college_fit_type_applied_c, app2.student_c
        ) AS  college_fit_type_applied_tight,
        
        (SELECT acc2.school_name_accepted
        FROM `acceptance_data`AS acc2
        WHERE admission_status_c IN ("Accepted","Accepted and Enrolled", "Accepted and Deferred")
        AND acc2.contact_id_accepted=app.student_c
        AND acc2.college_accepted_app_id=app.id
        group by acc2.school_name_accepted, acc2.college_accepted_app_id
        ) AS school_name_accepted_tight,
        
         (SELECT acc2.fit_type_accepted
        FROM `acceptance_data`AS acc2
        WHERE admission_status_c IN ("Accepted","Accepted and Enrolled", "Accepted and Deferred")
        AND acc2.contact_id_accepted=app.student_c
        AND acc2.college_accepted_app_id=app.id
        group by acc2.fit_type_accepted, acc2.college_accepted_app_id
        ) AS  fit_type_accepted_tight,
        /*
        (SELECT app2.student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app2
        WHERE app2.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting" AND app.student_c=app2.student_c
        AND app2.admission_status_c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred")
        group by app2.student_c
        ) AS  contact_id_accepted_4_year, #to use in formula in final join
        
        (SELECT app2.student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app2
        WHERE app2.admission_status_c = "Accepted and Enrolled"
        AND app.student_c=app2.student_c
        group by app2.student_c
        ) AS  contact_id_admissions,
        */
         (SELECT app2.student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app2
        WHERE app2.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting" AND app.student_c=app2.student_c
        AND app2.admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")
        group by app2.student_c
        ) AS  contact_id_enrolled_4_year,
        /*
          (SELECT app2.student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app2
        WHERE app.student_c=app2.student_c
        AND app2.admission_status_c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred")
        AND app.id = app2.id
        group by app2.student_c
        ) AS  contact_id_accepted,
        */
        (SELECT app2.student_c
        FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app2
        WHERE app.student_c=app2.student_c
        AND app2.admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")
        group by app2.student_c
        ) AS  contact_id_enrolled,
        
    app.Type_of_School_c as school_type_applied,
    accnt.name AS college_name_on_app_for_case_statement,
    app.College_University_c AS app_college_id, #college id
    app.admission_status_c,
    app.Award_Letter_c,
    app.CSS_Profile_Required_c,
    app.CSS_Profile_c,
    CASE
        WHEN app.CSS_Profile_c IS NULL THEN 'Missing Status'
        ELSE app.CSS_Profile_c
    END AS CSS_profile_status,
    app.College_Fit_Type_Applied_c,
    app.Enrollment_Deposit_c,
    app.housing_application_c,
    app.School_s_Financial_Aid_Form_Required_c, #yes/no
    app.School_Financial_Aid_Form_Status_c,
    CASE 
        WHEN app.School_Financial_Aid_Form_Status_c IS NULL THEN 'Missing Status'
        ELSE app.School_Financial_Aid_Form_Status_c
    END AS School_Financial_Aid_Form_Status,
    
    app.id as college_app_id,
    app.Predominant_Degree_Awarded_c,
    app.Type_of_School_c,
    app.Situational_Fit_Type_c,
    app.Verification_Status_c,
    app.fit_type_enrolled_c,
    
    CASE
        WHEN ((College_Fit_Type_Applied_c = "None") AND (app.Predominant_Degree_Awarded_c IN ("Predominantly associate's-degree granting", "Predominantly certificate-degree granting", "Not classified")))  THEN "None - 2-year or technical"
        WHEN ((College_Fit_Type_Applied_c = "None") AND (app.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting")) THEN "None - 4-year"
        WHEN College_Fit_Type_Applied_c IS NULL THEN 'Has Not Yet Applied'
    END AS College_Fit_Type_Applied_sort,
    
    CASE 
        WHEN app.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting" THEN "4-year"
        WHEN app.Predominant_Degree_Awarded_c = "Predominantly associate's-degree granting" THEN "2-year"
        WHEN app.Predominant_Degree_Awarded_c IN ("Predominantly certificate-degree granting", "Not classified") THEN "Vocational or not Classified"
    END AS school_type,  
    
    #accepted_data 
    contact_id_accepted,
    school_name_accepted,
    college_accepted_app_id,
    accepted,
    fit_type_accepted,
    school_name_enrolled,
    school_name_enrolled_record_id
    
FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app
LEFT JOIN `data-warehouse-289815.salesforce.account` AS accnt
        ON app.College_University_c = accnt.id  
LEFT JOIN acceptance_data AS acceptance
    ON app.student_c = acceptance.contact_id_accepted
)
SELECT 
    filtered_data.*,
    college_application_data.*,
    CASE WHEN 
        college_application_data.college_name_on_app_for_case_statement IS NULL THEN 'No College Application'
        ELSE college_application_data.college_name_on_app_for_case_statement 
    END AS college_name_applied_tight, #Tigher College Name filter. Top filter on Admissions & Enrollment page
    
    CASE 
        WHEN college_application_data.college_app_id = college_application_data.college_app_id_applied
        THEN college_application_data.contact_id_applied_status
        END AS contact_id_applied_to_college_listed,
    
    CASE 
        WHEN college_application_data.college_name_on_app_for_case_statement = college_application_data.school_name_accepted
        AND college_application_data.college_app_id = college_application_data.college_accepted_app_id
        THEN contact_id_accepted
        END AS contact_id_accepted_to_college_listed,
    
    CASE 
        WHEN college_application_data.college_name_on_app_for_case_statement = college_application_data.school_name_enrolled
        AND college_application_data.college_app_id = college_application_data.school_name_enrolled_record_id
        THEN contact_id_accepted
        END AS contact_id_enrolled_to_college_listed,

        
    CASE
        WHEN application_status = "Prospect" THEN 1
        WHEN application_status = "In Progress" THEN 2
        WHEN application_status = "Applied" THEN 3
        WHEN application_status = "Accepted" THEN 4
        WHEN application_status = "No College Application" THEN 5
        ELSE 6
    END AS sort_helper_app_status, 
    
    CASE
        WHEN ((college_application_data.College_Fit_Type_Applied_c = "None") AND (college_application_data.Predominant_Degree_Awarded_c IN ("Predominantly associate's-degree granting", "Predominantly certificate-degree granting", "Not classified")))  THEN "None - 2-year or technical"
        WHEN ((College_application_data.college_Fit_Type_Applied_c = "None") AND (college_application_data.Predominant_Degree_Awarded_c = "Predominantly bachelor's-degree granting")) THEN "None - 4-year"
        WHEN application_status = 'No College Application' THEN 'No College Application'
        WHEN college_application_data.College_Fit_Type_Applied_c IS NULL THEN 'Has Not Yet Applied'
        ELSE college_application_data.College_Fit_Type_Applied_c
    END AS College_Fit_Type_Applied,
    
    CASE
        WHEN college_application_data.College_Fit_Type_Applied_sort  = "Best Fit" THEN 1
        WHEN college_application_data.College_Fit_Type_Applied_sort  = "Good Fit" THEN 2
        WHEN college_application_data.College_Fit_Type_Applied_sort  = "Local Affordable" THEN 3
        WHEN college_application_data.College_Fit_Type_Applied_sort  = "None - 4-year" THEN 4
        WHEN college_application_data.College_Fit_Type_Applied_sort  = "None - 2-year or technical" THEN 5
        WHEN application_status = 'No College Application' THEN 7
        WHEN application_status <> "Applied" THEN 6
    END AS sort_helper_app_by_fit_type
  
FROM `data-studio-260217.college_applications.01_college_applications` AS filtered_data
LEFT JOIN acceptance_and_admission AS college_application_data
    ON filtered_data.contact_id = college_application_data.contact_id_app_table
