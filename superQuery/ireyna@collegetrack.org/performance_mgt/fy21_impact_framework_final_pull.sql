
    SELECT
        if_site_sort,
        site_short,
        matriculated_affordable,
        twelfth_grade_count,
        matriculated_affordable / twelfth_grade_count AS matriculation_affordable_college,
        SUM(matriculated_affordable) AS matriculated_total,
        SUM(twelfth_grade_count) AS senior_total
       

    FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics` 
    
    GROUP By
         if_site_sort,
        site_short,
        matriculated_affordable,
        twelfth_grade_count,
   /*
Percent of Students on Track to Earn Bachelor's Degree within 6 years
Matriculation to a 4-yr College
Freshman Persistence Rate
Matriculation Rate
Matriculation to Good, Best, or Situational Best Fit colleges
Matriculation to Affordable colleges
Active college students complete at least 1 internship before graduation
    */