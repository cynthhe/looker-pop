view: +ios_subscriptions { 

### replace any reference to order_items by the view of your choosing
### We're assuming here that the date dimension we want to leverage in the PoP is order_items.created_date labeled as "Orders Date"

  dimension: created_month_of_quarter_advanced {
    label: "Events Month of Quarter"
    group_label: "Event Date"
    group_item_label: "Month of Quarter"
    type: number
    sql:
      case
        when ${ios_subscriptions.created_month_num} IN (1,4,7,10) THEN 1
        when ${ios_subscriptions.created_month_num} IN (2,5,8,11) THEN 2
        else 3
      end
    ;;
  }

  dimension: is_to_date_advanced {
    hidden: yes
    type: yesno
    sql:
      {% if parameters.select_timeframe_advanced._parameter_value == 'ytd' %}true
      {% else %}
        {% if parameters.apply_to_date_filter_advanced._parameter_value == 'true' %}
          {% if parameters.select_timeframe_advanced._parameter_value == 'week' %}
            ${ios_subscriptions.created_day_of_week_index} <= ${parameters.current_timestamp_advanced_day_of_week_index}
          {% elsif parameters.select_timeframe_advanced._parameter_value == 'day' %}
            ${ios_subscriptions.created_hour_of_day} <= ${parameters.current_timestamp_advanced_hour_of_day}
          {% elsif parameters.select_dynamic_timeframe_advanced._parameter_value == 'quarter' %}
            ${ios_subscriptions.created_month_of_quarter_advanced} <= ${parameters.current_timestamp_month_of_quarter_advanced}
          {% elsif parameters.select_timeframe_advanced._parameter_value == 'year' %}
            ${ios_subscriptions.created_day_of_year} <= ${parameters.current_timestamp_advanced_day_of_year}
          {% else %}
            ${ios_subscriptions.created_day_of_month} <= ${parameters.current_timestamp_advanced_day_of_month}
          {% endif %}
        {% else %} true
        {% endif %}
      {% endif %}
    ;;
  }

  dimension: selected_dynamic_timeframe_advanced  {
    label_from_parameter: parameters.select_timeframe_advanced
    type: string
    hidden: yes
    sql:
      {% if parameters.select_timeframe_advanced._parameter_value == 'day' %}
        ${ios_subscriptions.event_date}
      {% elsif parameters.select_timeframe_advanced._parameter_value == 'week' %}
        ${ios_subscriptions.created_week}
      {% elsif parameters.select_timeframe_advanced._parameter_value == 'year' %}
        ${ios_subscriptions.created_year}
      {% elsif parameters.select_timeframe_advanced._parameter_value == 'quarter' %}
        ${ios_subscriptions.created_quarter}
      {% elsif parameters.select_timeframe_advanced._parameter_value == 'ytd' %}
        CONCAT('YTD (',${ios_subscriptions.created_year},'-',${parameters.selected_reference_date_default_today_advanced_month_num},'-',${parameters.selected_reference_date_default_today_advanced_day_of_month},')')
      {% else %}
        ${ios_subscriptions.created_month}
      {% endif %}
    ;;
  }

  dimension: selected_dynamic_day_of_advanced  {
    label: "{%
    if parameters.select_timeframe_advanced._is_filtered and parameters.select_timeframe_advanced._parameter_value == 'month' %}Day of Month{%
    elsif parameters.select_timeframe_advanced._is_filtered and parameters.select_timeframe_advanced._parameter_value == 'week' %}Day of Week{%
    elsif parameters.select_timeframe_advanced._is_filtered and parameters.select_timeframe_advanced._parameter_value == 'day' %}Hour of Day{%
    elsif parameters.select_timeframe_advanced._is_filtered and parameters.select_timeframe_advanced._parameter_value == 'year' %}Months{%
    elsif parameters.select_timeframe_advanced._is_filtered and parameters.select_timeframe_advanced._parameter_value == 'ytd' %}Day of Year{%
    else %}Selected Dynamic Timeframe Granularity{%
    endif %}"
    order_by_field: ios_subscriptions.selected_dynamic_day_of_sort_advanced
    type: string
    sql:
    {% if parameters.select_timeframe_advanced._parameter_value == 'day' %}
      ${ios_subscriptions.created_hour_of_day}
    {% elsif parameters.select_timeframe_advanced._parameter_value == 'week' %}
      ${ios_subscriptions.created_day_of_week}
    {% elsif parameters.select_timeframe_advanced._parameter_value == 'year' %}
      ${ios_subscriptions.created_month_name}
    {% elsif parameters.select_timeframe_advanced._parameter_value == 'quarter' %}
      ${ios_subscriptions.created_month_of_quarter_advanced}
      {% elsif parameters.select_timeframe_advanced._parameter_value == 'ytd' %}
      ${ios_subscriptions.created_day_of_year}
    {% else %}
      ${ios_subscriptions.created_day_of_month}
    {% endif %}
    ;;
  }

  dimension: selected_dynamic_day_of_sort_advanced  {
    hidden: yes
    label_from_parameter: parameters.select_timeframe_advanced
    type: number
    sql:
    {% if parameters.select_timeframe_advanced._parameter_value == 'day' %}
      ${ios_subscriptions.created_hour_of_day}
    {% elsif parameters.select_timeframe_advanced._parameter_value == 'week' %}
      ${ios_subscriptions.created_day_of_week_index}
    {% elsif parameters.select_timeframe_advanced._parameter_value == 'year' %}
      ${ios_subscriptions.created_month_num}
    {% elsif parameters.select_timeframe_advanced._parameter_value == 'quarter' %}
      ${ios_subscriptions.created_month_of_quarter_advanced}
    {% elsif parameters.select_timeframe_advanced._parameter_value == 'ytd' %}
      ${ios_subscriptions.created_day_of_year}
    {% else %}
      ${ios_subscriptions.created_day_of_month}
    {% endif %}
    ;;
  }
}
