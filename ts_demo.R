library(lubridate)

time = seq(as_date("2010-01-01"), as_date("2022-12-01"), by="month")
trend = rep(500, length(time))
trend[time > as_date("2022-07-01")] = 460

seasonality = cos(month(time) * 2 * pi / 12) * 100
noise = rnorm(length(time), 0, 20)
noise[length(time) - c(12, 0)] = c(-50, 0)

data = tibble(time,
              trend,
              seasonality,
              noise,
              sales = trend + seasonality + noise) %>%
  pivot_longer(-time) %>%
  mutate(name = fct_relevel(name, c("sales", "trend", "seasonality", "noise")))


sales = data %>%
  filter(name == "sales") %>%
  mutate(Month = format(time, "%b %Y")) %>%
  select(time, Month, Sales=value)

# Show sales
ggplot(sales, aes(x = time, y = Sales)) +
  geom_line()

# Compare current month with this time last year
sales$Sales[length(time)] - sales$Sales[length(time) - 12]

data_ts = ts(sales$Sales, start=1, frequency=12)

decomp = stl(data_ts, "periodic")$time.series %>%
  as_tibble() %>%
  mutate(time = time) %>%
  pivot_longer(cols = -time) %>%
  mutate(name = fct_relevel(name, c("trend", "seasonal", "remainder")))

ggplot(decomp, aes(x = time, y = value, color = name)) +
  geom_line() +
  facet_wrap(vars(name), ncol=1, scales = "free_y")

# True decomposition
ggplot(data, aes(x = time, y = value, color = name)) +
  geom_line() +
  facet_wrap(vars(name), ncol=1, scales = "free_y")
