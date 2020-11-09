SELECT dosage_split, SUM(Attendance_Numerator__c), SUM(Attendance_Denominator__c)
FROM `data-studio-260217.attendance_dashboard.tmp_filtered_attendance`
WHERE Outcome__c = 'Absent' AND dosage_split LIKE "%Math%"
GROUP BY dosage_split