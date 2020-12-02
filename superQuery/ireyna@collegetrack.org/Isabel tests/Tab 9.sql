SELECT 
count (distinct Contact_Id)

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
