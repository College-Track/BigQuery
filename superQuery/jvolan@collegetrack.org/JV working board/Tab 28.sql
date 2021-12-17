SELECT
    Contact_Id,
    site
    
    FROM `data-warehouse-289815.salesforce_clean.contact_at_template`
    WHERE AT_Record_Type_Name = "College/University Semester"
    AND enrollment_status_c = "Approved Gap Year"
    AND AT_Grade_c = "Year 1"
    AND high_school_graduating_class_c IN ("2020","2019","2018","2017","2016")