SELECT WSA_Id, Workshop_Dosage_Type__c, dosage_split, Attendance_Numerator__c, Attendance_Denominator__c, College_Track_Status__c, College_Track_Status_Name
FROM `data-studio-260217.attendance_dashboard.tmp_filtered_attendance`
WHERE WSA_ID = 'a2z1M000000dkoIQAQ'