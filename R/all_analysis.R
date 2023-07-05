library(tidyverse)
library(readxl)
library(patchwork)
library(pinyin)

R_functions = list.files("R/functions", "\\.R$", full.names=T)
for (r in R_functions) { source(r)}

load_functions = list(Dengzhou = load_dengzhou,
                      Guantang = load_guantang,
                      Thasongyang = load_thasongyang,
                      Yingjiang = load_yingjiang,
                      Deng = load_deng,
                      Duchuan = load_duchuan,
                      Shangqiu = load_shangqiu,
                      Tengchong = load_tengchong)

# selection = "Dengzhou"

for (selection in names(load_functions)) {
  message("Processing ", selection)
  data = load_functions[[selection]]()
  max_date_with_cases = max(data$Date[data$Cases > 5])
  data = data %>% filter(Date <= max_date_with_cases)
  timespan = max(year(data$Date)) - min(year(data$Date))
  use_s.window = timespan > 20
  if (use_s.window) {
    decomp = decompose_data(data, 19)
  } else {
    decomp = decompose_data(data, "periodic")
  }
  n_years = max(year(data$Date)) - min(year(data$Date))
  # x_breaks = ifelse(n_years > 20, "5 years", "year")
  x_breaks = case_when(n_years > 20 ~ "5 years",
                       n_years > 10 ~ "2 years",
                       TRUE ~ "year")
  x_breaks = seq(as.Date("1900-01-01"), as.Date("2050-12-31"), by=case_when(n_years > 20 ~ "5 years",
                                                                            n_years > 10 ~ "2 years",
                                                                            TRUE ~ "year"))
  
  # Analyse time series decomposition
  if (use_s.window) {
    ggplot(decomp %>%
             filter(name %in% c("Cases", "trend", "seasonal", "remainder")),
           aes(x = Date, y = value)) +
      geom_col() +
      geom_line(data = decomp %>%
                  filter(name == "trend.seasonal") %>%
                  mutate(name = "Cases"),
                color = "orange",
                linewidth = 1) + 
      facet_grid(vars(name), scales = "free_y") +
      scale_x_date(breaks = x_breaks, date_labels = "%b\n%Y") +
      # scale_y_log10() +
      labs(x = NULL, y = "Counts/error (n, δ/n, n)")
  } else {
    p1 = ggplot(decomp %>%
                  filter(name %in% c("Cases", "trend", "remainder")),
                aes(x = Date, y = value)) +
      geom_col() +
      geom_line(data = decomp %>%
                  filter(name == "trend.seasonal") %>%
                  mutate(name = "Cases"),
                color = "orange",
                linewidth = 1) + 
      facet_grid(vars(name), scales = "free_y") +
      scale_x_date(breaks = x_breaks, date_labels = "%b\n%Y") +
      # scale_y_log10() +
      labs(x = NULL, y = "Counts/error (n, δ/n, n)")
    
    p2 = ggplot(decomp %>%
                  group_by(Month) %>%
                  filter(name == "seasonal") %>%
                  slice(1),
                aes(x = Month, y = value)) +
      geom_col() +
      geom_line(data = decomp %>%
                  filter(name == "seasonal.remainder"),
                aes(color = Year, group = Year),
                alpha = 0.5) +
      scale_x_continuous(breaks = 1:12, labels = month.abb) +
      labs(x = NULL, y = "Seasonal multiplier", color = NULL)
    p1 / p2 + plot_layout(heights = c(2, 1))
  }
  ggsave(paste0("plots/ts_decomp_", str_to_lower(selection), ".png"), width=6, height=6)
}

# Town-level analysis ----
data_towns = load_tengchong_towns() %>%
  filter(Species == "Vivax")
dateseq = expand.grid(Date = seq(min(data_towns$Date), max(data_towns$Date), by="month"),
                      Township = unique(data_towns$Township))
town_infreq = data_towns %>%
  group_by(Township) %>%
  summarise(Cases = sum(Cases)) %>%
  arrange(desc(Cases)) %>%
  pull(Township)
data_towns = data_towns %>%
  right_join(dateseq, by=c("Date", "Township")) %>%
  filter(Township %in% town_infreq[1:6]) %>%
  mutate(Cases = replace_na(Cases, 0),
         logCases = log(Cases + 0.01),
         Township = factor(Township, levels=town_infreq, labels=py(town_infreq, sep=" ")) %>%
           fct_drop())

decomp_towns = list()

for (town in levels(data_towns$Township)) {
  data_town = data_towns %>%
    filter(Township == town)
  if (nrow(data_town) > 26) {
    decomp_town = decompose_data(data_town)
    decomp_towns[[town]] = decomp_town
  }
}
decomp_towns = bind_rows(decomp_towns, .id = "Township")

decomp_towns = lapply(levels(data_towns$Township) %>% setNames({.}), function(x) {
  data = data_towns %>%
    filter(Township == x)
  decompose_data(data)
}) %>%
  bind_rows(.id = "Township")

decomp_towns %>%
  filter(name =="trend") %>%
  group_by(Township) %>%
  mutate(value = value / max(value)) %>%
  ggplot(aes(x=Date, y=value, color=Township)) +
  geom_line()

ggplot(decomp_towns %>%
         filter(name =="seasonal",
                Date <= min(Date) + months(12)),
       aes(x=Date-days(14), y=value, color=Township)) +
  geom_line() +
  scale_x_date(date_labels = "%b")

ggplot(decomp_towns %>%
         filter(name=="Cases"),
       aes(x=Date, y=value)) +
  geom_col() +
  geom_line(data = decomp_towns %>%
              filter(name=="trend"), color="tomato") +
  facet_wrap(vars(Township), ncol=1)
