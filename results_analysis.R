require(data.table)
require(tidyverse)
require(gdxtools)
require(witchtools)
require(ggpubr)

####### here you select your results for your plot
current_directory <- getwd()
results_directory <- file.path(current_directory, "Results")

all_gdx <- Sys.glob(file.path(results_directory, "results*.gdx"))

osemosys_sanitize <- function(.x) {
  .x[, file := basename(gdx)]
  .x[, file := str_replace(file,"Results/results_","")]
  .x[, file := str_replace(file,".gdx","")]
  .x[, scen := str_extract(file,"(?<=SCEN).+?(?=_)")]
  .x[, data := str_extract(file,"(?<=DATA).+?(?=_)")]
  .x[, storage := str_extract(file,"(?<=STOR).*")]
  .x[, YEAR := as.numeric(YEAR)]
  .x[, gdx := NULL]}

#load variables
Production <- batch_extract("ProductionAnnual",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
Demand <- batch_extract("Demand",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
Use <- batch_extract("UseAnnual",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
Activity <- batch_extract("RateOfActivity",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()

TotalCost <- batch_extract("TotalDiscountedCost",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
Emissions <- batch_extract("AnnualEmissions",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()

#by time slice
ProductionSlice <- batch_extract("Production",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
CapacityFactor <- batch_extract("CapacityFactor",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()

#storage
StorageCharge <- batch_extract("RateOfStorageCharge",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
StorageDischarge <- batch_extract("RateOfStorageDischarge",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()

#by technology
UseBytech <- batch_extract("UseByTechnologyAnnual",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
Prodbytech <- batch_extract("ProductionByTechnologyAnnual",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()

### build the proxy for hourly curves
YearSplit <-  batch_extract("YearSplit",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()
DaySplit <-  batch_extract("DaySplit",all_gdx)[[1]] |> setDT() |> osemosys_sanitize() %>% as_tibble()

year_map <- unique(YearSplit %>% select(-file,-scen,-data, -YEAR)) %>% 
  dplyr::filter(TIMESLICE !="ALLYEAR") %>%
  mutate(day = str_sub(TIMESLICE,2),
         season = str_sub(TIMESLICE,1,1)) 

hourly_split <- data.frame(yearly_hours = seq(1,8670)) %>%
  mutate(day = ifelse(yearly_hours %% 24 < 8 | yearly_hours %% 24 >= 24,"D","N")) %>%
  mutate(season = case_when(yearly_hours <= 3*31*24 ~ "W",
                            yearly_hours > 3*30*24 & yearly_hours <= 6*30*24 ~ "I",
                            yearly_hours > 6*30*24 & yearly_hours <= 9*30*24 ~ "S",
                            yearly_hours > 9*30*24 & yearly_hours <= 12*30*24 ~ "I",
                            yearly_hours > 12*30*24 ~ "W") ) %>%
  inner_join(year_map %>% select(-value,-storage))

### load some useful sets for fuels
primary <- batch_extract("primary_fuel",all_gdx)[[1]]$FUEL  %>% unique()
final <- batch_extract("final_demand",all_gdx)[[1]]$FUEL  %>% unique()
secondary <- batch_extract("secondary_carrier",all_gdx)[[1]]$FUEL  %>% unique()

### load some useful subsets for technologies
ren <- batch_extract("renewable_tech",all_gdx)[[1]]$TECHNOLOGY  %>% unique()
pp <- batch_extract("power_plants",all_gdx)[[1]]$TECHNOLOGY %>% unique()
stor <- batch_extract("storage_plants",all_gdx)[[1]]$TECHNOLOGY %>% unique()
