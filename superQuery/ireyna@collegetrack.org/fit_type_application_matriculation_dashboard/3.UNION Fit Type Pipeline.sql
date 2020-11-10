CREATE OR REPLACE TABLE `data-studio-260217.fit_type_pipeline.pipeline_data`
OPTIONS
    (
    description= "This is a UNION ALL table that aggregates Fit Type categories based on its phase within the pipeline (application, enrollment, matriculated). The base of this table is the filtered_college_application and contact_at_template"
    )
AS

WITH fit_type_application AS
(
SELECT

#demographics, academics
    contact_id,
    Full_Name__c,
    College_Track_Status_Name,
    High_School_Class,
    Site_Text__c AS site_full,
    site_short,
    region AS region_full,
    region_short,
    GPA_Cumulative__c AS CGPA_11th,
    CASE
      WHEN GPA_Cumulative__c < 3 THEN "Below 3.0"
      WHEN GPA_Cumulative__c < 3.25 THEN "3.0 - 3.24"
      WHEN GPA_Cumulative__c >= 3.25 THEN "3.25+"
      ELSE "Missing"
    END AS CGPA_11th_bucket,
    Readiness_English_Official__c,
    Readiness_Math_Official__c,
    Readiness_Composite_Off__c,
    Gender__c,
    Ethnic_background__c,
    Indicator_Low_Income__c,
    First_Generation_FY20__c,
    Indicator_Completed_CT_HS_Program__c,
    
#college application data
    college_app_id,
    app.college_id,
    accnt.Name AS account_name,
    Type_of_School__c,
    Application_status__c,
    admission_status__c,
     CASE
        WHEN Application_status__c = "Applied" THEN "Applied"
        ELSE "N/A"
        END AS pipeline_category,
    College_Fit_Type_Applied__c,
    Fit_Type_Enrolled__c,

#academic term data
    academic_term_id,
    academic_term_name,
    AT_Grade__c,
    ct_status_at,
    Indicator_Years_Since_HS_Grad_to_Date__c,
    School_Name,
    School_Predominant_Degree_Awarded__c,
    Indicator_College_Matriculation__c
    
    --Join with Account object to pull in name of School/College
    FROM `data-studio-260217.fit_type_pipeline.filtered_college_application` AS app
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt
        ON app.college_id = accnt.id
        
    WHERE Indicator_Completed_CT_HS_Program__c = TRUE
    AND Application_status__c = "Applied"
    AND High_School_Class >= 2017
    AND Indicator_Years_Since_HS_Grad_to_Date__c IN (.33,.25) #Fall Year 1 term

),

fit_type_enrolled AS
(
SELECT

#demographics, academics
    contact_id,
    Full_Name__c,
    College_Track_Status_Name,
    High_School_Class,
    Site_Text__c AS site_full,
    site_short,
    region AS region_full,
    region_short,
    GPA_Cumulative__c AS CGPA_11th,
    CASE
      WHEN GPA_Cumulative__c < 3 THEN "Below 3.0"
      WHEN GPA_Cumulative__c < 3.25 THEN "3.0 - 3.24"
      WHEN GPA_Cumulative__c >= 3.25 THEN "3.25+"
      ELSE "Missing"
    END AS CGPA_11th_bucket,
    Readiness_English_Official__c,
    Readiness_Math_Official__c,
    Readiness_Composite_Off__c,
    Gender__c,
    Ethnic_background__c,
    Indicator_Low_Income__c,
    First_Generation_FY20__c,
    Indicator_Completed_CT_HS_Program__c,
    
#college application data
    college_app_id,
    app.college_id,
    accnt.Name AS account_name,
    Type_of_School__c,
    Application_status__c,
    admission_status__c,
     CASE
        WHEN admission_status__c = "Accepted and Enrolled" THEN "Enrolled"
        ELSE "N/A"
        END AS pipeline_category,
    College_Fit_Type_Applied__c,
    Fit_Type_Enrolled__c,

#academic term data
    academic_term_id,
    academic_term_name,
    AT_Grade__c,
    ct_status_at,
    Indicator_Years_Since_HS_Grad_to_Date__c,
    School_Name,
    School_Predominant_Degree_Awarded__c,
    Indicator_College_Matriculation__c,
    
    --Join with Account object to pull in name of School/College
    FROM `data-studio-260217.fit_type_pipeline.filtered_college_application` AS app
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt
        ON app.college_id = accnt.id
    WHERE Indicator_Completed_CT_HS_Program__c = TRUE
    AND Application_status__c = "Applied"
    AND admission_status__c = "Accepted and Enrolled"
    AND High_School_Class >= 2017
    AND Indicator_Years_Since_HS_Grad_to_Date__c IN (.33,.25) #Fall Year 1 term

),

