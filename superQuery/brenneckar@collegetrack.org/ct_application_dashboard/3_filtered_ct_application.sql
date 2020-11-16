WITH gather_data AS (
  SELECT
    C.Contact_Id,
    CONCAT(
      "https://ctgraduates.lightning.force.com/lightning/r/Contact/",
      C.Contact_Id,
      "/view"
    ) AS contact_url,
    C.Full_Name__c,
    C.College_Track_Status_Name,
    C.site_short,
    C.region_short,
    C.Gender__c,
    C.First_Generation_FY20__c AS First_Generation__c,
    C.Indicator_Low_Income__c,
    C.Contact_Record_Type_Name,
    C.HIGH_SCHOOL_GRADUATING_CLASS__c,
    A.College_Track_FY_HS_Planned_Enrollment__c,
    A.College_Track_High_School_Capacity__c,
    CTA.CreatedDate,
    C.Ethnic_background__c,
    A_MS.Name AS middle_school,
    A_HS.Name AS high_school,
  FROM
    `data-warehouse-289815.sfdc_templates.contact_template` C
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` A ON A.Id = SITE__c
    LEFT JOIN `data-warehouse-289815.salesforce_raw.College_Track_Application__c` CTA ON CTA.Id = C.Last_College_Track_Application__c
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` A_HS ON A_HS.Id = CTA.Current_School__c
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` A_MS ON A_MS.Id = CTA.Middle_School__c
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
  *,
  CASE
    WHEN College_Track_Status_Name = "Application in progress" THEN 1
    WHEN College_Track_Status_Name = "Application submitted" THEN 2
    WHEN College_Track_Status_Name = "Interview Scheduled" THEN 3
    WHEN College_Track_Status_Name = "Interview Complete" THEN 4
    WHEN College_Track_Status_Name = "Admitted" THEN 5
    WHEN College_Track_Status_Name = "Wait-listed" THEN 6
    WHEN College_Track_Status_Name = "Onboarding" THEN 7
    ELSE 8
  END AS sort_ct_status,
  CASE WHEN Contact_Record_Type_Name = "Student: Applicant" THEN 1
  ELSE 0
  END AS applicant_count
FROM
  gather_data