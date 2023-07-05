library(tidyverse)
library(readxl)

load_guantang = function(path = "data/china/Guantang Malaria 1971-1983.xlsx",
                         dir = NULL,
                         species = "all") {
  species_all = species == "all"
  
  if (!is.null(dir)) {
    path = file.path(dir, path)
  }
  
  data = read_excel(path) %>%
    mutate(Date = as_date(paste(Year, Month, "15", sep="-")))
  dateseq = tibble(Date = seq(min(data$Date), max(data$Date), by="month"))

  data = data %>%
    mutate(Species = "Vivax") %>%
    filter((Species %in% species) | species_all) %>%
    group_by(Date) %>%
    summarise(Cases = sum(Cases)) %>%
    right_join(dateseq, by="Date") %>%
    mutate(Cases = replace_na(Cases, 0),
           logCases = log(Cases + 0.01))
  
  data
}