
    SELECT
        if_site_sort,
        site_short,
    --matriculation data
        matriculation_numerator AS num_matriculation,
        matriculation_numerator / twelfth_grade_count AS matriculation,
        
        matriculated_affordable AS num_matriculation_affordable,
        matriculated_affordable / twelfth_grade_count AS matriculation_affordable_college,
        
        matriculated_best_good_situational AS num_matriculated_best_good_situational,
        matriculated_best_good_situational / twelfth_grade_count AS matriculated_best_good_situational,
        
        twelfth_grade_count AS senior_denominator,
        
    --persistence data
        indicator_persisted_into_2_nd_year_ct_numerator AS num_persistence
        indicator_persisted_into_2_nd_year_ct_numerator / persistence_denominator AS freshman_persistencec,
        
        persistence_denominator,


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