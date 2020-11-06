WITH gather_data AS(
  SELECT
    WSA.Id AS WSA_Id,
    WSA.Workshop_Dosage_Type__c,
    SPLIT(RTRIM(WSA.Workshop_Dosage_Type__c, ";"), ';') AS dosage_combined,
    WSA.Attendance_Numerator__c,
    WSA.Attendance_Denominator__c,
    0 AS group_count,
    -- WSA.Class_Session__c,
    -- -- W.Class__c,
    -- WSA.Student__c,
    -- CAT.Full_Name__c,
    -- WSA.Date__c,
    -- WSA.Outcome__c,
    -- WSA.Workshop_Department__c,
    -- WSA.Workshop_Display_Name__c,
    -- WSA.Student_Site__c,
    -- WSA.Student_High_School_Class__c,
    -- WSA.Attendance_Excluded__c,
    -- CAT.Indicator_High_Risk_for_Dismissal__c,
    -- CAT.Indicator_Low_Income__c,
    -- CAT.Ethnic_background__c,
    -- CAT.First_Generation__c,
    -- CAT.GPA_Bucket_running_cumulative__c,
    -- CAT.College_Track_Status__c,
    -- -- status.Status,
    -- WSA.Academic_Semester__c,
    -- REPLACE(
    --   CAT.GAS_Name,
    --   ' (Semester)',
    --   ''
    -- ) AS Workshop_Global_Academic_Semester__c,
    -- CAT.Indicator_Student_on_Intervention__c,
    -- CAT.GPA_prev_semester_cumulative__c,
    -- CAT.Composite_Readiness_Most_Recent__c,
    -- CASE
    --   WHEN CAT.GPA_prev_semester_cumulative__c < 2.5 THEN '2.49 or less'
    --   WHEN CAT.GPA_prev_semester_cumulative__c >= 2.5
    --   AND CAT.GPA_prev_semester_cumulative__c < 2.75 THEN '2.5 - 2.74'
    --   WHEN CAT.GPA_prev_semester_cumulative__c >= 2.75
    --   AND CAT.GPA_prev_semester_cumulative__c < 3 THEN '2.75 - 2.99'
    --   WHEN CAT.GPA_prev_semester_cumulative__c >= 3
    --   AND CAT.GPA_prev_semester_cumulative__c < 3.5 THEN '3.0 - 3.49'
    --   ELSE '3.5 or Greater'
    -- END GPA_Bucket,
    -- CAT.site_abrev,
    -- CAT.Indicator_Sem_Attendance_Above_80__c,
    -- CAT.region,
    -- CAT.region_abrev,
    -- CAT.College_Track_Status_Name
  FROM
    `data-warehouse-289815.salesforce_raw.Class_Attendance__c` AS WSA
    LEFT JOIN `data-warehouse-289815.sfdc_templates.contact_at_template` CAT
     ON WSA.Student__c = CAT.Contact_Id AND WSA.Academic_Semester__c = CAT.AT_Id
    
  WHERE
    Student_Site__c != 'College Track Arlen'
    AND (
      CAT.College_Track_Status_Name = 'Current CT HS Student'
      OR CAT.College_Track_Status_Name = 'Onboarding'
      OR CAT.College_Track_Status_Name = 'Leave of Absence'
    ) 
    AND WSA.Date__c >= "2019-08-01"
),
mod_dosage AS (
  SELECT
    WSA_Id,
    Workshop_Dosage_Type__c,
    dosage_split,
    Attendance_Numerator__c AS mod_numerator,
    Attendance_Denominator__c AS mod_denominator
  FROM
    gather_data
    CROSS JOIN UNNEST(gather_data.dosage_combined) AS dosage_split
),


create_col_number AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY WSA_Id
      ORDER BY
        WSA_Id
    ) - 1 As group_count,
  from
    mod_dosage
)

SELECT COUNT(DISTINCT(WSA_ID))
FROM gather_data
-- ORDER BY WSA_Id


-- SELECT
--   MD.WSA_Id AS new_id,
--   MD.mod_numerator,
--   MD.mod_denominator,
--   MD.dosage_split,
--   GD.WSA_Id,
--   GD.Workshop_Dosage_Type__c,
--   GD.Attendance_Numerator__c,
--   GD.Attendance_Denominator__c
-- --   GD.* EXCEPT(dosage_combined)

-- --   MD.dosage_split
-- FROM
--   create_col_number MD
--   LEFT JOIN gather_data GD ON GD.WSA_Id = MD.WSA_Id
--   AND MD.group_count = GD.group_count
--  ORDER BY GD.WSA_Id