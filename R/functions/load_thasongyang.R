library(tidyverse)
library(readxl)

load_thasongyang = function(path = "data/thailand/PCD_export.xlsx",
                            dir = NULL) {
  if (!is.null(dir)) {
    path = file.path(dir, path)
  }
  
  data = read_excel(path) %>%
    filter(punchdate < as_date("2022-12-01")) %>%
    filter(malaria_result %in% c("F+V", "V")) %>%
    mutate(Date = as_date(paste(year(punchdate), month(punchdate), "15", sep="-"))) %>%
    count(Date, name = "Cases") %>%
    mutate(logCases = log(Cases + 0.01))
  
  data
}