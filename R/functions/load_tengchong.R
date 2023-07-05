library(tidyverse)
library(readxl)

#' Load Tengchong aggregate data from 1980-2002 because before 2003 they didn't have
#' the standard data format.
#' 
#' UNITS
#' Prevalence: percent
#' Incidence: per 10000
#' Mortality: per 10000
load_tengchong_old = function(path, dir) {
  if (!is.null(dir)) {
    path = file.path(dir, path)
  }
			
  headers = c("Year", "Population", "Total infections", "Total incidence", "Imported", "Local", "Prevalence", "Deaths", 	"Incidence", "Mortality")
  data = read_excel(path, 1, col_names=headers, skip=2) %>%
    mutate(Deaths = coalesce(Deaths, Mortality * Population/10000))
}

load_tengchong_towns = function(path = "data/china/Tengchong County Malaria 2004-2022.xlsx",
                               dir = NULL) {
  if (!is.null(dir)) {
    path = file.path(dir, path)
  }
  
  sheets = excel_sheets(path)[-1]
  data = lapply(sheets, function(s) {
    headers = c("Year", "Month", "Township",
                sapply(c("Falciparum", "Vivax", "Mixed", "Malariae", "Unknown"), function(x) {
                  paste(x, c("Local", "Imported"))
                }))
    x = read_excel(path, s, col_names=F, skip=3, .name_repair = "minimal")
    names(x) = headers[seq_len(ncol(x))]
    x = x %>%
      fill(Year, Township) %>%
      # filter(Year != "合计") %>%
      drop_na(Month) %>%
      mutate(Year = as.numeric(Year))
  }) %>%
    bind_rows() %>%
    drop_na(Month) %>%
    mutate(Date = as_date(paste(Year, Month, "15", sep="-"))) %>%
    select(-Year, -Month) %>%
    pivot_longer(-c(Date, Township), values_to = "Cases") %>%
    separate(name, c("Species", "Infection")) %>%
    drop_na() %>%
    group_by(Township, Species, Date) %>%
    summarise(Cases = sum(Cases),
              .groups = "drop") %>%
    mutate(logCases = log(Cases + 0.01))
  
  data
}

load_tengchong = function(path = "data/china/Tengchong County Malaria 2004-2022.xlsx",
                          dir = NULL,
                          species = "all") {
  species_all = species == "all"
  
  data = load_tengchong_towns(path, dir)
  dateseq = tibble(Date = seq(min(data$Date), max(data$Date), by="month"))
  data = data %>%
    filter((Species %in% species) | species_all) %>%
    group_by(Date) %>%
    summarise(Cases = sum(Cases)) %>%
    # right_join(dateseq, by="Date") %>%
    mutate(#Cases = replace_na(Cases, 0),
           logCases = log(Cases + 0.01))
  
  data
}
