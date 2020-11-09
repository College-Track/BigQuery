SELECT Workshop_Dosage_Type__c, SUM(Attendance_Numerator__c), SUM(Attendance_Denominator__c)
FROM `data-studio-260217.attendance_dashboard.tmp_filtered_attendance`
WHERE Outcome__c = 'Absent' AND Workshop_Dosage_Type__c LIKE "%Math%" AND Workshop_Global_Academic_Semester__c = 'Fall 2020-21'
GROUP BY Workshop_Dosage_Type__c