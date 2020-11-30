WITH fit_type_enrolled AS
(
SELECT 
    contact_id,
    Full_Name__c,
    
#college application data
    college_id,
    IF(app.college_id = '0014600000plKMXAA2',"Global Citizen Year",accnt.name) AS school_name_enrolled,
    Fit_Type_Enrolled__c AS fit_type_enrolled,
    Type_of_School__c as school_type_enrolled,
    
    FROM `data-studio-260217.fit_type_pipeline.filtered_college_application` AS app
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt
        ON app.college_id = accnt.id
    WHERE Indicator_Completed_CT_HS_Program__c = TRUE    
    AND admission_status__c IN ("Accepted and Enrolled", "Accepted and Deferred")
),

--Table houses fields on college applications (Fit Type, Application/Admission Status), contact demographics & academics
fit_type_application AS
(
SELECT

#demographics, academic data
    app.contact_id,
    app.Full_Name__c,
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
    Indicator_Persisted_into_2nd_Year_CT__c,
    Indicator_Persisted_into_Year_2_Wide__c,
    Gender__c,
    Ethnic_background__c,
    Indicator_Low_Income__c,
    First_Generation_FY20__c,
    FA_Req_Expected_Financial_Contribution__c,
    CASE
      WHEN FA_Req_Expected_Financial_Contribution__c = 0 THEN "0 (Full Pell)"
      WHEN FA_Req_Expected_Financial_Contribution__c >0 AND FA_Req_Expected_Financial_Contribution__c <=5711  THEN "1 - 5711 (Partial Pell)"
      WHEN FA_Req_Expected_Financial_Contribution__c > 5711 THEN ">5711 (Pell Ineligible)"
      ELSE "Missing"
    END AS EFC_bucket,
    Indicator_Completed_CT_HS_Program__c,
    
#college application data
    college_app_id,
    app.college_id,
    accnt.id AS account_id,
    IF(app.college_id = '0014600000plKMXAA2',"Global Citizen Year",accnt.name) AS school_name_app,
    school_name_enrolled,
    school_type_enrolled,
    Type_of_School__c,
    Application_status__c,
    app.admission_status__c,
    CASE
        WHEN admission_status__c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred") THEN "Accepted"
        WHEN admission_status__c = "Denied" THEN "Denied"
        WHEN admission_status__c = "Coniditional" THEN "Conditional"
        WHEN admission_status__c = "Undecided" THEN "Undecided"
        WHEN admission_status__c = "Withdrew Application" THEN "Withdrew Application"
        WHEN admission_status__c = "Wait-listed" THEN "Waitlisted"
        WHEN admission_status__c IS NULL THEN "No data"
        ELSE "No data"
        END AS acceptance_group,
    College_Fit_Type_Applied__c,
    app.Fit_Type_Enrolled__c,
    fit_type_enrolled
    
    --Join with Account object to pull in name of School/College
    FROM `data-studio-260217.fit_type_pipeline.filtered_college_application` AS app
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt
        ON app.college_id = accnt.id
    
    LEFT JOIN Fit_Type_Enrolled AS enrolled
        ON enrolled.contact_id = app.contact_id
        
    WHERE app.Indicator_Completed_CT_HS_Program__c = TRUE