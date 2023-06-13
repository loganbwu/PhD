library(tidyverse)
library(readxl)
library(patchwork)

source("R/functions/load_yingjiang.R")
source("R/functions/decompose_data.R")

data = load_yingjiang()
decomp = decompose_data(data, 23)

# Analyse time series decomposition
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
  scale_x_date(date_breaks = "year", date_labels = "%b\n%Y") +
  labs(x = NULL, y = "Counts/error (n, δ/n, n)")

ggsave("plots/ts_decomp_yingjiang.png", width=6, height=6)
  