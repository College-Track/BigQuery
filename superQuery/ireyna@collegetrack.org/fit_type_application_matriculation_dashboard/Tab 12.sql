SELECT High_School_Class,COUNT(High_School_Class)
FROM `data-studio-260217.fit_type_pipeline.filtered_college_application`
where High_School_Class > 2016
GROUP BY High_School_Class