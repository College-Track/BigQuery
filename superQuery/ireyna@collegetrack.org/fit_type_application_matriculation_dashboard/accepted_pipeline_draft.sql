#the fit_type_pipeline_agg table will show a record count = 7870 in superquery vs. record count in SFDC = 7837. 33 dupe records due to the 8 students with multiple entries of accepted & enrolled

CREATE OR REPLACE TABLE `data-studio-260217.fit_type_pipeline.fit_type_accepted`
OPTIONS
    (
    description= "This table aggregates students that were accepted to a college from college applications. Incorporates key data on conntact (academics, demographics)"
    )
AS

WITH fit_type_acceptances AS #record count = 7837 (matches SFDC)

(
SELECT
    contact_id,
    Full_Name__c,
    college_app_id,
    IF(app.college_id = '0014600000plKMXAA2',"Global Citizen Year",accnt.name) AS school_name_accepted,
    College_Fit_Type_Applied__c,
    admission_status__c,
    CASE
        WHEN admission_status__c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred") THEN "Accepted"
        WHEN admission_status__c = "Denied" THEN "Denied"
        WHEN admission_status__c = "Coniditional" THEN "Conditional"
        WHEN admission_status__c = "Undecided" THEN "Undecided"
        WHEN admission_status__c = "Withdrew Application" THEN "Withdrew Application"
        WHEN admission_status__c = "Wait-listed" THEN "Waitlisted"
        ELSE "No data"
    END AS acceptance_group_accepted
    
FROM `data-studio-260217.fit_type_pipeline.filtered_college_application` AS app
LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt
        ON app.college_id = accnt.id
),

fit_type_application AS
(
SELECT

#demographics, academic data
    app.contact_id,
    app.Full_Name__c,
    app.College_Track_Status_Name,
    app.High_School_Class,
    app.site_short,
    app.region_short,
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
    app.college_id,
    IF(app.college_id = '0014600000plKMXAA2',"Global Citizen Year",accnt.name) AS school_name_app,
    Type_of_School__c,
    Fit_Type_Enrolled__c,

#college acceptances data
    acc.college_app_id,
    school_name_accepted,
    acceptance_group_accepted,
    app.admission_status__c
    
    --Join with Account object to pull in name of School/College
    FROM `data-studio-260217.fit_type_pipeline.filtered_college_application` AS app
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt
        ON app.college_id = accnt.id
    
    LEFT JOIN fit_type_acceptances AS acc
      ON acc.contact_id = app.contact_id 
        
    WHERE app.Indicator_Completed_CT_HS_Program__c = TRUE

)

SELECT
    app.*,
     CASE
      WHEN app.site_short IS NOT NULL THEN "National"
    END AS National
    
FROM fit_type_application AS app
INNER JOIN `data-studio-260217.fit_type_pipeline.filtered_college_application` AS filtered
    ON filtered.Contact_Id = app.Contact_Id

WHERE app.Indicator_Completed_CT_HS_Program__c = TRUE
AND acceptance_group_accepted = "Accepted"
AND filtered.High_School_Class >= 2017 #c/o 2017 and above have most completed Fit Type (applied) and Fit Type (enrolled) 
AND Application_status__c = "Applied"

GROUP BY
    contact_id,
    app.Full_Name__c,
    app.College_Track_Status_Name,
    app.High_School_Class,
    app.site_short,
    app.region_short,
    app.college_app_id,
    college_id,
    school_name_app,
    school_name_accepted,
    app.admission_status__c,
    acceptance_group_accepted,
    College_Fit_Type_Applied__c,
    CGPA_11th,
    CGPA_11th_bucket,
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
    EFC_bucket,
    Indicator_Completed_CT_HS_Program__c,
     Type_of_School__c,
    Fit_Type_Enrolled__c