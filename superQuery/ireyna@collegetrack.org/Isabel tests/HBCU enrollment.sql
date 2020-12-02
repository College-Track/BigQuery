SELECT 
gay.name, #global academic year
Academic_Year__c,
Contact_Id,
Full_Name__c,
High_School_Class__c,
AT_Name, #academic term name
AT_Id,
Indicator_Years_Since_HS_Grad_to_Date__c,
AT_Grade__c,
School__c,
School_Name,
student_audit_status__c AS  CT_status_at,
AT_Enrollment_Status__c,
Enrolled_in_any_college__c,
School_Academic_Calendar__c,
School_Predominant_Degree_Awarded__c,
Historically_Black_College_Univ_HBCU__c

FROM `data-warehouse-289815.sfdc_templates.contact_at_template` as term

LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` as accnt
ON term.School__c = accnt.Id

LEFT JOIN  `data-warehouse-289815.salesforce_raw.Academic_Year__c` as gay
ON term.Academic_Year__c = gay.id

WHERE 
AT_Record_Type_Name = "College/University Semester"
AND Enrolled_in_any_college__c = TRUE
AND Historically_Black_College_Univ_HBCU__c = TRUE
--AND Academic_Year__c = 'a1b46000000dRR7AAM'
AND student_audit_status__c = "Active: Post-Secondary"
AND gay.name = "AY 2019-20"
