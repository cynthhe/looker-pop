### VIEW DESCRIPTION ###

# This view contains the dynamic period over period filter to be used in other views that support Databricks SQL.

view: pop_block {
  extension: required # Anytime this is extended into another view, make sure that you are using a dummy join in

### FILTERS ###

  filter: pop_date_filter {
    view_label: "Period Over Period"
    label: "Period Over Period Date Filter"
    description: "Use this date filter in explores to create period over period dynamic date filters."
    type:  date
    sql: ${period} IS NOT NULL ;;
  }

### DIMENSIONS ###

  dimension_group: filter_start {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CASE WHEN {% date_start pop_date_filter %} IS NULL THEN '2010-01-01' ELSE CAST({% date_start pop_date_filter %} AS DATE) END ;;
  }

  dimension_group: filter_end {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CASE WHEN {% date_end pop_date_filter %} IS NULL THEN CURRENT_DATE() ELSE CAST({% date_end pop_date_filter %} AS DATE) END ;;
  }

  dimension: interval {
    hidden: yes
    type: number
    sql: DATEDIFF(${filter_end_raw}, ${filter_start_raw}) + 1 ;; # Ensure full previous period coverage
  }

  dimension: previous_start_date {
    hidden: yes
    type: string
    sql: DATEADD(${filter_start_raw}, -${interval}) ;; # Shift previous period back by full interval
  }

  dimension: period {
    view_label: "Period Over Period"
    label: "Period Over Period Timeframes"
    description: "Will display current period vs. previous period based on date filter selection."
    type: string
    case: {
      when: {
        sql: ${is_current_period} = true ;;
        label: "Current Period"
      }
      when: {
        sql: ${is_previous_period} = true ;;
        label: "Previous Period"
      }
    }
  }

  dimension: is_current_period { # Make sure to add any new models to this dimension for correct PoP analysis
    hidden: yes
    type: yesno
    sql:
      ${common_date_for_extension} >= ${filter_start_date} AND ${common_date_for_extension} < ${filter_end_date} ;;
  }

  dimension: is_previous_period { # Make sure to add any new models to this dimension for correct PoP analysis
    hidden: yes
    type: yesno
    sql:
      ${common_date_for_extension} >= ${previous_start_date} AND ${common_date_for_extension} < ${filter_start_date} ;;
  }
}
