# library(tidyverse)
# library(readxl)
# 
# generate_load_LOC_towns = function(path) {
#   function(path = path, dir = NULL) {
#     if (!is.null(dir)) {
#       path = file.path(dir, path)
#     }
#     
#     sheets = excel_sheets(path)
#     data = lapply(sheets, function(s) {
#       headers = c("Year", "Month", "Township",
#                   sapply(c("Falciparum", "Vivax", "Mixed"), function(x) {
#                     paste(x, c("Local", "Imported"))
#                   }))
#       read_excel(path, s, col_names=headers, skip=3) %>%
#         fill(Year)
#     }) %>%
#       bind_rows() %>%
#       mutate(Date = as_date(paste(Year, Month, "15", sep="-"))) %>%
#       select(-Year, -Month) %>%
#       pivot_longer(-c(Date, Township), values_to = "Cases") %>%
#       separate(name, c("Species", "Infection")) %>%
#       drop_na() %>%
#       group_by(Township, Date) %>%
#       summarise(Cases = sum(Cases),
#                 .groups = "drop") %>%
#       mutate(logCases = log(Cases + 0.01))
#     
#     data
#   }
# }
# 
# generate_load_LOC = function(path) {
#   function(path = path, dir = NULL) {
#     data = load_dengzhou_towns(path, dir) %>%
#       group_by(Date) %>%
#       summarise(Cases = sum(Cases)) %>%
#       mutate(logCases = log(Cases + 0.01))
#     
#     data
#   }
# }
# 
# load_dengzhou_towns = generate_load_LOC_towns(path = "data/china/Dengzhou City Malaria 1980-1989.xlsx")
# load_dengzhou = generate_load_LOC(path = "data/china/Dengzhou City Malaria 1980-1989.xlsx")