--Table houses Academic Term data to isolate Fall Year 1 (Matriculation). Affiliation join to pull in Fit Type fields
fit_type_matriculation AS
(
SELECT

#academic and demo data
    GPA_Cumulative__c AS CGPA_11th,
    CASE
      WHEN GPA_Cumulative__c < 3 THEN "Below 3.0"
      WHEN GPA_Cumulative__c < 3.25 THEN "3.0 - 3.24"
      WHEN GPA_Cumulative__c >= 3.25 THEN "3.25+"
      ELSE "Missing"
    END AS CGPA_11th_bucket,
    Readiness_English_Official__c,
    Readiness_Math_Official__c,
    Readiness_Composite_Off__c,
    Gender__c,
    Ethnic_background__c,
    Indicator_Low_Income__c,
    First_Generation_FY20__c,
    Indicator_Completed_CT_HS_Program__c,
    
#academic term data    
    term.contact_id,
    term.Full_Name__c,
    CAST(High_School_Class__c AS INT64) AS High_School_Class,
    Site_Text__c AS site_full,
    term.site_short,
    term.region AS region_full,
    term.region_short,
    AT_Name AS academic_term_name,
    term.AT_Id AS academic_term_id,
    AT_Grade__c,
    student_audit_status__c AS ct_status_at,
    Indicator_Years_Since_HS_Grad_to_Date__c,
    Indicator_College_Matriculation__c,
    School_Name,
    School_Predominant_Degree_Awarded__c,
    npe5__Organization__c AS Affiliation_School_id,
    aff.Situational_Fit_Type__c,
    aff.Situational_Best_Fit_Context__c,
    aff.Fit_Type_Current__c,
    aff.Fit_Type__c AS fit_type_affiliation,
    term.Fit_Type__c AS fit_type_affiliation_at,
    aff.Best_Fit_Applied__c AS fit_type_start_of_affiliation,
    Affiliation_Record_ID__c AS Affiliation_id_at,
    aff.id AS id_aff,
    CASE
        WHEN AT_Enrollment_Status__c IN ("Full-time","Part-time", "Approved Gap Year") THEN "Matriculation"
        ELSE "N/A"
        END AS pipeline_category,

    FROM `data-warehouse-289815.sfdc_templates.contact_at_template` AS term
 --Join with Affiliation object
    FULL JOIN `data-warehouse-289815.salesforce_raw.npe5__Affiliation__c` AS aff
        ON term.Affiliation_Record_ID__c = aff.Id

    WHERE term.Indicator_Completed_CT_HS_Program__c = TRUE
    AND term.Indicator_Years_Since_HS_Grad_to_Date__c IN (.33,.25) #Fall Year 1 term
    AND AT_Enrollment_Status__c IN ("Full-time","Part-time", "Approved Gap Year")
    AND High_School_Class__c IN ("2017", "2018", "2019", "2020") 
        --AND matri.RecordTypeId = "01246000000RNnTAAW" #College/University
        --AND Predominant_Degree_Awarded__c = "Predominantly bachelor's-degree granting"
)

SELECT contact_id,
    Full_Name__c,
    High_School_Class,
    site_full,
    site_short,
    region_full,
    CGPA_11th_bucket,
    Readiness_English_Official__c,
    Readiness_Math_Official__c,
    Readiness_Composite_Off__c,
    Gender__c,
    Ethnic_background__c,
    Indicator_Low_Income__c,
    First_Generation_FY20__c,
    Indicator_Completed_CT_HS_Program__c,
    academic_term_id,
    academic_term_name,
    AT_Grade__c,
    ct_status_at,
    Indicator_Years_Since_HS_Grad_to_Date__c,
    School_Name,
    School_Predominant_Degree_Awarded__c,
    Indicator_College_Matriculation__c,
    College_Fit_Type_Applied__c AS Fit_Type, #sourced from College Application
    pipeline_category
FROM fit_type_application

UNION ALL

SELECT contact_id,
    Full_Name__c,
    High_School_Class,
    site_full,
    site_short,
    region_full,
    CGPA_11th_bucket,
    Readiness_English_Official__c,
    Readiness_Math_Official__c,
    Readiness_Composite_Off__c,
    Gender__c,
    Ethnic_background__c,
    Indicator_Low_Income__c,
    First_Generation_FY20__c,
    Indicator_Completed_CT_HS_Program__c,
    academic_term_id,
    academic_term_name,
    AT_Grade__c,
    ct_status_at,
    Indicator_Years_Since_HS_Grad_to_Date__c,
    School_Name,
    School_Predominant_Degree_Awarded__c,
    Indicator_College_Matriculation__c,
    Fit_Type_Enrolled__c AS Fit_Type, #sourced from College Application
    pipeline_category
FROM fit_type_enrolled

UNION ALL

SELECT contact_id,
    Full_Name__c,
    High_School_Class,
    site_full,
    site_short,
    region_full,
    CGPA_11th_bucket,
    Readiness_English_Official__c,
    Readiness_Math_Official__c,
    Readiness_Composite_Off__c,
    Gender__c,
    Ethnic_background__c,
    Indicator_Low_Income__c,
    First_Generation_FY20__c,
    Indicator_Completed_CT_HS_Program__c,
    academic_term_id,
    academic_term_name,
    AT_Grade__c,
    ct_status_at,
    Indicator_Years_Since_HS_Grad_to_Date__c,
    School_Name,
    School_Predominant_Degree_Awarded__c,
    Indicator_College_Matriculation__c,
    fit_type_affiliation AS Fit_Type, #sourced from Affiliation
    pipeline_category
FROM fit_type_matriculation