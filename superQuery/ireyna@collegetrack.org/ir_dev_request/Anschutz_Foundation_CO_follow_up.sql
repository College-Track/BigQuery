SELECT
        COUNT(DISTINCT contact_id) AS student_total,
        AT_School_Name,
        site_short
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE
        region_short = 'Colorado'
        AND 
        AT_Record_Type_Name = 'High School Semester' AND
            (AT_School_Name LIKE '%Rangeview%' OR
            AT_School_Name  LIKE '%Gateway%' OR
            AT_School_Name  LIKE'%Kunsmiller%' OR
            AT_School_Name  LIKE '%Sheridan%' OR
            AT_School_Name  LIKE '%Abraham%' OR
            AT_School_Name  LIKE '%South%' OR
            AT_School_Name  LIKE '%John F. Kennedy%' OR
            AT_School_Name  LIKE '%Thomas Jefferson%')
        AND College_Track_Status_Name IN ('Current CT HS Student','Leave of Absence')
    GROUP BY
        site_short,
        AT_School_Name