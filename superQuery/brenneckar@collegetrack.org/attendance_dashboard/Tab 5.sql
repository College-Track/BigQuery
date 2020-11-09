SELECT dosage_split, SUM(Attendance_Numerator__c) AS Num, SUM(Attendance_Denominator__c) AS Den
FROM `data-studio-260217.attendance_dashboard.tmp_filtered_attendance`
WHERE  Workshop_Global_Academic_Semester__c = 'Fall 2020-21' 
GROUP BY dosage_split