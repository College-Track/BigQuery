SELECT
        
        region_short,
        
    --matriculation data
        matriculation_numerator AS num_matriculation,
        matriculated_affordable AS num_matriculation_affordable,
        matriculated_best_good_situational AS num_matriculated_best_good_situational,
        twelfth_grade_count AS senior_denominator,
        
    --persistence data
        indicator_persisted_into_2_nd_year_ct_numerator AS num_persistence,
        persistence_denominator,
    
    --on-track data
        on_track_numerator,
        on_track_denominator,
    
    --college students graduating with 1+ internship
        had_1_plus_internship_numerator,
        had_1_plus_internship_denominator,
        
    --6 year graduation rate
        grade_rate_6_years_current_class_numerator AS num_6_yr_grad_rate,
        grade_rate_6_years_current_class_denom,
    
    --alumni
        alumni_count

    FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics`