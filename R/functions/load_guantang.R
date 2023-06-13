library(tidyverse)
library(readxl)

load_guantang = function(path = "data/china/Guantang Malaria 1971-1983.xlsx",
                         dir = NULL) {
  if (!is.null(dir)) {
    path = file.path(dir, path)
  }
  
  data = read_excel(path) %>%
    mutate(Date = as_date(paste(Year, Month, "15", sep="-")),
           logCases = log(Cases + 0.01)) %>%
    select(Date, Cases, logCases)
  
  data
}