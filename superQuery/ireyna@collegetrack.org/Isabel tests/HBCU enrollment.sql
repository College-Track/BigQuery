SELECT 
Contact_Id,
Full_Name__c,
High_School_Class__c,
Indicator_Years_Since_HS_Grad_to_Date__c,
AT_Grade__c,
School__c,
School_Academic_Calendar__c,
School_Predominant_Degree_Awarded__c
FROM `data-warehouse-289815.sfdc_templates.contact_at_template`
WHERE 
AT_Record_Type_Name = "College/University Semester"