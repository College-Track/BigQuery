WITH gather_data AS (
SELECT Contact_Id, College_Track_Status_Name, site_short, Gender__c, Indicator_First_Generation__c, Indicator_Low_Income__c, Contact_Record_Type_Name
FROM `data-warehouse-289815.sfdc_templates.contact_template`
WHERE Contact_Record_Type_Name NOT IN ('Student: Post-Secondary')


)
SELECT *
FROM gather_data
LIMIT 1000