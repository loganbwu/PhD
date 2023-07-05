library(tidyverse)
library(readxl)

load_thasongyang = function(path = "data/thailand/PCD_export.xlsx",
                            dir = NULL,
                            species = "all") {
  species_all = species == "all"
  
  if (!is.null(dir)) {
    path = file.path(dir, path)
  }
  
  data = read_excel(path) %>%
    filter(punchdate < as_date("2022-12-01"),
           malaria_result != "Neg") %>%
    mutate(Date = as_date(paste(year(punchdate), month(punchdate), "15", sep="-")),
           Species = case_when(malaria_result == "F" ~ "Falciparum",
                               malaria_result == "V" ~ "Vivax",
                               malaria_result == "F+V" ~ "Mixed",
                               TRUE ~ NA))
  dateseq = tibble(Date = seq(min(data$Date), max(data$Date), by="month"))
  data = data %>%
    filter((Species %in% species) | species_all) %>%
    count(Date, name = "Cases") %>%
    right_join(dateseq, by="Date") %>%
    mutate(Cases = replace_na(Cases, 0),
           logCases = log(Cases + 0.01))
  
  data
}