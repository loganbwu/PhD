library(tidyverse)
library(readxl)

load_yingjiang = function(path = "data/china/Yingjiang County Malaria Incidence 1986-2020.xlsx",
                          dir = NULL,
                          species = "all") {
  species_all = species == "all"
  
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
    mutate(Date = as_date(paste(Year, Month, "15", sep="-"))) %>%
    filter(year(Date) >= 1995)
  dateseq = tibble(Date = seq(min(data$Date), max(data$Date), by="month"))
  data = data %>%
    filter((Species %in% species) | species_all) %>%
    select(-Species) %>%
    drop_na() %>%
    group_by(Date) %>%
    summarise(Cases = sum(Cases)) %>%
    right_join(dateseq, by="Date") %>%
    mutate(Cases = replace_na(Cases, 0),
           logCases = log(Cases + 0.01))
  
  data
}