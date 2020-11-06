WITH gather_attendance AS(
  SELECT
    Attendance.Id,
    Workshop_Dosage_Type__c,
    SPLIT(RTRIM(Workshop_Dosage_Type__c, ";"), ';') AS dosage_combined,
    Attendance_Numerator__c,
    Attendance_Denominator__c,
    0 AS group_count,
    Class_Session__c,
    Workshop.Class__c,
    Attendance.Student__c,
    Contact.Full_Name__c,
    Date__c,
    Outcome__c,
    Workshop_Department__c,
    Workshop_Display_Name__c,
    Student_Site__c,
    Student_High_School_Class__c,
    Attendance_Excluded__c,
    Primary_Affiliation__c,
    Contact.Indicator_High_Risk_for_Dismissal__c,
    Contact.Indicator_Low_Income__c,
    Contact.Ethnic_background__c,
    Contact.First_Generation__c,
    Academic_Term.GPA_Bucket_running_cumulative__c,
    Contact.College_Track_Status__c,
    status.Status,
    Academic_Semester__c,
    REPLACE(
      Workshop_Global_Academic_Semester__c,
      ' (Semester)',
      ''
    ) AS Workshop_Global_Academic_Semester__c,
    Academic_Term.Indicator_Student_on_Intervention__c,
    Academic_Term.GPA_prev_semester_cumulative__c,
    Contact.Composite_Readiness_Most_Recent__c,
    CASE
      WHEN GPA_prev_semester_cumulative__c < 2.5 THEN '2.49 or less'
      WHEN GPA_prev_semester_cumulative__c >= 2.5
      AND GPA_prev_semester_cumulative__c < 2.75 THEN '2.5 - 2.74'
      WHEN GPA_prev_semester_cumulative__c >= 2.75
      AND GPA_prev_semester_cumulative__c < 3 THEN '2.75 - 2.99'
      WHEN GPA_prev_semester_cumulative__c >= 3
      AND GPA_prev_semester_cumulative__c < 3.5 THEN '3.0 - 3.49'
      ELSE '3.5 or Greater'
    END GPA_Bucket,
    Contact.site_abrev,
    Academic_Term.Indicator_Sem_Attendance_Above_80__c,
    Contact.region,
    Contact.region_abrev
  FROM
    `data-warehouse-289815.salesforce_raw.Class_Attendance__c` AS Attendance
    LEFT JOIN (
      SELECT
        Full_Name__c,
        Contact_Id,
        Indicator_High_Risk_for_Dismissal__c,
        Indicator_Low_Income__c,
        Ethnic_background__c,
        First_Generation__c,
        Most_Recent_GPA_Cumulative__c,
        College_Track_Status__c,
        Composite_Readiness_Most_Recent__c,
        region,
        region_abrev,
        site_abrev
      FROM
        `data-warehouse-289815.sfdc_templates.contact_template`
    ) AS Contact ON Attendance.Student__c = Contact.Contact_Id
    LEFT JOIN (
      SELECT
        GPA_Bucket_running_cumulative__c,
        Student__c,
        Id,
        Indicator_Student_on_Intervention__c,
        GPA_prev_semester_cumulative__c,
        Indicator_Sem_Attendance_Above_80__c
      FROM
        `data-warehouse-289815.salesforce_raw.Academic_Semester__c`
    ) AS Academic_Term ON Attendance.Academic_Semester__c = Academic_Term.Id
    LEFT JOIN (
      SELECT
        api_name,
        Status
      FROM
        `data-warehouse-289815.roles.ct_status`
    ) AS status ON Contact.College_Track_Status__c = status.api_name
    LEFT JOIN (
      SELECT
        Class__c,
        Id
      FROM
        `data-warehouse-289815.salesforce_raw.Class_Session__c`
    ) AS Workshop ON Attendance.Class_Session__c = Workshop.Id
  WHERE
    Student_Site__c != 'College Track Arlen'
    AND (
      status.Status = 'Current CT HS Student'
      OR status.Status = 'Onboarding'
      OR status.Status = 'Leave of Absence'
    )
),
mod_dosage AS (
  SELECT
    Id,
    Workshop_Dosage_Type__c,
    dosage_split,
    Attendance_Numerator__c AS mod_numerator,
    Attendance_Denominator__c AS mod_denominator
  FROM
    gather_attendance
    CROSS JOIN UNNEST(gather_attendance.dosage_combined) AS dosage_split
),
create_col_number AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY Id
      ORDER BY
        Id
    ) - 1 As group_count,
  from
    mod_dosage
)
SELECT
  GA.*,
  MD.mod_numerator,
  MD.mod_denominator,
  MD.dosage_split
FROM
  create_col_number MD
  LEFT JOIN gather_attendance GA ON GA.Id = MD.Id
  AND MD.group_count = GA.group_count