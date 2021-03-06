WITH Clean_AT AS(
  SELECT
    A.Id AS AT_Id,
    A.Name AS AT_Name,
    A.record_type_id AS AT_RecordType_ID,
    A.Enrollment_Status_c AS AT_Enrollment_Status_c,
    A.Grade_c AS AT_Grade_c,
    A.*
  EXCEPT(
      Id,
      Name,
      record_type_id,
      created_date,
      created_by_id,
      last_modified_date,
      last_modified_by_id,
      last_activity_date,
      Anticipated_Date_of_Graduation_4_year_c,
      Admin_Temp_1_c,
      Enrollment_Status_c,
      Grade_c,
      Parent_Email_1_c,
      Parent_Email_2_c,
      Reason_For_Leaving_Dismissal_c,
      Site_c,
      Total_Bank_Book_Earnings_current_c,
      Credits_Accumulated_Most_Recent_c,
      Legacy_Salesforce_ID_c,
      Legacy_Import_ID_c,
      is_deleted,
      system_modstamp,
      last_viewed_date,
      last_referenced_date,
      Current_CCA_Viewing_c
    ),
    RT.Name AS AT_Record_Type_Name,
    A_School.Name AS School_Name,
    GAS.Name AS GAS_Name,
    GAS.Start_Date_c AS GAS_Start_Date,
    GAS.End_Date_c AS GAS_End_Date,
    AY.Name AS AY_Name,
    AY.Start_Date_c as AY_Start_Date,
    AY.End_Date_c as AY_End_Date
  FROM
    `data-warehouse-289815.salesforce.academic_semester_c` A
    LEFT JOIN `data-warehouse-289815.salesforce.record_type` RT ON A.record_type_id = RT.Id -- Left join from Contact on to Account for Site
    LEFT JOIN `data-warehouse-289815.salesforce.account` A_School ON A.School_c = A_School.Id -- Left join from Contact on to Account for Site
    LEFT JOIN `data-warehouse-289815.salesforce.global_academic_semester_c` GAS ON A.Global_Academic_Semester_c = GAS.Id
    LEFT JOIN `data-warehouse-289815.salesforce.academic_year_c` AY ON A.Academic_Year_c = AY.Id
)
SELECT
  C.*,
     Clean_AT.*
FROM
  `data-warehouse-289815.salesforce_clean.contact_template` C
  LEFT JOIN Clean_AT ON C.Contact_Id = Clean_AT.student_c