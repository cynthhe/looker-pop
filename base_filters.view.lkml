view: base_filters {

  ############################################################ FILTERS ############################################################

  parameter: formatting_style {
    label: "Formatting Style"
    type: unquoted
    default_value: "custom"

    allowed_value: {
      label: "Simple"
      value: "simple"
    }

    allowed_value: {
      label: "Custom"
      value: "custom"
    }
  }
}
