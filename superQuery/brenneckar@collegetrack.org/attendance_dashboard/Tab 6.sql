SELECT GPA_Bucket, SUM(Attendance_Numerator) AS Num, SUM(Attendance_Denominator) AS Den, ROUND(SUM(Attendance_Numerator) / SUM(Attendance_Denominator),2) AS rate
FROM `data-studio-260217.attendance_dashboard.tmp_aggregate_attendance`
WHERE  Workshop_Global_Academic_Semester__c = 'Fall 2020-21' 
GROUP BY GPA_Bucket