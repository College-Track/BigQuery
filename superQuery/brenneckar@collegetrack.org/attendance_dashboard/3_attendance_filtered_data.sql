WITH gather_data AS(
  SELECT
    WSA.Id AS WSA_Id,
    WSA.Workshop_Dosage_Type__c,
    SPLIT(RTRIM(WSA.Workshop_Dosage_Type__c, ";"), ';') AS dosage_combined,
    WSA.Attendance_Numerator__c,
    WSA.Attendance_Denominator__c,
    0 AS group_base,
    WSA.Class_Session__c,
    WSA.Student__c,
    CAT.Full_Name__c,
    WSA.Date__c,
    WSA.Outcome__c,
    WSA.Workshop_Department__c,
    WSA.Workshop_Display_Name__c,
    WSA.Student_Site__c,
    WSA.Student_High_School_Class__c,
    WSA.Attendance_Excluded__c,
    CAT.Indicator_High_Risk_for_Dismissal__c,
    CAT.Indicator_Low_Income__c,
    CAT.Ethnic_background__c,
    CAT.First_Generation__c,
    CAT.GPA_Bucket_running_cumulative__c,
    CAT.College_Track_Status__c,
    -- status.Status,
    WSA.Academic_Semester__c,
    REPLACE(
      CAT.GAS_Name,
      ' (Semester)',
      ''
    ) AS Workshop_Global_Academic_Semester__c,
    CAT.Indicator_Student_on_Intervention__c,
    CAT.GPA_prev_semester_cumulative__c,
    CAT.Composite_Readiness_Most_Recent__c,
    CASE
      WHEN CAT.GPA_prev_semester_cumulative__c < 2.5 THEN '2.49 or less'
      WHEN CAT.GPA_prev_semester_cumulative__c >= 2.5
      AND CAT.GPA_prev_semester_cumulative__c < 2.75 THEN '2.5 - 2.74'
      WHEN CAT.GPA_prev_semester_cumulative__c >= 2.75
      AND CAT.GPA_prev_semester_cumulative__c < 3 THEN '2.75 - 2.99'
      WHEN CAT.GPA_prev_semester_cumulative__c >= 3
      AND CAT.GPA_prev_semester_cumulative__c < 3.5 THEN '3.0 - 3.49'
      ELSE '3.5 or Greater'
    END GPA_Bucket,
    CAT.site_abrev,
    CAT.site_short,
    CAT.CT_Coach__c,
    CAT.Most_Recent_GPA_Cumulative__c,
    CAT.Indicator_Sem_Attendance_Above_80__c,
    CAT.region,
    CAT.region_abrev,
    CAT.College_Track_Status_Name,
    CAT.CoVitality_Scorecard_Color_Most_Recent__c,
    WS.Class__c,
    CONCAT(
      "https://ctgraduates.lightning.force.com/lightning/r/Contact/",
      WSA.Student__c,
      "/view"
    ) AS contact_url,
    CONCAT(
      "https://ctgraduates.lightning.force.com/lightning/r/Class__c/",
      WS.Class__c,
      "/view"
    ) AS workshop_url,
    WS.Primary_Staff__c,
    WkShpInstructor__c
  FROM
    `data-warehouse-289815.salesforce_raw.Class_Attendance__c` AS WSA
    LEFT JOIN `data-warehouse-289815.sfdc_templates.contact_at_template` CAT ON WSA.Student__c = CAT.Contact_Id
    AND WSA.Academic_Semester__c = CAT.AT_Id
    LEFT JOIN `data-warehouse-289815.salesforce_raw.Class_Session__c` WS ON WS.Id = WSA.Class_Session__c
    -- LEFT JOIN `data-warehouse-289815.salesforce_raw.Class__c` W ON W.Id = WS.Class__c
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
    *
  EXCEPT(
      Attendance_Numerator__c,
      Attendance_Denominator__c
    ),
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
) -- SELECT COUNT(DISTINCT(WSA_ID))
-- FROM gather_data
-- -- ORDER BY WSA_Id
,
final_pull AS (
  SELECT
    MD.*
  EXCEPT(dosage_combined),
    GD.Attendance_Numerator__c,
    GD.Attendance_Denominator__c,
    --   GD.* EXCEPT(dosage_combined)
    --   MD.dosage_split
  FROM
    create_col_number MD
    LEFT JOIN gather_data GD ON GD.WSA_Id = MD.WSA_Id
    AND MD.group_count = GD.group_base
  ORDER BY
    GD.WSA_Id
)
SELECT
  *
EXCEPT(dosage_split),
  TRIM(dosage_split) AS dosage_split
FROM
  final_pull
WHERE
  Date__c <= CURRENT_DATE()
  AND Attendance_Excluded__c = FALSE
  AND Workshop_Dosage_Type__c IS NOT NULL
  AND (
    mod_denominator > 0
    OR mod_numerator > 0
  )