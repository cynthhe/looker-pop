### VIEW DESCRIPTION ###
# This view contains the granularity controls to be used in other views.

view: granularity_controls {
  extension: required

### FILTERS ###

  parameter: timeframe_picker {
    label: "Date Granularity Picker"
    description: "Use this picker to change the level of data aggregation."
    type:  unquoted
    allowed_value: { label: "Day" value: "date" }
    allowed_value: { label: "Week" value: "week" }
    allowed_value: { label: "Month" value: "month" }
    allowed_value: { label: "Quarter" value: "quarter" }
    allowed_value: { label: "Year" value: "year" }
    default_value: "date"
  }

### DIMENSIONS ###

  dimension: date_granularity {
    label: "Date Granularity"
    description: "Use this value when you would like to change the aggregation of data in the visualization."
    label_from_parameter: timeframe_picker # see label parameter in allowed values
    sql:
        {% if timeframe_picker._parameter_value == 'date' %} ${dim_date_key_date}
        {% elsif timeframe_picker._parameter_value == 'week' %} ${dim_date_key_week}
        {% elsif timeframe_picker._parameter_value == 'month' %} ${dim_date_key_month}
        {% elsif timeframe_picker._parameter_value == 'quarter' %} ${dim_date_key_quarter}
        {% elsif timeframe_picker._parameter_value == 'year' %} ${dim_date_key_year}
        {% else %} ${dim_date_key_date}
        {% endif %};;
  }

  # ${common_date_for_extension} presents a common access point for this view in extension
  dimension_group: dim_date_key {
    group_label: "Date"
    label: ""
    description: "Common Date that can be used across visualizations. Based on date record was process in our system."
    hidden: yes
    type: time
    timeframes: [
      raw,
      date,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week,
      week_of_year,
      month,
      month_name,
      month_num,
      quarter,
      year,
    ]
    convert_tz: no
    datatype: date
    sql: ${common_date_for_extension} ;;
  }
}
