SELECT TRIM(dosage_split), SUM(Attendance_Numerator__c) 
FROM `data-studio-260217.attendance_dashboard.tmp_filtered_attendance`
GROUP BY TRIM(dosage_split)