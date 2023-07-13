peak = function(df, name) {
  if ("Species" %in% names(df)) {
    df %>%
      group_by(shapeName, Species) %>%
      arrange(desc(pick({{name}}))) %>%
      drop_na({{name}}) %>%
      slice(1)
  } else {
    df %>%
      group_by(shapeName) %>%
      arrange(desc(pick({{name}}))) %>%
      drop_na({{name}}) %>%
      slice(1)
  }
}