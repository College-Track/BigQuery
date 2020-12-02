SELECT 
Contact_Id,
Full_Name__c,
High_School_Class__c,
Indicator_Years_Since_HS_Grad_to_Date__c,
AT_Grade__c,
School__c,
School_Name,
AT_Enrollment_Status__c,
Enrolled_in_any_college__c,
School_Academic_Calendar__c,
School_Predominant_Degree_Awarded__c,
Historically_Black_College_Univ_HBCU__c
FROM `data-warehouse-289815.sfdc_templates.contact_at_template` as term

LEFT JOIN `data-warehouse-289815.salesforce_raw.Account` as accnt
ON term.School__c = accnt.Id

WHERE 
AT_Record_Type_Name = "College/University Semester"
AND Enrolled_in_any_college__c = TRUE
AND Historically_Black_College_Univ_HBCU__c = TRUE
