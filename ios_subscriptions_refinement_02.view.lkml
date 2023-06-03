view: +ios_subscriptions {

#####  CURRENT/REFERENCE [Timeframe] VS PREVIOUS [Timeframe] with dynamic labels and default to today

  dimension: current_vs_previous_period_advanced {
    label: "Current vs Previous Period"
    hidden: yes
    description: "Use this dimension alongside \"Select Timeframe\" and \"Select Comparison Type\" Filters to compare a specific timeframe (month, quarter, year) and the corresponding one of the previous year"
    type: string
    sql:
      {% if parameters.select_timeframe_advanced._parameter_value == "ytd" %}
        CASE
          WHEN ${ios_subscriptions.created_date} BETWEEN DATE_TRUNC(DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, YEAR), MONTH) AND DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, DAY)
            THEN ${selected_dynamic_timeframe_advanced}
          WHEN ${ios_subscriptions.created_date} BETWEEN DATE_TRUNC(DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 YEAR), YEAR), MONTH) AND DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 YEAR), MONTH)
            THEN ${selected_dynamic_timeframe_advanced}
          ELSE NULL
        END
      {% else %}
        {% if parameters.select_comparison._parameter_value == "year" %}
          CASE
            WHEN DATE_TRUNC(${ios_subscriptions.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, {% parameter parameters.select_timeframe_advanced %})
              THEN ${selected_dynamic_timeframe_advanced}
            WHEN DATE_TRUNC(${ios_subscriptions.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 YEAR), {% parameter parameters.select_timeframe_advanced %})
              THEN ${selected_dynamic_timeframe_advanced}
            ELSE NULL
          END
        {% elsif parameters.select_comparison._parameter_value == "period" %}
          CASE
            WHEN DATE_TRUNC(${ios_subscriptions.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, {% parameter parameters.select_timeframe_advanced %})
              THEN ${selected_dynamic_timeframe_advanced}
            WHEN DATE_TRUNC(${ios_subscriptions.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 {% parameter parameters.select_timeframe_advanced %}), {% parameter parameters.select_timeframe_advanced %})
              THEN ${selected_dynamic_timeframe_advanced}
            ELSE NULL
          END
        {% endif %}
      {% endif %}
    ;;
  }
  
  dimension: current_vs_previous_period_hidden_advanced {
    label: "Current vs Previous Period (Hidden - for measure only)"
    hidden: yes
    description: "Hide this measure so that it doesn't appear in the field picket and use it to filter measures (since the values are static)"
    type: string
    sql:
      {% if parameters.select_timeframe_advanced._parameter_value == "ytd" %}
        CASE
          WHEN ${ios_subscriptions.created_date} BETWEEN DATE_TRUNC(DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, YEAR), MONTH) AND DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, DAY)
            THEN 'reference'
          WHEN ${ios_subscriptions.created_date} BETWEEN DATE_TRUNC(DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 YEAR), YEAR), MONTH) AND DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 YEAR), MONTH)
            THEN 'comparison'
          ELSE NULL
        END
      {% else %}
        {% if parameters.select_comparison._parameter_value == "year" %}
          CASE
            WHEN DATE_TRUNC(${ios_subscriptions.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, {% parameter parameters.select_timeframe_advanced %})
              THEN 'reference'
            WHEN DATE_TRUNC(${ios_subscriptions.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 YEAR), {% parameter parameters.select_timeframe_advanced %})
              THEN 'comparison'
            ELSE NULL
          END
        {% elsif parameters.select_comparison._parameter_value == "period" %}
          CASE
            WHEN DATE_TRUNC(${ios_subscriptions.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(${parameters.selected_reference_date_default_today_advanced_raw}, {% parameter parameters.select_timeframe_advanced %})
              THEN 'reference'
            WHEN DATE_TRUNC(${ios_subscriptions.created_raw},  {% parameter parameters.select_timeframe_advanced %}) = DATE_TRUNC(DATE_SUB(${parameters.selected_reference_date_default_today_advanced_raw}, INTERVAL 1 {% parameter parameters.select_timeframe_advanced %}), {% parameter parameters.select_timeframe_advanced %})
              THEN 'comparison'
            ELSE NULL
          END
        {% endif %}
      {% endif %}
    ;;
  }
}