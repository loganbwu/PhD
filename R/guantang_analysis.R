library(tidyverse)
library(readxl)
library(patchwork)
source("R/functions/load_guantang.R")

data = load_guantang()
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
  scale_x_date(breaks = seq(as_date("1950-01-01"), as_date("2030-01-01"), by="2 year"),
               minor_breaks = seq(as_date("1950-01-01"), as_date("2030-01-01"), by="1 year"),
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
ggsave("plots/ts_decomp_guantang.png", width=6, height=6)
