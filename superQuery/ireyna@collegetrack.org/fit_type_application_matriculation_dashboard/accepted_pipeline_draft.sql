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
    contact_id AS contact_id_accepted,
    Full_Name__c,
    College_Track_Status_Name,
    High_School_Class,
    site_short,
    region_short,
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
)

SELECT
    accept.*
    
FROM fit_type_acceptances AS accept
INNER JOIN `data-studio-260217.fit_type_pipeline.filtered_college_application` AS filtered
    ON filtered.Contact_Id = Contact_Id_accepted

WHERE Indicator_Completed_CT_HS_Program__c = TRUE
AND acceptance_group_accepted = "Accepted"
AND filtered.High_School_Class >= 2017 #c/o 2017 and above have most completed Fit Type (applied) and Fit Type (enrolled) 
AND Application_status__c = "Applied"

GROUP BY
    contact_id_accepted,
    accept.Full_Name__c,
    accept.College_Track_Status_Name,
    accept.High_School_Class,
    accept.site_short,
    accept.region_short,
    accept.college_app_id,
    accept.school_name_accepted,
    accept.admission_status__c,
    acceptance_group_accepted,
    College_Fit_Type_Applied__c