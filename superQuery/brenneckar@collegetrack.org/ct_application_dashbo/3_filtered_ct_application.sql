WITH gather_data AS (
  SELECT
    C.Contact_Id,
    CONCAT(
      "https://ctgraduates.lightning.force.com/lightning/r/Contact/",
      C.Contact_Id,
      "/view"
    ) AS contact_url,
    C.Full_Name__c,
    C.Current_School__c,
    C.College_Track_Status_Name,
    C.site_short,
    C.Gender__c,
    C.Indicator_First_Generation__c,
    C.Indicator_Low_Income__c,
    C.Contact_Record_Type_Name,
    C.HIGH_SCHOOL_GRADUATING_CLASS__c,
    A.College_Track_FY_HS_Planned_Enrollment__c,
    A.College_Track_High_School_Capacity__c,
    CTA.CreatedDate,
    C.Ethnic_background__c
    
  FROM
    `data-warehouse-289815.sfdc_templates.contact_template` C
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` A ON A.Id = SITE__c
    LEFT JOIN `data-warehouse-289815.salesforce_raw.College_Track_Application__c` CTA ON CTA.Id = C.Last_College_Track_Application__c
  WHERE
    College_Track_Status_Name IN (
      'Application in progress',
      'Application submitted',
      'Interview Scheduled',
      'Interview Complete',
      'Admitted',
      'Wait-listed',
      'Onboarding',
      'Current CT HS Student',
      'Leave of Absence'
    )
)
SELECT
  *
FROM
  gather_data