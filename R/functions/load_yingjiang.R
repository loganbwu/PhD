library(tidyverse)
library(readxl)

load_yingjiang = function(path = "data/china/Yingjiang County Malaria Incidence 1986-2020.xlsx",
                          dir = NULL) {
  if (!is.null(dir)) {
    path = file.path(dir, path)
  }
  
  headers = c("Year",
              "Population",
              sapply(1:12, function(x) {paste(x, c("Falciparum", "Vivax", "Other"))}))
  
  data = read_excel(path,
                    col_names=headers, skip=2) %>%
    pivot_longer(-c(Year, Population), values_to = "Cases") %>%
    separate(name, c("Month", "Species")) %>%
    drop_na() %>%
    mutate(Date = as_date(paste(Year, Month, "15", sep="-"))) %>%
    group_by(Date) %>%
    summarise(Cases = sum(Cases)) %>%
    mutate(logCases = log(Cases + 0.01))
  
  data
}