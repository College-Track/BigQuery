WITH college_application_AT AS
    (
    SELECT
    A_T.*,
    A_T.ACT_English_highest_official__c ,
    A_T.ACT_Highest_Composite_Single_Sitting__c ,
    A_T.ACT_Highest_Composite_official__c,
    A_T.ACT_Math_highest_official__c ,
    A_T.ACT_Official_Tests_Taken__c ,
    A_T.ACT_Reading_highest_official__c ,
    A_T.ACT_Science_highest_official__c ,
    A_T.ACT_Superscore_highest_official__c ,
    A_T.ACT_Writing_highest_official__c ,
    A_T.AT_Enrollment_Status__c ,
    A_T.AT_Grade__c ,
    A_T.AT_Id ,
    A_T.AT_Name, #academic term name
    A_T.AT_RecordType_ID, #AT record type
    A_T.AT_Record_Type_Name, #academic record type (HS, college)
    A_T.AY_End_Date,
    A_T.AY_Start_Date ,
    A_T.AY_Name ,
    A_T.Academic_Intervention_Needed__c ,
    A_T. Academic_Intervention_Received__c ,
    A_T.Academic_Networking_50_Cred__c ,
    A_T.Academic_Scorecard_Color_Reason_s__c ,
    A_T.Academic_Scorecard_Color_Reason_s__c , 
    A_T.Academic_Scorecard_Color__c ,
    A_T.Academic_Standing__c ,
    A_T.Academic_Year_4_Year_Degree_Earned__c ,
    A_T.Academic_Year_Term_4Year_Degree_Earned__c ,
    A_T.Academic_Year__c, #academic year ID,
    A_T.Academic_Years_Completed_since_HS_Grad__c ,
    A_T.AccountId ,
    A_T.Actual_grad_school_graduation_year__c ,
    A_T.Add_Reason_Course_Schedule_Not_Available__c ,
    A_T.Additional_Reason_Transcript_Unavailab__c ,
    A_T.Adjusted_Dosage__c ,
    A_T.Adjustment_Reason_Acceleration__c ,
    A_T.Adjustment_Reason_CC__c ,
    A_T.Adjustment_Reason_Coaching__c ,
    A_T.Adjustment_Reason_Math__c ,
    A_T.Adjustment_Reason_SL__c ,
    A_T.Adjustment_Reason_Test_Prep__c ,
    A_T.Adjustment_Reason_Tutoring__c ,
    A_T.Advising_Rubric_Academic_Readiness__c ,
    A_T.Advising_Rubric_COVID__c ,
    A_T.Advising_Rubric_Career_Readiness__c ,
    A_T.Advising_Rubric_Financial_Success__c ,
    A_T.Advising_Rubric_Wellness__c ,
    A_T.Aff_Change_End_Date__c ,
    A_T.Aff_Change_Start_Date__c ,
    A_T.Affiliation_Record_ID__c ,
    A_T.Affiliation__c ,
    A_T.Age__c ,
    A_T.Aggressive_Scholarship_Strategy_Reason__c ,
    A_T.Aggressive_Scholarship_Strategy__c ,
    A_T.Alumni_Network_75_credits__c ,
    A_T.Annual_household_income__c ,
    A_T.Anticipated_Date_of_Graduation_4_Year__c ,
    A_T.Anticipated_Date_of_Graduation_AY__c ,
    A_T.Anticipated_Date_of_Transfer__c ,
    A_T.Anticipated_graduate_school_graduation__c ,
    A_T.Attendance_Earnings__c ,
    A_T.Attendance_Rate__c ,
    A_T.Attendance_Rate_excluding_make_ups__c ,
    A_T.Attendance_Rate_Annual__c ,
    A_T.Attendance_Rate_Previous_Term__c ,
    A_T.Attendance_category_current_semester__c ,
    A_T.Attendance_category_current_year__c ,
    A_T.Attendance_category_previous_semester__c ,
    A_T.Attended_Workshops__c ,
    A_T.Attended_Workshops_excluding_make_ups__c ,
    A_T.Attended_Workshops_10th_Grade__c ,
    A_T.Attended_Workshops_11th_Grade__c ,
    A_T.Attended_Workshops_12th_Grade__c ,
    A_T.Attended_Workshops_9th_Grade__c ,
    A_T.Attended__c ,
    A_T.BB_Disbursement_Limit_Current_FY_contact__c ,
    A_T.BB_Disbursements_current_FY_contact__c ,
    A_T.BB_Disbursements_total__c ,
    A_T.Bank_Book_Earnings__c ,
    A_T.Birthdate ,
    A_T.CC_Advisor_4_Year_Degree_Earned__c ,
    A_T.CC_Advisor_AT_User_ID__c ,
    A_T.CC_Advisor__c ,
    A_T.CT_Coach__c ,
    A_T.CT_Connect_Account_Created__c ,
    A_T.Calendar_Type__c , #semester or quarter,
    A_T.Campus_Outlook__c ,
    A_T.Career_Counselor_25_credits__c ,
    A_T.Career_Field_2550_credits__c ,
    A_T.Citizen_c__c ,
    A_T.CoVitality_Indicator__c ,
    A_T.CoVitality_Scorecard_Color_Most_Recent__c ,
    A_T.CoVitality_Scorecard_Color__c ,
    A_T.Cohort__c ,
    A_T.CollegeUniversity_Response_COVID19__c ,
    A_T.College_4_Year_Degree_Earned__c ,
    A_T.College_Acceptances_Affordable__c ,
    A_T.College_Completion_Service_Opt_In_Date__c ,
    A_T.College_First_Enrolled_PAT__c ,
    A_T.College_First_Enrolled_School_Type__c ,
    A_T.College_First_Enrolled_School__c ,
    A_T.College_Track_Status_Name ,
    A_T.College_Track_Status__c ,
    A_T.Commitment__c ,
    A_T.Community_Service_Hours__c ,
    A_T.Completed_CT_2019_20_Survey_Date__c ,
    A_T.Completed_CT_2019_20_Survey__c ,
    A_T.Composite_Readiness_Most_Recent__c ,
    A_T.Concurrent_school__c ,
    A_T.Confirm_Admission__c ,
    A_T.Contact_4_Year_Degree_Earned_AT_Lookup__c ,
    A_T.Contact_Frequency__c ,
    A_T.Contact_Login_Credentials_Record__c ,
    A_T.Contact_Record_Type_Name ,
    A_T.Count_Common_App_Counselor_Report__c ,
    A_T.Country_of_Birth_c__c ,
    A_T.Course_Materials__c ,
    A_T.Course_Schedule_Provided__c ,
    A_T.Courseload__c ,
    A_T.Credit_Accumulation_Pace__c ,
    A_T.Credits_Accumulated_Most_Recent__c ,
    A_T.Credits_Accumulated__c ,
    A_T.Credits_Attempted_Current_Term__c ,
    A_T.Credits_Awarded_Current_Term__c ,
    A_T.Cumulative_Credits_Awarded_All_Terms__c ,
    A_T.Cumulative_Credits_Awarded_MAX_CALC__c ,
    A_T.Cumulative_Credits_Awarded_Most_Recent__c ,
    A_T.Current_AS__c , #current AT
    A_T.Current_Academic_Semester__c , #current AT on contact,
    A_T.Current_CCA_Viewing__c ,
    A_T.Current_CC_Advisor__c ,
    A_T.Current_CT_Status__c ,
    A_T.Current_Enrollment_Status__c , #from contact
    A_T.Current_HS_CT_Coach__c ,#from contact
    A_T.Current_Major__c ,#from contact
    A_T.Current_Major_specific__c ,#from contact
    A_T.Current_Minor__c ,#from contact
    A_T.Current_School_Type__c ,#from contact
    A_T.Current_School__c ,#from contact
    A_T.Current_Second_Major__c ,#from contact
    A_T.Current_employment_other__c , #from contact
    A_T.Current_employment_type__c , #from contact
    A_T.Current_or_Next_AT__c ,
    A_T.DOOR_Eligible__c ,
    A_T.DOOR_Recipient_current__c ,
    A_T.Date_employment_status_confirmed__c ,
    A_T.Degree_Awarded_Affiliation__c ,
    A_T.Degree_Awarded__c ,
    A_T.Degree_Conferred_in_the_United_States__c ,
    A_T.Degree_Plan__c ,
    A_T.Detailed_reason_for_leave__c ,
    A_T.Detailed_reason_for_leave_pl__c ,
    A_T.DosageMetCC__c ,
    A_T.DosageMetMath__c ,
    A_T.DosageMetSL__c ,
    A_T.DosageMetTestPrep__c ,
    A_T.DosageMetTutoring__c ,
    A_T.Dosage_Adjustment_Acceleration__c ,
    A_T.Dosage_Adjustment_Coaching__c ,
    A_T.Dosage_Change_Approved_Acceleration__c ,
    A_T.Dosage_Change_Approved_CC__c ,
    A_T.Dosage_Change_Approved_Coaching__c ,
    A_T.Dosage_Change_Approved_Math__c ,
    A_T.Dosage_Change_Approved_SL__c ,
    A_T.Dosage_Change_Approved_Test_Prep__c ,
    A_T.Dosage_Change_Approved_Tutoring__c ,
    A_T.Dosage_Enrolled_Acceleration__c ,
    A_T.Dosage_Enrolled_Coaching__c ,
    A_T.Dosage_Enrolled_College_Completion__c ,
    A_T.Dosage_Enrolled_Math__c ,
    A_T.Dosage_Enrolled_NSO__c ,
    A_T.Dosage_Enrolled_Student_Life__c ,
    A_T.Dosage_Enrolled_Test_Prep__c ,
    A_T.Dosage_Enrolled_Tutoring__c ,
    A_T.Dosage_Met_Acceleration__c ,
    A_T.Dosage_Met_Coaching__c ,
    A_T.Dosage_Rec2_Math__c ,
    A_T.Dosage_Rec2_Test_Prep__c ,
    A_T.Dosage_Rec2_Tutoring__c ,
    A_T.Dosage_Rec_Acceleration__c ,
    A_T.Dosage_Rec_CC__c ,
    A_T.Dosage_Rec_Coaching__c ,
    A_T.Dosage_Rec_Math__c ,
    A_T.Dosage_Rec_NSO__c ,
    A_T.Dosage_Rec_SL__c ,
    A_T.Dosage_Rec_Test_Prep__c ,
    A_T.Dosage_Rec_Tutoring__c ,
    A_T.Dream_Statement__c ,
    A_T.Dream_Statement_filled_out__c ,
    A_T.EFC_Source__c ,
    A_T.Educational_Expectations__c ,
    A_T.End_Date__c ,#academic term end date,
    A_T.Engaged_in_Corporate_Residency_Program__c ,
    A_T.English_Language_Learner_c__c ,
    A_T.Enrolled_Workshops_10th_Grade__c ,
    A_T.Enrolled_Workshops_11th_Grade__c ,
    A_T.Enrolled_Workshops_12th_Grade__c ,
    A_T.Enrolled_Workshops_9th_Grade__c ,
    A_T.Enrolled_Workshops_excluding_make_ups__c ,
    A_T.Enrolled_in_Intersession__c ,
    A_T.Enrolled_in_a_2_year_college__c ,
    A_T.Enrolled_in_a_4_year_college__c ,
    A_T.Enrolled_in_any_college__c ,
    A_T.Enrollment_Anticipated_Next_Term__c ,
    A_T.Enrollment_COVID19__c ,
    A_T.Enrollment_Status__c ,
    A_T.Entrance_into_CT_Diagnostic__c ,
    A_T.Estimated_Family_Contribution__c ,
    A_T.Ethnic_background__c ,
    A_T.Ethnic_background_other__c ,
    A_T.Expected_Date_Course_Schedule__c ,
    A_T.Expected_Graduation_Date__c ,
    A_T.Expected_return_academic_term__c ,
    A_T.Extracurricular_Activity__c ,
    A_T.FA_Obj_10th_Grade_FA_Objectives_Met__c ,
    A_T.FA_Obj_11_12th_Grade_FA_Objectives_Met__c ,
    A_T.FA_Obj_9th_Grade_FA_Objectives_Met__c ,
    A_T.FA_Obj_DOOR_Scholarships__c ,
    A_T.FA_Obj_Develop_Best_Fit__c ,
    A_T.FA_Obj_Develop_Finance_Strategies__c ,
    A_T.FA_Obj_EFC_Calculation__c ,
    A_T.FA_Obj_Individualize_Planning__c ,
    A_T.FA_Obj_Maximize_Bank_Book__c ,
    A_T.FA_Obj_Net_Price_Calc__c ,
    A_T.FA_Obj_Understand_BB_Policy__c ,
    A_T.FA_Req_Annual_Adjusted_Gross_Income__c ,
    A_T.FA_Req_CA_Dreamer_Application__c ,
    A_T.FA_Req_EFC_Source__c ,
    A_T.FA_Req_Expected_Financial_Contribution__c ,
    A_T.FA_Req_FAFSA__c ,
    A_T.FA_Req_Guardian_has_FSA_ID__c ,
    A_T.FA_Req_State_Financial_Aid_Process_Comp__c ,
    A_T.FA_Req_Student_has_FSA_ID__c ,
    A_T.FERPA_Waiver_Collected__c ,
    A_T.FERPA_Waiver_Collection_Date__c ,
    A_T.FY17_Student_Served__c ,
    A_T.FY18_Student_Served__c ,
    A_T.FY19_Student_Served__c ,
    A_T.FY20_Student_Served__c ,
    A_T.FY_Bank_Book_Balance_contact__c ,
    A_T.FY_graduating__c ,
    A_T.Fall_to_Fall_Persistence_AT__c ,
    A_T.Familial_Responsibility__c ,
    A_T.FamilyDependents__c ,
    A_T.Filing_Status__c ,
    A_T.Final_Semester__c ,
    A_T.Financial_Aid_Package__c ,
    A_T.Financial_Scorecard_Color__c ,
    A_T.Finding_Opportunities_75__c ,
    A_T.Finished_College_Grad_School_in_the_US__c ,
    A_T.FirstName ,
    A_T.First_Generation_FY20__c ,
    A_T.First_Official_ACT_Test_Record__c ,
    A_T.First_Official_SAT_Test_Record__c ,
    A_T.First_Year_College_Math_Course__c ,
    A_T.Fiscal_Year__c ,
    A_T.Fit_Type__c , #from academic term
    A_T.Four_Year_College_Acceptances__c ,
    A_T.Four_Year_College_Applications__c ,
    A_T.Four_Year_College_Enrollments__c ,
    A_T.Fraction_of_AY_since_Start_of_AYTD__c ,
    A_T.Free_Checking_Account__c ,
    A_T.Full_Name__c ,
    A_T.Future_Term_FinAid_Award_Letter_Avail__c ,
    A_T.Future_Term_New_College_Student_Id__c ,
    A_T.Future_Term_Planned_College_University__c ,
    A_T.Future_Term_Plans_to_Transfer_Schools__c ,
    A_T.Future_Term_Reason_for_Transfer__c ,
    A_T.GAS_End_Date ,
    A_T.GAS_Name ,
    A_T.GAS_Start_Date ,
    A_T.GPA_Bucket_Term__c ,
    A_T.GPA_Bucket_running_cumulative__c ,
    A_T.GPA_Cumulative__c ,
    A_T.GPA_Earnings__c ,
    A_T.GPA_Growth_prev_semester__c ,
    A_T.GPA_HS_cumulative__c ,
    A_T.GPA_prev_prev_semester__c ,
    A_T.GPA_prev_prev_semester_cumulative__c ,
    A_T.GPA_prev_semester_cumulative__c ,
    A_T.GPA_semester__c ,
    A_T.GPA_semester_cumulative__c ,
    A_T.GPA_year_cumulative__c , Gender__c ,
    A_T.Global_Academic_Semester__c ,
    A_T.Grad_Degree_type__c ,
    A_T.Grad_Program_Title_Description__c ,
    A_T.Grade__c ,
    A_T.Graduate_School__c ,
    A_T.Graduated_2_Year_Degree__c ,
    A_T.Graduated_4_Year_Degree_4_years__c ,
    A_T.Graduated_4_Year_Degree_5_years__c ,
    A_T.Graduated_4_Year_Degree_6_Years__c ,
    A_T.Graduated_4_Year_Degree__c ,
    A_T.Graduated_or_On_Track_Bucket_AT__c ,
    A_T.Graduating_HS_Semester__c ,
    A_T.Graduating_Semester__c ,
    A_T.HIGH_SCHOOL_GRADUATING_CLASS__c ,
    A_T.HS_Grad_Year__c ,
    A_T.High_School_Class__c ,
    A_T.High_School_Grade__c ,
    A_T.High_School_Text__c ,
    A_T.Highest_Level_of_Education_Achieved__c ,
    A_T.Hist_Dosage_Acceleration__c ,
    A_T.Hist_Dosage_CC__c ,
    A_T.Hist_Dosage_Coaching__c ,
    A_T.Hist_Dosage_Math__c ,
    A_T.Hist_Dosage_SL__c ,
    A_T.Hist_Dosage_Test_Prep__c ,
    A_T.Hist_Dosage_Tutoring__c ,
    A_T.Historical_4_year_college_eligble__c ,
    A_T.Historical_Contact_ID__c ,
    A_T.Housing_Food__c ,
    A_T.Ind_Start_Graduate_Same_School_6yrs__c ,
    A_T.Indicator_1_Post_Secondary_Internship__c ,
    A_T.Indicator_Accepted_and_Admitted_to_CT__c ,
    A_T.Indicator_College_Matriculation__c ,
    A_T.Indicator_Completed_CT_HS_Program__c ,
    A_T.Indicator_Count_PS_Student_for_Summer__c ,
    A_T.Indicator_First_Generation__c ,
    A_T.Indicator_Graduated_or_On_Track_AT__c ,
    A_T.Indicator_High_Risk_for_Dismissal__c ,
    A_T.Indicator_Intervention_Previous_2_ATs__c ,
    A_T.Indicator_Low_Income__c ,
    A_T.Indicator_Male__c ,
    A_T.Indicator_Meets_Attendance_Goal__c ,
    A_T.Indicator_PAT_Data_Complete__c ,
    A_T.Indicator_Persisted_AT__c ,
    A_T.Indicator_Persisted_into_2nd_Year_CT__c ,
    A_T.Indicator_Persisted_into_Year_2_Wide__c ,
    A_T.Indicator_Prev_GPA_below_2_75__c ,
    A_T.Indicator_Sem_Attendance_Above_80__c ,
    A_T.Indicator_Sem_Attendance_Below_65__c ,
    A_T.Indicator_Start_graduate_same_school__c ,
    A_T.Indicator_Student_on_Intervention__c ,
    A_T.Indicator_Years_Since_HS_Grad_to_Date__c ,
    A_T.Indicator_Years_Since_HS_Graduation__c , #contact
    A_T.Intended_Return_Date__c ,
    A_T.Internship_5075_credits__c ,
    A_T.Internship_Compensation__c ,
    A_T.Internship_Current_Term__c ,
    A_T.Internship_Facilitated_By__c ,
    A_T.Internship_Hours_per_Week__c ,
    A_T.Internship_Organization_Other__c ,
    A_T.Internship_Organization__c ,
    A_T.Internship_Related_to_Career_Interests__c ,
    A_T.Internship_Related_to_Major_Minor__c ,
    A_T.Internship_Sector__c ,
    A_T.Internships__c ,
    A_T.Languages_Spoken_Other__c ,
    A_T.Languages_Spoken__c ,
    A_T.LastName ,
    A_T.Late__c ,
    A_T.Latest_Reciprocal_Communication_Date__c ,
    A_T.Leave_of_Absence_Start__c ,
    A_T.Leaving_CT_COVID_Related__c ,
    A_T.Loan_Exit__c ,
    A_T.Loans__c ,
    A_T.Local_Affordable_College_Applications__c ,
    A_T.Major_4Year_Degree_Earned__c , #contact
    A_T.Major_Other__c ,
    A_T.Major__c ,
    A_T.Major_other_4Year_Degree_Earned__c , #contact,
    A_T.Meets_Dosage_Recommendation_WF__c ,
    A_T.Met_200_Poverty_Guidelines__c ,
    A_T.Middle_School__c ,
    A_T.Minor__c ,
    A_T.Most_Recent_GPA_Cumulative__c ,
    A_T.Most_Recent_GPA_Semester__c ,
    A_T.Name , #student name, on contact
    A_T.Next_AT__c ,
    A_T.Number_of_Academic_Terms_Power_of_One__c ,
    A_T.ORIGINAL_COHORT__c ,
    A_T.On_Track__c ,
    A_T.Oncampus_Housing__c ,
    A_T.Online_Coursework_COVID19__c ,
    A_T.Orphan_Ward_of_the_Court_Foster_Youth_C__c ,
    A_T.Overall_Official_Tests_Taken__c ,
    A_T.PS_Internships__c ,
    A_T.Persistence_AT_Prev_Enrollment_Status__c ,
    A_T.Persistence_AT_Previous_School_Type__c ,
    A_T.Persistence_AT_Previous_School__c ,
    A_T.Persistence_AT__c ,
    A_T.Personal_WellBeing__c ,
    A_T.PostGraduate_Plans_5075_creds__c ,
    A_T.Post_Graduate_Opportunities_75_cred__c ,
    A_T.Post_Secondary_Flag_Check__c ,
    A_T.Post_Secondary_Opt_in__c ,
    A_T.Prev_Prev_As__c , #indicator: previous previous at,
    A_T.Previous_AS__c , #indicator: previous at,
    A_T.Previous_AY_Summer__c ,
    A_T.Previous_Academic_Semester__c ,
    A_T.Previous_Academic_Term_Id__c ,
    A_T.Previous_PAT_Cumulative_Credits_Awarded__c ,
    A_T.Program_Rec_Summer_Writing__c ,
    A_T.Program_Rec_NSO__c ,
    A_T.Pronouns__c ,
    A_T.Qualifies_for_FRL__c ,
    A_T.Rationale_for_Non_Admittance__c ,
    A_T.Readiness_10th_Composite__c ,
    A_T.Readiness_10th_English__c ,
    A_T.Readiness_10th_Math__c ,
    A_T.Readiness_11th_Composite__c,
    A_T.Readiness_11th_English__c ,
    A_T.Readiness_11th_Math__c ,
    A_T.Readiness_9th_Composite__c ,
    A_T.Readiness_9th_English__c ,
    A_T.Readiness_9th_Math__c ,
    A_T.Readiness_Composite_Off__c ,
    A_T.Readiness_English_Official__c ,
    A_T.Readiness_Math_Official__c ,
    A_T.Reason_For_Leaving_Dismissal__c ,
    A_T.Reason_Transcript_Not_Available__c ,
    A_T.Reason_for_Inactivity__c ,
    A_T.Reason_for_CC_Services_Opt_Out__c ,
    A_T.Received_College_Credit_for_Internship__c ,
    A_T.RecordTypeId ,
    A_T.Recruitment_Model_at_Site__c ,
    A_T.Region_Specific_Funding_Eligibility__c ,
    A_T.Region__c ,
    A_T.Repayment_Plan__c ,
    A_T.Repayment_Policies__c ,
    A_T.ResumeCover_Letter__c ,
    A_T.Reverse_Transfer__c ,
    A_T.SAT_Essay_highest_official__c ,
    A_T.SAT_Highest_Total_single_sitting__c ,
    A_T.SAT_Math_highest_official__c ,
    A_T.SAT_Official_Tests_Taken__c ,
    A_T.SAT_Reading_Writing_highest_official__c ,
    A_T.SAT_SuperScore_Official__c ,
    A_T.STATESTUDENTID__c ,
    A_T.STUDENTHASANIEP__c ,
    A_T.Schedule_Type_Reason__c ,
    A_T.Schedule_Type__c ,
    A_T.Scholarship_Requirements__c ,
    A_T.School_Academic_Calendar__c ,
    A_T.School_Account_18_ID__c ,
    A_T.School_Name ,
    A_T.School_Predominant_Degree_Awarded__c ,
    A_T.School__c , #id
    A_T.Scorecard_Color_Reason_s__c ,
    A_T.Second_Major__c ,
    A_T.Service_Earnings__c ,
    A_T.Service_Hours_AS__c ,
    A_T.Service_Hours_Completed__c ,
    A_T.Site_Dosage_Rec_CC__c ,
    A_T.Site_Dosage_Rec_Math__c ,
    A_T.Site_Dosage_Rec_SL__c ,
    A_T.Site_Dosage_Rec_Test_Pre__c ,
    A_T.Site_Dosage_Rec_Tutoring__c ,
    A_T.Site_Text__c ,
    A_T.Situational_Best_Fit_College_Apps__c ,
    A_T.Size_of_Household__c ,
    A_T.Social_Emotional_Scorecard_Color__c ,
    A_T.Social_Emotional_Scorecard_Reason_s__c ,
    A_T.Social_Stability__c ,
    A_T.Standing__c ,
    A_T.Start_Date__c ,
    A_T.Starting_Semester__c ,
    A_T.Student_Has_IEP__c ,
    A_T.Student_Starting_Grade__c ,
    A_T.Student__c , #id,
    A_T.Student_s_Start_Academic_Year__c ,
    A_T.Study_Resources__c ,
    A_T.Term__c ,
    A_T.Total_BB_Earnings_as_of_HS_Grad_contact__c ,
    A_T.Total_Bank_Book_Balance_contact__c ,
    A_T.Total_Bank_Book_Earnings_current__c ,
    A_T.Total_Community_Service_Hours_Completed__c ,
    A_T.Transcript_Provided__c ,
    A_T.Transfer_2Year_Schools_Only__c , 
    A_T.Two_Year_College_Acceptances__c ,
    A_T.Two_Year_College_Applications__c ,
    A_T.Two_Year_College_Enrollments__c ,
    A_T.Type_of_Degree_Earned__c ,
    A_T.Wellness_COVID19__c ,
    A_T.Wellness_Intervention_Needed__c ,
    A_T.Wellness_Intervention_Received__c ,
    A_T.Workshops_Attended_Last_7_Days__c ,
    A_T.Workshops_Attended_Prior_Week__c ,
    A_T.X18_Digit_ID__c ,
    A_T.X9th_Grade_End_of_Year_Diagnostic__c ,
    A_T.X9th_Grade_Family_Affordability_Workshop__c ,
    A_T.Year_1_College_Math_Course_Grade__c ,
    A_T.Year_1_College_Math_Course_Other__c ,
    A_T.Year_Fraction_Since_HS_Grad__c , 
    A_T.Years_Since_HS_Grad__c , Years_to_Complete_4Year_Degree__c ,
    A_T.college_applications_all_fit_types__c ,
    A_T.eFund__c ,
    A_T.of_Best_Fit_College_Applications__c ,
    A_T.of_Good_Fit_College_Applications__c ,
    A_T.of_High_School_Terms_on_Intervention__c ,
    A_T.of_PS_Academic_Term_Records__c , #on AT. number of PS AT records with Enrollment Status of part-time or full-time
    A_T.of_Post_Secondary_AS__c , #on contact. number of PS AT records with Enrollment Status of part-time or full-time,
    A_T.region ,
    A_T.region_short ,
    A_T.site_short,
    CA.Student__c  AS contact_id,
    CA.College_Track_Site__c, 
    CA.ACT_Required_CB__c,
    CA.Admissions_Acceptance_Date__c,
    CA.Appeal_Status__c,
    CA.Application_Deadline__c ,
    CA.Application_Fee__c ,
    CA.Application_Schedule__c ,
    CA.Application_Type__c ,
    CA.Application_fee_waiver_granted__c ,
    CA.Application_status__c ,
    CA.Art_Portfolio_Required_app__c ,
    CA.Art_Portfolio_Status__c ,
    CA.Assesment_Test_Completed__c ,
    CA.Average_Financial_Aid_Package__c ,
    CA.Avg_Debt_of_Graduates__c ,
    CA.CSS_Profile_Required__c ,
    CA.CSS_Profile__c AS CSS_profile_status,
    CA.College_Fit_Type_Applied__c ,
    CA.College_Track_Deadline__c ,
    CA.College_Track_Status__c ,
    CA.College_University_Academic_Calendar__c,
    CA.College_University__c AS college_id,
    CA.Common_App_Accepted_at_School__c, #from college account
    CA.Common_App_Counselor_Report_Status__c ,
    CA.Common_App_Counselor_Report__c ,
    CA.Comparison_ACT_Composite_Average__c ,
    CA.Comparison_GPA__c ,
    CA.Comparison_SAT_Combined_Average__c ,
    CA.Control_of_Institution__c , #private or public school
    CA.CreatedDate,
    CA.Created_via_Matching__c ,
    CA.Current_Grade__c ,
    CA.Essay_1__c ,
    CA.Fit_Type_Current__c ,
    CA.Fit_Type_Enrolled__c,
    CA.High_School_Class__c ,
    CA.Id AS college_app_id,
    CA.Interview_Requirements__c, 
    CA.Letter_of_Recommendation_1__c  ,
    CA.Predominant_Degree_Awarded__c ,
    CA.Reason_for_Application_Fee_Request__c ,
    CA.Requested_Application_Fee_Payment__c ,
    CA.Requested_application_fee_waiver__c ,
    CA.SAT_Reasoning_Required_CB__c ,
    CA.SAT_Subject_Required_CB__c ,
    CA.School_Financial_Aid_Form_Status__c ,
    CA.School_s_Financial_Aid_Form_Required__c ,
    CA.Situational_Fit_Type__c ,
    CA.Strategic_Type__c AS match_type, #match type
    CA.Student_ACT_Highest_Composite_Single_Sit__c ,
    CA.Student_GPA_Cumulative__c ,
    CA.Student_ID_Number__c , #if student is accepted to college
    CA.Student_SAT_Highest_Comp_Single_Sit__c ,
    CA.Submitted_Proof_Of_College_Admissions__c ,
    CA.Transcripts__c ,
    CA.Type_of_School__c ,
    CA.admission_status__c
    FROM `data-warehouse-289815.salesforce_raw.College_Application__c` AS CA
    
    --Join  college applications data with contact_at template
    LEFT JOIN `data-warehouse-289815.sfdc_templates.contact_at_template` AS A_T
    ON CA.Student__c = A_T.Student__c
    --LIMIT 50
    )

SELECT *
FROM college_application_AT