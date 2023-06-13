library(tidyverse)
library(readxl)
library(patchwork)

source("R/functions/load_thasongyang.R")
source("R/functions/decompose_data.R")

coerce_chr = function(.df) {
  for (x in names(.df)) {
    if (is.character(.df[[x]]) & length(unique(.df[[x]])) < 50) {
      .df[[x]] = fct_infreq(.df[[x]])
    }
  }
  .df
}

data = load_thasongyang()
decomp = decompose_data(data)

# Analyse time series decomposition
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
  scale_x_date(breaks = seq(as_date("1950-01-01"), as_date("2030-01-01"), by="1 year"),
               minor_breaks = NULL,
               date_labels="%b\n%Y") +
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
ggsave("plots/ts_decomp_thasongyang.png", width=6, height=6)

# Analyse demography
mbs = read_excel("data/thailand/MBS_export.xlsx") %>%
  select(-HOUSEID, -PSUBJID, -VILNAME, -BRTHMO, -BTHYRBE) %>%
  coerce_chr()

pcd = read_excel("data/thailand/PCD_export.xlsx") %>%
  select(-datasource) %>%
  coerce_chr() %>%
  arrange(punchdate) %>%
  drop_na(punchdate) %>%
  filter(punchdate < as_date("2022-12-01")) %>%
  mutate(malaria_result = malaria_result %>% fct_relevel("V", "F+V", "F") %>% fct_explicit_na() %>%
           fct_rev(),
         occupation = occupation %>% fct_explicit_na())
pcd_pos = pcd %>%
  filter(malaria_result %in% c("F+V", "V"))

result_colors = c(colorRampPalette(c("firebrick", "pink"))(3) %>% setNames(c("V", "F+V", "F")),
                  "Neg" = "steelblue", "(Missing)" = "grey50")

diagnoses = list("F", "F+V", "V")

pop_tree = mbs %>%
  count(Age_Y, Sex = SEX) %>%
  mutate(n = ifelse(Sex == "Male", n, -n)) %>%
  drop_na()
case_tree = pcd %>%
  filter(malaria_result %in% c("F+V", "V")) %>%
  count(Age_Y, Sex) %>%
  mutate(n = ifelse(Sex == "Male", n, -n)) %>%
  drop_na()
ggplot(pop_tree, aes(x = Age_Y, y = n, fill = Sex)) +
  geom_col(width = 1, alpha = 0.3) +
  geom_col(data = case_tree, aes(x = Age_Y, y = n), width = 1) +
  scale_y_continuous(labels = function(x) str_remove(x, "-")) +
  coord_flip()

# Analyse testing
pcd %>%
  mutate(Month = as_date(paste(year(punchdate), month(punchdate), "15", sep="-"))) %>%
  count(Month, malaria_result) %>%
  ggplot(aes(x = Month, y = n, fill = malaria_result)) + 
    geom_col() +
  scale_x_date(date_breaks = "year", date_labels = "%b %Y") +
  scale_fill_manual(values = result_colors)

pcd %>%
  mutate(Month = as_date(paste(year(punchdate), month(punchdate), "15", sep="-")),
         occupation = occupation %>% fct_lump_n(3)) %>%
  count(Month, occupation, patie_type, malaria_result) %>%
  ggplot(aes(x = Month, y = n, fill = malaria_result)) +
  geom_col() +
  facet_grid(vars(occupation), vars(patie_type)) +
  scale_x_date(date_breaks = "year", date_labels = "%b\n%Y") +
  scale_fill_manual(values = result_colors) +
  labs(x = NULL, y = "Tests")
  
# Extract seasonality
seasonality = decomp %>%
  group_by(Month) %>%
  filter(name == "seasonal") %>%
  slice(1) %>%
  ungroup() %>%
  pull(value)
seasonality = seasonality / mean(seasonality)
dput(seasonality)
                    