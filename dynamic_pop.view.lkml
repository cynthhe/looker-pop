view: dynamic_period_over_period {
  # Anytime this is extended into another view, make sure that you are using a dummy join in
  extension: required

  ############################################################ FILTERS ############################################################

  filter: date_filter {
    view_label: "Period Over Period"
    label: "Period Over Period Date Filter"
    description: "Use this date filter in explores to create period over period dynamic date filters"
    type:  date
    sql: ${period} IS NOT NULL ;;
  }

  ############################################################ DIMENSIONS ############################################################

  dimension_group: filter_start {
    hidden: yes
    type: time
    timeframes: [raw, date]
    sql: CASE WHEN {% date_start date_filter %} IS NULL THEN '2010-01-01' ELSE CAST({% date_start date_filter %} AS DATE) END ;;
  }

  dimension_group: filter_end {
    hidden: yes
    type: time
    timeframes: [raw, date]
    sql: CASE WHEN {% date_end date_filter %} IS NULL THEN CURRENT_DATE ELSE CAST({% date_end date_filter %} AS DATE) END ;;
  }

  dimension: interval {
    hidden: yes
    type: number
    sql: DATE_DIFF(${filter_end_raw}, ${filter_start_raw}, DAY) ;;
  }

  dimension: previous_start_date {
    hidden: yes
    type: string
    sql: DATE_ADD(${filter_start_raw}, INTERVAL -${interval} DAY) ;;
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
      ${common_date_for_extension} >= ${filter_start_date} AND ${common_date_for_extension} < ${filter_end_date}
    ;;
  }

  dimension: is_previous_period { # Make sure to add any new models to this dimension for correct PoP analysis
    hidden: yes
    type: yesno
    sql:
      ${common_date_for_extension} >= ${previous_start_date} AND ${common_date_for_extension} < ${filter_start_date}
    ;;
  }
}
