#table 3
#Affordable colleges, No Applications, No Enrollment
CREATE OR REPLACE TABLE `data-studio-260217.college_applications.03_college_applications`
OPTIONS
    (
    description= "03 Affordable colleges, No Applications, No Enrollment, Table 3."
    )
AS
WITH
affordable_colleges AS
(SELECT 
    student_c AS student_affordable_colleges_table,
    CASE    
        WHEN application_status_c = "Applied"
        AND College_Fit_Type_Applied_c IN ("Best Fit","Good Fit","Local Affordable")
        THEN student_c
        END AS contact_id_applied_affordable, --For metric on "Admissions" Page of Dashboard. Pulls students that applied to Affordable college.
        
    CASE    
        WHEN admission_status_c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred")
        AND College_Fit_Type_Applied_c IN ("Best Fit","Good Fit","Local Affordable")
        THEN student_c
        END AS contact_id_accepted_affordable_option,
    
    CASE    
        WHEN admission_status_c IN ("Accepted and Enrolled", "Accepted and Deferred")
        AND fit_type_enrolled_c  IN ("Best Fit","Good Fit","Local Affordable", "Situational")
        THEN student_c
        END AS contact_id_enrolled_affordable_option
FROM `data-warehouse-289815.salesforce_clean.college_application_clean`AS app
),

--Identify students who have not applied
no_application_status AS
(
SELECT  
    C.contact_id AS  contact_id_status_not_applied 
FROM `data-studio-260217.college_applications.01_college_applications` AS C
LEFT JOIN `data-studio-260217.college_applications.02_college_applications` 
ON C.contact_id = contact_id_applied_status
WHERE contact_id_applied_status IS NULL
),

--Identify students who have not enrolled
no_enrollment AS(
SELECT  
    C.contact_id AS contact_id_not_enrolled
FROM  `data-studio-260217.college_applications.01_college_applications` AS C
LEFT JOIN `data-studio-260217.college_applications.02_college_applications`
ON C.contact_id = contact_id_enrolled
WHERE contact_id_enrolled IS NULL
)

SELECT DISTINCT
     
    reporting_group.*,
    affordable_colleges.*,
    no_application_status.*,
    no_enrollment.*
    
FROM `data-studio-260217.college_applications.01_college_applications`  AS reporting_group
LEFT JOIN no_application_status AS no_application_status
    ON reporting_group.contact_id = no_application_status.contact_id_status_not_applied
LEFT JOIN no_enrollment AS no_enrollment
    ON reporting_group.contact_id = no_enrollment.contact_id_not_enrolled
LEFT JOIN affordable_colleges AS affordable_colleges 
    ON reporting_group.contact_id = affordable_colleges.student_affordable_colleges_table