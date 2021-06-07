WITH gather_data AS (
  SELECT
    C.Contact_Id,
    C.contact_url,
    C.Full_Name_c,
    CASE
      WHEN C.College_Track_Status_Name = 'Not Admitted' THEN "Declined / Not Admitted"
      WHEN C.College_Track_Status_Name = 'Admitted and Declined' THEN "Declined / Not Admitted"
      WHEN C.College_Track_Status_Name = 'Voluntarily rescinded application' THEN "Declined / Not Admitted"
      ELSE C.College_Track_Status_Name
    END AS College_Track_Status_Name,
    C.site_short,
    C.region_short,
    C.Gender_c,
    C.site_sort,
    C.First_Generation_FY_20_c AS First_Generation_c,
    C.Indicator_Low_Income_c,
    C.Contact_Record_Type_Name,
    CASE
      WHEN C.HIGH_SCHOOL_GRADUATING_CLASS_c IS NULL THEN "No Data"
      ELSE C.HIGH_SCHOOL_GRADUATING_CLASS_c
    END AS HIGH_SCHOOL_GRADUATING_CLASS_c,
    A.College_Track_FY_HS_Planned_Enrollment_c,
    A.college_track_high_school_capacity_v_2_c AS college_track_high_school_capacity_c,
    CTA.created_date,
    C.Ethnic_background_c,
    A_MS.Name AS middle_school,
    A_HS.Name AS high_school,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_template` C
    LEFT JOIN `data-warehouse-289815.salesforce.account` A ON A.Id = SITE_c
    LEFT JOIN `data-warehouse-289815.salesforce_clean.college_track_application_clean` CTA ON CTA.Id = C.Last_College_Track_Application_c
    LEFT JOIN `data-warehouse-289815.salesforce.account` A_HS ON A_HS.Id = CTA.Current_School_c
    LEFT JOIN `data-warehouse-289815.salesforce.account` A_MS ON A_MS.Id = CTA.Middle_School_c
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
      'Leave of Absence',
      'Not Admitted',
      'Admitted and Declined',
      'Voluntarily rescinded application'
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
    WHEN College_Track_Status_Name = "Declined / Not Admitted" THEN 8
    ELSE 9
  END AS sort_ct_status,
  CASE
    WHEN College_Track_Status_Name = "Declined / Not Admitted" THEN 0
    WHEN Contact_Record_Type_Name = "Student: Applicant" AND College_Track_Status_Name != "Declined / Not Admitted" THEN 1
    WHEN College_Track_Status_Name = "Onboarding" THEN 1
    ELSE 0
  END AS applicant_count,
  CASE
    WHEN College_Track_Status_Name = "Onboarding" THEN 1
    ELSE 0
  END AS onboarding_count,
  CASE
    WHEN College_Track_Status_Name = "Current CT HS Student" THEN 1
    WHEN College_Track_Status_Name = "Leave of Absence" THEN 1
    ELSE 0
  END AS current_student_count
FROM
  gather_data