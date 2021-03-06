#14,000 records in SFDC vs. 14,085 in superQuery. 8 students have 2 college app records with acceptance & enrollment

CREATE OR REPLACE TABLE `data-studio-260217.fit_type_pipeline.aggregate_data`
OPTIONS
    (
    description= "This table aggregates data across college applications, and academic terms. Incorporates key data on conntact (academics, demographics)"
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
    fit_type_enrolled,
    school_name_accepted,
    fit_type_applied_accepted,
    acceptance_group_accepted
    
    
    --Join with Account object to pull in name of School/College
    FROM `data-studio-260217.fit_type_pipeline.filtered_college_application` AS app
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` AS accnt
        ON app.college_id = accnt.id
    
    LEFT JOIN Fit_Type_Enrolled AS enrolled
        ON enrolled.contact_id = app.contact_id
        
    LEFT JOIN fit_type_acceptances AS acc
      ON acc.contact_id = app.contact_id 
    
    WHERE app.Indicator_Completed_CT_HS_Program__c = TRUE

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
    aff.Fit_Type__c,
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
      
)

SELECT
    app.*
        EXCEPT (school_name_enrolled, school_type_enrolled,fit_type_applied_accepted),
    term.*
        EXCEPT (Full_Name__c,High_School_Class__c,site_full,site_short,region_full,region_short,Contact_Id),
    pell.*
        EXCEPT (High_School_Class),
        
   #matriculation fit type "none" categories (2-yr 4-yr)     
   IF(Fit_Type__c IS NULL, "Not Enrolled", #to account for non-enrolled/NULL Fall year 1
     IF(Fit_Type__c = "None" AND School_Predominant_Degree_Awarded__c = "Predominantly bachelor's-degree granting" AND AT_Enrollment_Status__c <> "Approved Gap Year","None - 4-yr", 
     IF(Fit_Type__c = "None" AND School_Predominant_Degree_Awarded__c = "Predominantly associate's-degree granting" AND AT_Enrollment_Status__c <> "Approved Gap Year","None - 2-yr",
     IF(Fit_Type__c = "None" AND Indicator_College_Matriculation__c = "Approved Gap Year" AND AT_Enrollment_Status__c = "Approved Gap Year", "None",
     IF(Fit_Type__c = "None" AND School_Name IS NULL AND Indicator_College_Matriculation__c <> "Approved Gap Year","Not Enrolled", #to account for erroneous Approved Gap Year entries
     IF(School_Name <> "Global Citizen Year" AND Indicator_College_Matriculation__c <> "Approved Gap Year" AND AT_Enrollment_Status__c = "Approved Gap Year", "Not Enrolled", #to account for erroneous Approved Gap Year entries
     IF(Fit_Type__c = "None" AND School_Predominant_Degree_Awarded__c <> "Predominantly certificate's-degree granting" OR  School_Predominant_Degree_Awarded__c = "Not Classified","Not Enrolled",Fit_Type__c)))))))
     AS fit_type_affiliation,
   
   #to categorize fit type "none". Account for students without admission status indicating enrollment. "None" = tech/trade school, GCY, or erroneous school selection (e.g. graduate school)
   IF(school_name_enrolled IS NULL, "No enrollment or deferment", # sub NULL for 'No enrollment or deferment'. No school to list means no admission status of enrollment
   IF(fit_type_enrolled = "None" AND school_type_enrolled = "4 Year","None - 4-yr", 
   IF(fit_type_enrolled = "None" AND school_type_enrolled = "2 Year","None - 2-yr",
   IF(fit_type_enrolled = "None" AND school_type_enrolled = "2 year","None - 2-yr", #case sensitive - lower-case "y" in "year"
   fit_type_enrolled)))) AS fit_type_enrolled_chart,
   
   #to account for students without any college app records with admission status indicating enrollment. No school to list
    IF(fit_type_enrolled IS NULL, "No enrollment or deferment",school_name_enrolled) as school_name_accepted_enrolled,
   
   #If School_Name_AT is blank, then no Fall AT, and Not Enrolled (unless Global Citizen Year)
   IF(School_Name IS NULL AND Indicator_College_Matriculation__c = "Approved Gap Year" AND AT_Enrollment_Status__c = "Approved Gap Year", "Global Citizen Year",
     IF(School_Name <> "Global Citizen Year" AND Indicator_College_Matriculation__c <> "Approved Gap Year" AND AT_Enrollment_Status__c = "Approved Gap Year", "Not Enrolled",
     IF(School_Name IS NULL, "Not Enrolled",School_Name)))
     AS School_Name_AT,
   
    CASE
      WHEN app.site_short IS NOT NULL THEN "National"
    END AS National,
    
    CASE
        WHEN FA_Req_Expected_Financial_Contribution__c = 0 THEN "Full Pell"
        WHEN FA_Req_Expected_Financial_Contribution__c >= 1 AND FA_Req_Expected_Financial_Contribution__c < Max_EFC THEN "Partial Pell"
        WHEN FA_Req_Expected_Financial_Contribution__c > Max_EFC THEN "Pell Ineligible"
    ELSE "No data"
    END AS pell_efc_bucket,
    
    IF(fit_type_applied_accepted IS NULL, "No acceptance",fit_type_applied_accepted) AS fit_type_accepted
    
FROM fit_type_application AS app

--Join academic term data (matriculation table) to college application data
LEFT JOIN fit_type_matriculation AS term
    ON app.Contact_Id = term.Contact_Id

LEFT JOIN `data-warehouse-289815.external_datasets.pell_eligibility` AS pell
    ON app.High_School_Class = pell.High_School_Class
    
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
    Indicator_Persisted_into_2nd_Year_CT__c,
    Indicator_Persisted_into_Year_2_Wide__c,
    Gender__c,
    Ethnic_background__c,
    Indicator_Low_Income__c,
    First_Generation_FY20__c,
    FA_Req_Expected_Financial_Contribution__c,
    Indicator_Completed_CT_HS_Program__c,
    college_app_id,
    app.college_id,
    account_id,
    school_name_app,
    Type_of_School__c,
    Application_status__c,
    admission_status__c,
    --school_name_accepted_enrolled, #for interactive filtering
    College_Fit_Type_Applied__c,
    Fit_Type_Enrolled__c,
    fit_type_enrolled_chart, #for interactive filtering
    academic_term_name,
    academic_term_id,
    AT_Grade__c,
    ct_status_at,
    Indicator_Years_Since_HS_Grad_to_Date__c,
    Indicator_College_Matriculation__c,
    School_Name,
    School_Name_AT,
    School_Predominant_Degree_Awarded__c,
    AT_Enrollment_Status__c,
    Affiliation_School_id,
    Situational_Fit_Type__c,
    Situational_Best_Fit_Context__c,
    Fit_Type_Current__c,
    Fit_Type__c, #Fit Type (Affiliation) with NULL
    fit_type_affiliation, #no nulls
    fit_type_start_of_affiliation,
    Affiliation_id_at,
    id_aff,
    school_name_accepted_enrolled,
    fit_type_enrolled,
    school_name_accepted,
    fit_type_accepted,
    acceptance_group_accepted,
    Max_EFC, #pell table
    academic_year