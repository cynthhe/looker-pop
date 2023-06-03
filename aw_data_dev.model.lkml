explore: +ios_subscriptions {
  view_name: ios_subscriptions
  group_label: "App Subscriptions"
  label: "iOS Subscription Data"
  description: "This Explore will expose iOS subscription event data from App Store Connect."
  sql_always_where:
    1=1
    {% if order_items.current_vs_previous_period_advanced._in_query %}AND ${order_items.current_vs_previous_period_advanced} IS NOT NULL{% endif %}
    {% if parameters.apply_to_date_filter_advanced._is_filtered %}AND ${order_items.is_to_date_advanced}{% endif %}
   ;;
  join: parameters {}
}
