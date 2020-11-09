SELECT dosage_split, SUM(Attendance_Numerator) 
FROM `data-studio-260217.attendance_dashboard.tmp_filtered_attendance`
GROUP BY dosage_split