CREATE
OR REPLACE TABLE `data-studio-260217.ct_application.ct_application_filtered_data` AS(
  WITH gather_data AS (
    SELECT
      Contact_Id,
      CONCAT(
        "https://ctgraduates.lightning.force.com/lightning/r/Contact/",
        Contact_Id,
        "/view"
      ) AS contact_url,
      Full_Name__c,
      Current_School__c,
      College_Track_Status_Name,
      site_short,
      Gender__c,
      Indicator_First_Generation__c,
      Indicator_Low_Income__c,
      Contact_Record_Type_Name,
      HIGH_SCHOOL_GRADUATING_CLASS__c,
      A.College_Track_FY_HS_Planned_Enrollment__c,
      A.College_Track_High_School_Capacity__c,
      Last_College_Track_Application__c
    FROM
      `data-warehouse-289815.sfdc_templates.contact_template`
      LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` A ON A.Id = SITE__c
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
)