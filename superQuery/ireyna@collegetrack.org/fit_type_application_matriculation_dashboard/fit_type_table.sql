

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

--Table houses Academic Term data to isolate Fall Year 1 (Matriculation). Affiliation join to pull in Fit Type fields
fit_type_matriculation AS
(
SELECT
    matri.contact_id,
    matri.Full_Name__c,
    High_School_Class,
    Site_Text__c AS site_full,
    matri.site_short,
    matri.region AS region_full,
    matri.region_short,
    AT_Name AS academic_term_name,
    AT_Id AS academic_term_id,
    AT_Grade__c,
    student_audit_status__c AS ct_status_at,
    Indicator_Years_Since_HS_Grad_to_Date__c,
    School_Name,
    School_Predominant_Degree_Awarded__c,
    Affiliation_Record_ID__c AS Affiliation_id,
    npe5__Organization__c AS Affiliation_School_id,
    aff.Situational_Fit_Type__c,
    --aff.Situational_Best_Fit_Context__c,
    aff.Fit_Type_Current__c,
    aff.Fit_Type__c AS fit_type_affiliation,
    aff.Best_Fit_Applied__c AS fit_type_start_of_affiliation

--RIGHT join to align AT data with available college application data
    FROM `data-warehouse-289815.sfdc_templates.contact_at_template` AS matri
    RIGHT JOIN fit_type_application AS app
      ON app.contact_id = matri.contact_id

 --Join with Affiliation object to pull in Fit Type (Start of Affiliation) for older students
    LEFT JOIN `data-warehouse-289815.salesforce_raw.npe5__Affiliation__c` AS aff
        ON matri.Affiliation_Record_ID__c = aff.Id

    WHERE matri.Indicator_Completed_CT_HS_Program__c = TRUE
        AND Indicator_Years_Since_HS_Grad_to_Date__c IN (.33,.25) #Fall Year 1 term
        --High_School_Class IN (2016, 2017, 2018, 2019, 2020) 
        --AND matri.RecordTypeId = "01246000000RNnTAAW" #College/University
        --AND Predominant_Degree_Awarded__c = "Predominantly bachelor's-degree granting"
)

SELECT
    app.*,
    matri.*
        EXCEPT (Full_Name__c,High_School_Class,site_full,site_short,region_full,region_short,Contact_Id)

FROM fit_type_application AS app

--Join academic term data (matriculation table) to college application data
LEFT JOIN fit_type_matriculation AS matri
    ON app.Contact_Id = matri.Contact_Id
--WHERE APP.High_School_Class IN (2016, 2017, 2018, 2019, 2020)   

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
    School_Name,
    School_Predominant_Degree_Awarded__c,
    Affiliation_id,
    Affiliation_School_id,
    Situational_Fit_Type__c,
    Fit_Type_Current__c,
    fit_type_affiliation,
    fit_type_start_of_affiliation