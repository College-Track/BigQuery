WITH gather_data AS(
  SELECT
    Contact_Id,
    full_name_c,
    current_cc_advisor_2_c,
    current_enrollment_status_c,
    Current_school_name,
    Most_Recent_GPA_Cumulative_bucket,
    sort_Most_Recent_GPA_Cumulative_bucket,
    most_recent_gpa_semester_bucket,
    grade_c,
    CASE
      WHEN credit_accumulation_pace_c IS NULL THEN "No Data"
      ELSE credit_accumulation_pace_c
    END AS credit_accumulation_pace_c,
    high_school_graduating_class_c,
    credits_accumulated_most_recent_c,
    anticipated_date_of_graduation_ay_c,
    site_short,
    site_sort,
    site_abrev,
    region_short,
    region_abrev,
    school_type,
    Advising_Rubric_Academic_Readiness_c,
    Advising_Rubric_Career_Readiness_c,
    Advising_Rubric_Financial_Success_c,
    Advising_Rubric_Wellness_c,
    CASE
      WHEN advising_rubric_financial_success_v_2_c = "Red" THEN 1
      WHEN advising_rubric_financial_success_v_2_c = "Yellow" THEN 2
      WHEN advising_rubric_financial_success_v_2_c = "Green" THEN 3
      ELSE 4
    END AS sort_Advising_Rubric_Financial_Success_sort,
    CASE
      WHEN advising_rubric_academic_readiness_v_2_c = "Red" THEN 1
      WHEN advising_rubric_academic_readiness_v_2_c = "Yellow" THEN 2
      WHEN advising_rubric_academic_readiness_v_2_c = "Green" THEN 3
      ELSE 4
    END AS sort_Advising_Rubric_Academic_Readiness_sort,
    CASE
      WHEN advising_rubric_career_readiness_v_2_c = "Red" THEN 1
      WHEN advising_rubric_career_readiness_v_2_c = "Yellow" THEN 2
      WHEN advising_rubric_career_readiness_v_2_c = "Green" THEN 3
      ELSE 4
    END AS sort_Advising_Rubric_Career_Readiness_sort,
    CASE
      WHEN advising_rubric_wellness_v_2_c = "Red" THEN 1
      WHEN advising_rubric_wellness_v_2_c = "Yellow" THEN 2
      WHEN advising_rubric_wellness_v_2_c = "Green" THEN 3
      ELSE 4
    END AS sort_Advising_Rubric_Wellness_sort,
    CASE
      WHEN credits_accumulated_most_recent_c IS NULL THEN "Frosh"
      WHEN credits_accumulated_most_recent_c < 25 THEN "Frosh"
      WHEN credits_accumulated_most_recent_c < 50 THEN "Sophomore"
      WHEN credits_accumulated_most_recent_c < 75 THEN "Junior"
      WHEN credits_accumulated_most_recent_c >= 75 THEN "Senior"
    END AS college_class,
  FROM
    `data-warehouse-289815.salesforce_clean.contact_at_template`
  WHERE
    current_as_c = True
    AND college_track_status_c = '15A'
),
gather_all_communication_data AS (
  SELECT
    who_id,
    reciprocal_communication_c,
    CASE
      WHEN activity_date = date_of_contact_c THEN date_of_contact_c
      WHEN date_of_contact_c IS NULL
      and activity_date IS NOT NULL THEN activity_date
      ELSE date_of_contact_c
    END AS date_of_contact_c,
    subject,
    id AS task_id,
    description,
    type
  FROM
    `data-warehouse-289815.salesforce.task`
),
gather_communication_data AS (
  SELECT
    GACD.*
  FROM
    gather_all_communication_data GACD
    LEFT JOIN `data-warehouse-289815.salesforce_clean.contact_at_template` CAT ON CAT.Contact_Id = who_id
  WHERE
    CAT.current_as_c = true
    AND (
      (
        CAT.grade_c != "Year 1"
        AND date_of_contact_c BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)
        AND CURRENT_DATE()
      )
      OR (
        CAT.grade_c = "Year 1"
        AND date_of_contact_c BETWEEN DATE_SUB(CAT.AY_Start_Date, INTERVAL 90 DAY)
        AND CURRENT_DATE()
      )
    )
),
group_outreach_communication_data AS (
  SELECT
    who_id,
    format_date('%Y-%W', date_of_contact_c) AS year_week_outreach,
    COUNT(task_id) as count_unique_outreach
  FROM
    gather_communication_data
  GROUP BY
    who_id,
    format_date('%Y-%W', date_of_contact_c)
),
count_unique_outreach AS (
  SELECT
    who_id,
    COUNT(year_week_outreach) AS num_unique_outreach
  FROM
    group_outreach_communication_data
  GROUP BY
    who_id
),
most_recent_reciprocal AS (
  SELECT
    who_id,
    MAX(date_of_contact_c) AS most_recent_reciprocal_date,
    MIN(date_of_contact_c) AS first_reciprocal_date,
    COUNT(task_id) AS num_of_reciprocal_comms
  FROM
    gather_communication_data
  WHERE
    reciprocal_communication_c = TRUE
  GROUP BY
    who_id
),
most_recent_outreach AS (
  SELECT
    who_id,
    MAX(date_of_contact_c) AS most_recent_outreach_date,
    MIN(date_of_contact_c) AS first_outreach_date,
    COUNT(task_id) AS num_of_outreach_comms
  FROM
    gather_communication_data
  GROUP BY
    who_id
),
prep_com_metrics AS (
  SELECT
    MRO.who_id,
    MRR.most_recent_reciprocal_date,
    MRR.first_reciprocal_date,
    MRR.num_of_reciprocal_comms,
    MRO.most_recent_outreach_date,
    MRO.first_outreach_date,
    MRO.num_of_outreach_comms,
    CUO.num_unique_outreach,
    ABS(
      DATE_DIFF(
        CURRENT_DATE(),
        MRO.first_outreach_date,
        DAY
      )
    ) AS days_between_today_first_outreach,
    ABS(
      DATE_DIFF(MRO.most_recent_outreach_date, CURRENT_DATE, DAY)
    ) AS days_between_most_recent_outreach,
    ABS(
      DATE_DIFF(
        MRR.most_recent_reciprocal_date,
        CURRENT_DATE,
        DAY
      )
    ) AS days_between_most_recent_reciprocal,
  FROM
    most_recent_outreach MRO
    LEFT JOIN most_recent_reciprocal MRR ON MRR.who_id = MRO.who_id
    LEFT JOIN count_unique_outreach CUO ON CUO.who_id = MRO.who_id
),
join_data AS (
  SELECT
    GD.*,
    PCM.most_recent_reciprocal_date,
    PCM.first_reciprocal_date,
    PCM.days_between_most_recent_reciprocal,
    PCM.num_of_reciprocal_comms,
    PCM.most_recent_outreach_date,
    PCM.first_outreach_date,
    PCM.num_of_outreach_comms,
    PCM.num_unique_outreach,
    PCM.days_between_today_first_outreach,
    PCM.days_between_most_recent_outreach,
    CASE
      WHEN PCM.num_unique_outreach IS NULL THEN NULL
      WHEN PCM.num_unique_outreach = 1 THEN NULL
      ELSE PCM.days_between_today_first_outreach /(PCM.num_unique_outreach - 1)
    END AS avg_days_between_outreach -- GCD.*
    --   EXCEPT(who_id),
    -- CASE
    --   WHEN MRR.num_of_reciprocal_comms IS NULL THEN NULL
    --   WHEN MRR.num_of_reciprocal_comms = 1 THEN NULL
    --   ELSE ABS(
    --     DATE_DIFF(
    --       CURRENT_DATE(),
    --       MRR.first_reciprocal_date,
    --       DAY
    --     )
    --   ) / (MRR.num_of_reciprocal_comms - 1)
    -- END AS avg_days_between_reciprocal,
  FROM
    gather_data GD
    LEFT JOIN prep_com_metrics PCM ON PCM.who_id = GD.Contact_Id
),
calc_metrics AS (
  SELECT
    *,
    CASE
      WHEN days_between_most_recent_reciprocal <= 30 THEN 1
      ELSE 0
    END AS reciprocal_30_days_or_less,
    CASE
      WHEN days_between_most_recent_reciprocal > 60 THEN 1
      ELSE 0
    END AS reciprocal_more_than_60_days,
    CASE
      WHEN days_between_most_recent_outreach <= 30 THEN 1
      ELSE 0
    END AS outreach_30_days_or_less,
    CASE
      WHEN days_between_most_recent_outreach > 60 THEN 1
      ELSE 0
    END AS outreach_more_than_60_days,
    
     CASE
      WHEN days_between_most_recent_reciprocal <= 7 THEN " <= 7 Days"
      WHEN days_between_most_recent_reciprocal <= 14 THEN "8-14 Days"
      WHEN days_between_most_recent_reciprocal <= 30 THEN "15-30 Days"
      WHEN days_between_most_recent_reciprocal <= 45 THEN "31-45 Days"
      WHEN days_between_most_recent_reciprocal <= 60 THEN "46-60 Days"
      WHEN days_between_most_recent_reciprocal <= 90 THEN "61-90 Days"
      WHEN days_between_most_recent_reciprocal > 90 THEN "90+ Days"
      ELSE "No Valid Reciprocal"
    END AS days_between_reciprocal_bucket_granual,
    CASE
      WHEN days_between_most_recent_reciprocal <= 7 THEN 1
      WHEN days_between_most_recent_reciprocal <= 14 THEN 2
      WHEN days_between_most_recent_reciprocal <= 30 THEN 3
      WHEN days_between_most_recent_reciprocal <= 45 THEN 4
      WHEN days_between_most_recent_reciprocal <= 60 THEN 5
      WHEN days_between_most_recent_reciprocal <= 90 THEN 6
      WHEN days_between_most_recent_reciprocal > 90 THEN 7
      ELSE 0
    END AS sort_days_between_reciprocal_bucket_granual,
        CASE
      WHEN days_between_most_recent_outreach <= 7 THEN "<= 7 Days"
      WHEN days_between_most_recent_outreach <= 14 THEN "8-14 Days"
      WHEN days_between_most_recent_outreach <= 30 THEN "15-30 Days"
      WHEN days_between_most_recent_outreach <= 45 THEN "31-45 Days"
      WHEN days_between_most_recent_outreach <= 60 THEN "46-60 Days"
      WHEN days_between_most_recent_outreach <= 90 THEN "61-90 Days"
      WHEN days_between_most_recent_outreach > 90 THEN "90+ Days"
      ELSE "No Valid Outreach"
    END AS days_between_outreach_bucket_granual,
    CASE
      WHEN days_between_most_recent_outreach <= 7 THEN 1
      WHEN days_between_most_recent_outreach <= 14 THEN 2
      WHEN days_between_most_recent_outreach <= 30 THEN 3
      WHEN days_between_most_recent_outreach <= 45 THEN 4
      WHEN days_between_most_recent_outreach <= 60 THEN 5
      WHEN days_between_most_recent_outreach <= 90 THEN 6
      WHEN days_between_most_recent_outreach > 90 THEN 7
      ELSE 0
    END AS sort_days_between_outreach_bucket_granual,
    
    CASE
      WHEN days_between_most_recent_reciprocal <= 30 THEN "30 Days or Less"
      WHEN days_between_most_recent_reciprocal <= 60 THEN "60 Days or Less"
      WHEN days_between_most_recent_reciprocal > 60 THEN "61+ Days"
      ELSE "No Valid Reciprocal"
    END AS days_between_reciprocal_bucket,
    CASE
      WHEN days_between_most_recent_reciprocal <= 30 THEN 1
      WHEN days_between_most_recent_reciprocal <= 60 THEN 2
      WHEN days_between_most_recent_reciprocal > 60 THEN 3
      ELSE 0
    END AS sort_days_between_reciprocal_bucket,
    CASE
      WHEN days_between_most_recent_outreach <= 30 THEN "30 Days or Less"
      WHEN days_between_most_recent_outreach <= 60 THEN "60 Days or Less"
      WHEN days_between_most_recent_outreach > 60 THEN "61+ Days"
      ELSE "No Valid Outreach"
    END AS days_between_outreach_bucket,
    CASE
      WHEN days_between_most_recent_outreach <= 30 THEN 1
      WHEN days_between_most_recent_outreach <= 60 THEN 2
      WHEN days_between_most_recent_outreach > 60 THEN 3
      ELSE 0
    END AS sort_days_between_outreach_bucket,
    CASE
      WHEN credit_accumulation_pace_c IS NULL THEN 0
      WHEN credit_accumulation_pace_c = '4-Year Track' THEN 1
      WHEN credit_accumulation_pace_c = '5-Year Track' THEN 2
      WHEN credit_accumulation_pace_c = '6-Year Track' THEN 3
      WHEN credit_accumulation_pace_c = '6+ Years' THEN 4
      ELSE 0
    END AS sort_credit_accumulation_pace_c,
  FROM
    join_data
),
add_rubric_sections AS (
  SELECT
    calc_metrics.*,
    value.*
  FROM
    calc_metrics,
    UNNEST(
      `data-warehouse-289815.UDF.unpivot`(calc_metrics, 'sort_Advising_Rubric_')
    ) value
)
SELECT
  *
EXCEPT(key, value),
  value AS rubric_sort,
  CASE
    WHEN value IS NULL THEN "No Data"
    WHEN value = '4' THEN "No Data"
    WHEN value = '3' THEN "Green"
    WHEN value = '2' THEN "Yellow"
    WHEN value = '1' THEN "Red"
    ELSE "No Data"
  END AS rubric_section_color,
  CASE
    WHEN key = 'sort_Advising_Rubric_Career_Readiness_sort' THEN "Career"
    WHEN key = 'sort_Advising_Rubric_Wellness_sort' THEN 'Wellness'
    WHEN key = 'sort_Advising_Rubric_Financial_Success_sort' THEN "Finance"
    WHEN key = 'sort_Advising_Rubric_Academic_Readiness_sort' THEN "Academic"
  END AS rubric_section
FROM
  add_rubric_sections