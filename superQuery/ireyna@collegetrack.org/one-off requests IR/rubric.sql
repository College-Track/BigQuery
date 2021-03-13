SELECT
  Contact_Id,
  Full_Name_c,
  HIGH_SCHOOL_GRADUATING_CLASS_c,
  Advising_Rubric_Academic_Readiness_c,
  Advising_Rubric_Career_Readiness_c,
  Advising_Rubric_Financial_Success_c,
  Advising_Rubric_Wellness_c,
  school_type,
  Current_CC_Advisor_c,
  Most_Recent_GPA_Cumulative_c,
  overall_score,
  overall_score_color,
  region_short,
  site_short,
  college_class
  
FROM
  `data-studio-260217.college_rubric.filtered_college_rubric`
  
  GROUP BY
  Contact_Id,
  Full_Name_c,
  HIGH_SCHOOL_GRADUATING_CLASS_c,
  Advising_Rubric_Academic_Readiness_c,
  Advising_Rubric_Career_Readiness_c,
  Advising_Rubric_Financial_Success_c,
  Advising_Rubric_Wellness_c,
  school_type,
  Current_CC_Advisor_c,
  Most_Recent_GPA_Cumulative_c,
  overall_score,
  overall_score_color,
  region_short,
  site_short,
  college_class