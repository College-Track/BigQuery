SELECT
  PAT.current_academic_semester_c, 
  PAT.global_academic_semester_c ,
  CAR.Contact_Id AS Salesforce_ID,
  CAR.Full_Name_c AS Full_Name,
  CAR.HIGH_SCHOOL_GRADUATING_CLASS_c AS High_School_Class,
  CAR.college_class,
  PAT.latest_reciprocal_communication_date_c AS Latest_Reciprocal_Communication_Date,
  CAR.Advising_Rubric_Academic_Readiness_c AS Advising_Rubric_Academic_Readiness,
  CAR.Advising_Rubric_Career_Readiness_c AS Advising_Rubric_Career_Readiness,
  CAR.Advising_Rubric_Financial_Success_c AS Advising_Rubric_Financial_Success,
  CAR.Advising_Rubric_Wellness_c AS Advising_Rubric_Wellness,
  CAR.school_type AS School_Type,
  CAR.Current_CC_Advisor_c AS Current_CC_Advisor,
  CAR.Most_Recent_GPA_Cumulative_c AS CGPA,
  PAT.Prev_AT_Term_GPA AS Previous_Term_GPA,
  CAR.overall_score AS Overall_Score,
  CAR.overall_score_color AS Score_Color,
  CAR.region_short AS Region,
  CAR.site_short AS Site,
  PAT.credit_accumulation_pace_c,
  PAT.School_Name
  
FROM
  `data-studio-260217.college_rubric.filtered_college_rubric` AS CAR
  LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` PAT
  ON CAR.Contact_Id = PAT.Contact_Id
WHERE CAR.current_or_prev_at = "Current AT"

GROUP BY
  CAR.Contact_Id,
  CAR.Full_Name_c,
  CAR.HIGH_SCHOOL_GRADUATING_CLASS_c,
  CAR.Advising_Rubric_Academic_Readiness_c,
  CAR.Advising_Rubric_Career_Readiness_c,
  CAR.Advising_Rubric_Financial_Success_c,
  CAR.Advising_Rubric_Wellness_c,
  CAR.school_type,
  CAR.Current_CC_Advisor_c,
  CAR.Most_Recent_GPA_Cumulative_c,
  CAR.overall_score,
  CAR.overall_score_color,
  CAR.region_short,
  CAR.site_short,
  CAR.college_class,
  PAT.Prev_AT_Term_GPA,
  PAT.credit_accumulation_pace_c,
  PAT.School_Name,
  PAT.latest_reciprocal_communication_date_c,
  PAT.current_academic_semester_c, 
  PAT.global_academic_semester_c