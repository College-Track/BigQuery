WITH gather_data AS (
  SELECT
    Contact_Id,
    College_Track_Status_Name,
    site_short,
    Gender__c,
    Indicator_First_Generation__c,
    Indicator_Low_Income__c,
    Contact_Record_Type_Name,
    HIGH_SCHOOL_GRADUATING_CLASS__c,
    SITE__c,
    A.College_Track_FY_HS_Planned_Enrollment__c,
    A.College_Track_High_School_Capacity__c
  FROM
    `data-warehouse-289815.sfdc_templates.contact_template`
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` A ON A.Id = SITE__c
  WHERE
    Contact_Record_Type_Name NOT IN ('Student: Post-Secondary', 'Student: Alumni')
)
SELECT
  *
FROM
  gather_data
LIMIT
  1000