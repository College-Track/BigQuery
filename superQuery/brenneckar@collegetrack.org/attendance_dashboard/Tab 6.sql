SELECT SUM(Attendance_Numerator) AS Num, SUM(Attendance_Denominator) AS Den, ROUND(SUM(Attendance_Numerator) / SUM(Attendance_Denominator),2) AS rate
FROM `data-studio-260217.attendance_dashboard.aggregate_data`
WHERE  Workshop_Global_Academic_Semester__c = 'Fall 2020-21' AND site_abrev = 'PGC'