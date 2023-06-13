library(tidyverse)
library(readxl)

load_deng_towns = function(path = "data/china/Deng County Malaria 1980-2023.xlsx",
                               dir = NULL) {
  if (!is.null(dir)) {
    path = file.path(dir, path)
  }
  
  sheets = excel_sheets(path)
  data = lapply(sheets, function(s) {
    headers = c("Year", "Month", "Township",
                sapply(c("Falciparum", "Vivax", "Mixed"), function(x) {
                  paste(x, c("Local", "Imported"))
                }))
    read_excel(path, s, col_names=headers, skip=3) %>%
      fill(Year)
  }) %>%
    bind_rows() %>%
    mutate(Date = as_date(paste(Year, Month, "15", sep="-"))) %>%
    select(-Year, -Month) %>%
    pivot_longer(-c(Date, Township), values_to = "Cases") %>%
    separate(name, c("Species", "Infection")) %>%
    drop_na() %>%
    group_by(Township, Date) %>%
    summarise(Cases = sum(Cases),
              .groups = "drop") %>%
    mutate(logCases = log(Cases + 0.01))
  
  data
}

load_deng = function(path = "data/china/Deng County Malaria 1980-2023.xlsx",
                         dir = NULL) {
  
  data = load_deng_towns(path, dir) %>%
    group_by(Date) %>%
    summarise(Cases = sum(Cases)) %>%
    mutate(logCases = log(Cases + 0.01))
  
  data
}