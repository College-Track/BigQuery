

CREATE OR REPLACE TABLE `data-studio-260217.fit_type_pipeline.aggregate_data`
OPTIONS
    (
    description= "This table aggregates data across college applications, and academic terms. Incorporates key data on conntact (academics, demographics)"
    )
AS

--Table houses fields on college applications (Fit Type, Application/Admission Status), contact demographics & academics
WITH fit_type_application AS
(
SELECT

#pull in demographics, academics
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
      WHEN GPA_Cumulative__c <= 2.49 THEN "Below 2.5"
      WHEN GPA_Cumulative__c < 2.75 THEN "2.5 - 2.74"
      WHEN GPA_Cumulative__c < 3 THEN "2.75 - 2.99"
      WHEN GPA_Cumulative__c < 3.25 THEN "3.0 - 3.24"
      WHEN GPA_Cumulative__c >= 3.25 THEN "3.25+"
      ELSE "Missing"
    END AS CGPA_11th_bucket,
    Readiness_English_Official__c,
    Readiness_Math_Official__c,
    Readiness_Composite_Off__c,
    CASE
      WHEN Readiness_Composite_Off__c = "1. Ready" THEN "Composite"
      WHEN Readiness_English_Official__c = "1. Ready" THEN "English"
      WHEN Readiness_Math_Official__c = "1. Ready" THEN "Math"
      ELSE "Not/Near Ready"
    END AS ACT_SAT_readiness,
    Gender__c,
    Ethnic_background__c,
    Indicator_Low_Income__c,
    First_Generation_FY20__c,
    Indicator_Completed_CT_HS_Program__c,
    
#pull in college application data
    college_app_id,
    app.college_id,
    accnt.Name AS account_name,
    Type_of_School__c,
    Application_status__c,
    admission_status__c,
     CASE
        WHEN admission_status__c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred") THEN "Acceptance"
        ELSE "N/A"
        END AS acceptance_group,
    College_Fit_Type_Applied__c,
    Fit_Type_Enrolled__c
    
    --Join with Account object to pull in name of School/College
    FROM `data-studio-260217.fit_type_pipeline.filtered_college_application` AS app
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt
        ON app.college_id = accnt.id
    WHERE Indicator_Completed_CT_HS_Program__c = TRUE

),

--Table houses Academic Term data to isolate Fall Year 1 (Matriculation), enrolled in any college (including vocational). Affiliation join to pull in Fit Type fields
fit_type_matriculation AS
(
SELECT
    term.contact_id,
    term.Full_Name__c,
    High_School_Class__c,
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
    AT_Enrollment_Status__c,
    npe5__Organization__c AS Affiliation_School_id,
    aff.Situational_Fit_Type__c,
    aff.Situational_Best_Fit_Context__c,
    aff.Fit_Type_Current__c,
    aff.Fit_Type__c AS fit_type_affiliation,
    term.Fit_Type__c AS fit_type_affiliation_at,
    aff.Best_Fit_Applied__c AS fit_type_start_of_affiliation,
    Affiliation_Record_ID__c AS Affiliation_id_at,
    aff.id AS id_aff

    FROM `data-warehouse-289815.sfdc_templates.contact_at_template` AS term
 --Join with Affiliation object
    FULL JOIN `data-warehouse-289815.salesforce_raw.npe5__Affiliation__c` AS aff
        ON term.Affiliation_Record_ID__c = aff.Id

    WHERE term.Indicator_Completed_CT_HS_Program__c = TRUE
    AND term.Indicator_Years_Since_HS_Grad_to_Date__c IN (.33,.25) #Fall Year 1 term
    AND AT_Enrollment_Status__c IN ("Full-time","Part-time", "Approved Gap Year")
    AND High_School_Class__c IN ("2017", "2018", "2019", "2020") 
        --AND term.RecordTypeId = "01246000000RNnTAAW" #College/University
        --AND Predominant_Degree_Awarded__c = "Predominantly bachelor's-degree granting"
)

SELECT
    app.*,
    term.*
        EXCEPT (Full_Name__c,High_School_Class__c,site_full,site_short,region_full,region_short,Contact_Id)

FROM fit_type_application AS app

--Join academic term data (matriculation table) to college application data
LEFT JOIN fit_type_matriculation AS term
    ON app.Contact_Id = term.Contact_Id
WHERE APP.High_School_Class >= 2017 #c/o 2017 and above have most completed Fit Type (applied) and Fit Type (enrolled) 
AND Application_status__c = "Applied"

GROUP BY
    app.contact_id,
    Full_Name__c,
    College_Track_Status_Name,
    High_School_Class,
    site_full,
    site_short,
    region_full,
    region_short,
    CGPA_11th,
    CGPA_11th_bucket,
    Readiness_English_Official__c,
    Readiness_Math_Official__c,
    Readiness_Composite_Off__c,
    ACT_SAT_readiness,
    Gender__c,
    Ethnic_background__c,
    Indicator_Low_Income__c,
    First_Generation_FY20__c,
    Indicator_Completed_CT_HS_Program__c,
    college_app_id,
    app.college_id,
    account_name,
    Type_of_School__c,
    Application_status__c,
    admission_status__c,
    acceptance_group,
    College_Fit_Type_Applied__c,
    Fit_Type_Enrolled__c,
    academic_term_name,
    academic_term_id,
    AT_Grade__c,
    ct_status_at,
    Indicator_Years_Since_HS_Grad_to_Date__c,
    Indicator_College_Matriculation__c,
    School_Name,
    School_Predominant_Degree_Awarded__c,
    AT_Enrollment_Status__c,
    Affiliation_School_id,
    Situational_Fit_Type__c,
    Situational_Best_Fit_Context__c,
    Fit_Type_Current__c,
    fit_type_affiliation,
    fit_type_affiliation_at,
    fit_type_start_of_affiliation,
    Affiliation_id_at,
    id_aff