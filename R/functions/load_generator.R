force_all <- function(...) list(...)

make_load = function(path, dir=NULL, species="all") {
  force_all(path, dir, species)
  
  function(dir, species) {
    species_all = species == "all"
    
    data = load_deng_towns(path, dir) %>%
      filter(Species %in% species | species_all) %>%
      group_by(Date) %>%
      summarise(Cases = sum(Cases)) %>%
      mutate(logCases = log(Cases + 0.01))
    
    data
  }
}

# load_deng = make_load(path = "../data/china/Deng County Malaria 1980-2023.xlsx")
