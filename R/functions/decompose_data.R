
#' Perform time series decomposition on monthly data
decompose_data = function(data, s.window="periodic", ...) {
  data_ts = ts(data$logCases, start=1, frequency=12)
  
  decomp = stl(data_ts, s.window, ...)$time.series %>%
    as_tibble() %>%
    mutate(Date = data$Date,
           Year = year(Date),
           Month = month(Date),
           Cases = data$Cases,
           trend.seasonal = exp(trend + seasonal),
           seasonal.remainder = exp(seasonal + remainder),
           trend = exp(trend),
           seasonal = exp(seasonal)) %>%
    pivot_longer(cols = -c(Date, Year, Month))
}
