
CREATE OR REPLACE TABLE `data-studio-260217.fit_type_pipeline.fit_type_matriculation`
OPTIONS
    (
    description= "This table pulls academic term Fall Year 1 data. Joins with Affiliation Object"
    )
AS

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
    --term.Fit_Type__c AS fit_type_affiliation_at,
    aff.Best_Fit_Applied__c AS fit_type_start_of_affiliation,
    Affiliation_Record_ID__c AS Affiliation_id_at,
    aff.id AS id_aff,
    
    #matriculation fit type "none" categories (2-yr 4-yr)     
   IF(aff.Fit_Type__c IS NULL, "Not Enrolled", #to account for non-enrolled/NULL Fall year 1
     IF(aff.Fit_Type__c = "None" AND School_Predominant_Degree_Awarded__c = "Predominantly bachelor's-degree granting" AND AT_Enrollment_Status__c <> "Approved Gap Year","None - 4-yr", 
     IF(aff.Fit_Type__c = "None" AND School_Predominant_Degree_Awarded__c = "Predominantly associate's-degree granting" AND AT_Enrollment_Status__c <> "Approved Gap Year","None - 2-yr",
     IF(aff.Fit_Type__c = "None" AND Indicator_College_Matriculation__c = "Approved Gap Year" AND AT_Enrollment_Status__c = "Approved Gap Year", "None",
     IF(aff.Fit_Type__c = "None" AND School_Name IS NULL AND Indicator_College_Matriculation__c <> "Approved Gap Year","Not Enrolled", #to account for erroneous Approved Gap Year entries
     IF(School_Name <> "Global Citizen Year" AND Indicator_College_Matriculation__c <> "Approved Gap Year" AND AT_Enrollment_Status__c = "Approved Gap Year", "Not Enrolled", #to account for erroneous Approved Gap Year entries
     IF(aff.Fit_Type__c = "None" AND School_Predominant_Degree_Awarded__c <> "Predominantly certificate's-degree granting" OR  School_Predominant_Degree_Awarded__c = "Not Classified","Not Enrolled",aff.Fit_Type__c)))))))
     AS fit_type_affiliation

    FROM `data-warehouse-289815.sfdc_templates.contact_at_template` AS term
 --Join with Affiliation object
    FULL JOIN `data-warehouse-289815.salesforce_raw.npe5__Affiliation__c` AS aff
        ON term.Affiliation_Record_ID__c = aff.Id

    WHERE term.Indicator_Completed_CT_HS_Program__c = TRUE
    AND term.Indicator_Years_Since_HS_Grad_to_Date__c IN (.33,.25) #Fall Year 1 term
    AND AT_Enrollment_Status__c IN ("Full-time","Part-time", "Approved Gap Year")
    AND High_School_Class__c IN ("2017", "2018", "2019", "2020") 

GROUP BY    
    term.contact_id,
    term.Full_Name__c,
    High_School_Class__c,
    site_full,
    term.site_short,
    region_full,
    term.region_short,
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
    aff.Situational_Fit_Type__c,
    aff.Situational_Best_Fit_Context__c,
    aff.Fit_Type_Current__c,
    aff.Fit_Type__c,
    fit_type_start_of_affiliation,
    Affiliation_id_at,
    id_aff,
    fit_type_affiliation