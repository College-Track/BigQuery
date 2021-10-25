--site breakdown
    SELECT
        if_site_sort,
        site_short,
        
    --matriculation data
        matriculation_numerator AS num_matriculation,
        matriculated_affordable AS num_matriculation_affordable,
        matriculated_best_good_situational AS num_matriculated_best_good_situational,
        college_first_enrolled_school_type_numerator AS matriculation_4yr,
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
    ;
--region breakdown
SELECT
        region_short,
        
        SUM(matriculation_numerator) AS num_matriculation,
        SUM(matriculated_affordable) AS num_matriculation_affordable,
        SUM(matriculated_best_good_situational) AS num_matriculated_best_good_situational,
        SUM(college_first_enrolled_school_type_numerator) AS matriculation_4yr,
        SUM(twelfth_grade_count) AS senior_denominator,
        
    --persistence data
        SUM(indicator_persisted_into_2_nd_year_ct_numerator) AS num_persistence,
        SUM(persistence_denominator) AS persistence_denominator,
    
    --on-track data
        SUM(on_track_numerator) AS on_track_numerator,
        SUM(on_track_denominator) AS on_track_denominator,
    
    --college students graduating with 1+ internship
        SUM(had_1_plus_internship_numerator) AS had_1_plus_internship_numerator,
        SUM(had_1_plus_internship_denominator) AS had_1_plus_internship_denominator,
        
    --6 year graduation rate
        SUM(grade_rate_6_years_current_class_numerator) AS num_6_yr_grad_rate,
        SUM(grade_rate_6_years_current_class_denom) AS grade_rate_6_years_current_class_denom,
    
    --alumni
        SUM(alumni_count) AS alumni_count,
    
    --MEMO data
        SUM(had_mse_numerator) AS mse_numerator,
        SUM(had_mse_denominator) AS mse_denominator,
        
        SUM(above_80_attendance_memo) AS denom_attendance_80_2_terms,
        SUM(high_school_student_count) AS high_school_student_count

    FROM `data-studio-260217.performance_mgt.fy21_eoy_combined_metrics` 
    GROUP BY
        region_short
