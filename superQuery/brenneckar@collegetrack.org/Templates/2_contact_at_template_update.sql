WITH Contact_AT AS(
  SELECT
    C.*,
    A.Id AS AT_Id,
    A.Name AS AT_Name,
    A.RecordTypeId AS AT_RecordType_ID,
    A.CreatedDate AS AT_CreatedDate,
    A.CreatedById AS AT_CreatedById,
    A.LastModifiedDate AS AT_LastModifiedDate,
    A.LastModifiedById AS AT_LastModifiedById,
    A.*
  EXCEPT(
      Id,
      Name,
      RecordTypeId,
      CreatedDate,
      CreatedById,
      LastModifiedDate,
      LastModifiedById
    ),
    
    RT.Name AS AT_Record_Type_Name,
    A_School.Name AS School_Name,
    GAS.Name AS GAS_Name,
    GAS.Start_Date__c AS GAS_Start_Date,
    GAS.End_Date__c AS GAS_End_Date,
    AY.Name AS AY_Name,
    AY.Start_Date__c as AY_Start_Date,
    AY.End_Date__c as AY_End_Date
  FROM
    `data-warehouse-289815.sfdc_templates.contact_template` C
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Academic_Semester__c` A ON C.Contact_Id = A.Student__c
    LEFT JOIN `data-warehouse-289815.salesforce_raw.RecordType` RT ON A.RecordTypeId = RT.Id -- Left join from Contact on to Account for Site
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` A_School ON A.School__c = A_School.Id -- Left join from Contact on to Account for Site
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Global_Academic_Semester__c` GAS ON A.Global_Academic_Semester__c = GAS.Id
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Academic_Year__c` AY ON A.Academic_Year__c = AY.Id
)
SELECT
  *
FROM
  Contact_AT