SELECT WSA_Id, Workshop_Dosage_Type__c, dosage_split, Attendance_Numerator__c, Attendance_Denominator__c
FROM `data-studio-260217.attendance_dashboard.tmp_filtered_attendance`
WHERE  Workshop_Global_Academic_Semester__c = 'Fall 2020-21' AND GPA_Bucket = "3.5 or Greater" AND Date__c < "2020-08-25"
GROUP BY GPA_Bucket