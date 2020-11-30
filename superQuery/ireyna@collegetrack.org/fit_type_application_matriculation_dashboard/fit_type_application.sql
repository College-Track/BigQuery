#14,000 records in SFDC vs. 14,085 in superQuery. 8 students have 2 college app records with acceptance & enrollment
#testing fit_type_pipeline_agg with acceptance pipeline added
#stores fit type applied, fit type accepted, fit type enrolled CTE tables

CREATE OR REPLACE TABLE `data-studio-260217.fit_type_pipeline.fit_type_applications`
OPTIONS
    (
    description= "This table stores fit type applied, fit type accepted, fit type enrolled CTE tables"
    )
AS

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

fit_type_acceptances AS #record count = 7837 (matches SFDC)
(
SELECT
    contact_id,
    Full_Name__c,
    IF(app.college_id = '0014600000plKMXAA2',"Global Citizen Year",accnt.name) AS school_name_accepted,
    College_Fit_Type_Applied__c AS fit_type_applied_accepted,
    CASE
        WHEN admission_status__c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred") THEN "Accepted"
        ELSE "Other" #Denied, Conditiional, Undecided, Withdrew Application, Waitlisted
    END AS acceptance_group_accepted
    
FROM `data-studio-260217.fit_type_pipeline.filtered_college_application` AS app
LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt
        ON app.college_id = accnt.id
        
WHERE app.Indicator_Completed_CT_HS_Program__c = TRUE
AND app.admission_status__c IN ("Accepted", "Accepted and Enrolled", "Accepted and Deferred")

),

--Table houses fields on college applications (Fit Type, Application/Admission Status), contact demographics & academics
fit_type_applied AS
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
)

SELECT 
    app.*, 
    acc.school_name_accepted,
    acc.fit_type_applied_accepted,
    acc.acceptance_group_accepted,
    
 #to categorize fit type "none". Account for students without admission status indicating enrollment. "None" = tech/trade school, GCY, or erroneous school selection (e.g. graduate school)
   IF(school_name_enrolled IS NULL, "No enrollment or deferment", # sub NULL for 'No enrollment or deferment'. No school to list means no admission status of enrollment
   IF(fit_type_enrolled = "None" AND school_type_enrolled = "4 Year","None - 4-yr", 
   IF(fit_type_enrolled = "None" AND school_type_enrolled = "2 Year","None - 2-yr",
   IF(fit_type_enrolled = "None" AND school_type_enrolled = "2 year","None - 2-yr", #case sensitive - lower-case "y" in "year"
   fit_type_enrolled)))) AS fit_type_enrolled_chart,
   
   #to account for students without any college app records with admission status indicating enrollment. No school to list
    IF(fit_type_enrolled IS NULL, "No enrollment or deferment",school_name_enrolled) as school_name_accepted_enrolled
    
 FROM fit_type_applied AS app
 LEFT JOIN fit_type_acceptances AS acc
      ON acc.contact_id = app.contact_id 

WHERE High_School_Class >= 2017 #c/o 2017 and above have most completed Fit Type (applied) and Fit Type (enrolled) 
AND Application_status__c = "Applied"
AND Indicator_Completed_CT_HS_Program__c = TRUE

GROUP BY
    contact_id,
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
    Indicator_Persisted_into_2nd_Year_CT__c,
    Indicator_Persisted_into_Year_2_Wide__c,
    Gender__c,
    Ethnic_background__c,
    Indicator_Low_Income__c,
    First_Generation_FY20__c,
    FA_Req_Expected_Financial_Contribution__c,
    EFC_bucket,
    Indicator_Completed_CT_HS_Program__c,
    college_app_id,
    college_id,
    account_id,
    school_name_app,
    school_name_enrolled,
    school_type_enrolled,
    Type_of_School__c,
    Application_status__c,
    admission_status__c,
    College_Fit_Type_Applied__c,
    Fit_Type_Enrolled__c,
    fit_type_enrolled,
    fit_type_enrolled_chart,
    acc.school_name_accepted,
    acc.fit_type_applied_accepted,
    acc.acceptance_group_accepted