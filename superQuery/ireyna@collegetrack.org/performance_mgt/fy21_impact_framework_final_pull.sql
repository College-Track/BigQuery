
    SELECT
        if_site_sort,
        site_short,
        persistence_denominator AS num_matriculation,
        persistence_denominator / twelfth_grade_count AS matriculation,
        matriculated_affordable AS num_matriculated_affordable,
        twelfth_grade_count AS num_matriculation_affordable,
        matriculated_affordable / twelfth_grade_count AS matriculation_affordable_college,
        
        college_first_enrolled_school_type_numerator
    

    FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics` 
    
   /*
Percent of Students on Track to Earn Bachelor's Degree within 6 years
Matriculation to a 4-yr College
Freshman Persistence Rate
Matriculation Rate
Matriculation to Good, Best, or Situational Best Fit colleges
Matriculation to Affordable colleges
Active college students complete at least 1 internship before graduation
    */