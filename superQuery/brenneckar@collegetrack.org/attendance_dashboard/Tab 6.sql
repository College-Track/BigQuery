SELECT Outcome__c, SUM(Attendance_Numerator__c) NUM, SUM(Attendance_Denominator__c) DEN
FROM `data-warehouse-289815.salesforce_raw.Class_Attendance__c`
WHERE Workshop_Global_Academic_Semester__c ='Fall 2020-21 (Semester)' AND Workshop_Dosage_Type__c LIKE '%College Completion%'
GROUP BY Outcome__c