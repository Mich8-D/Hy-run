#### require results_analysis.R to run 
data_select <- "renewables"
scen_select <- "base"
want_storage <- "yes" #do you want to consider storage?


## plot primary energy, total
ggplot(Production %>% 
         filter(scen==scen_select & data==data_select & FUEL %in% primary & storage==want_storage)) +
  geom_line(aes(x=YEAR,
                y=value,
                color=FUEL,
                linetype=scen),
            linewidth=1.2) +
  xlab("") + ylab("PJ/yr")

ggplot(Production %>% 
         filter(scen==scen_select & data==data_select & FUEL %in% primary & storage==want_storage) %>%
         group_by(scen,data,YEAR) %>%
         mutate(valuerel=value/sum(value))  ) +
  geom_area(aes(x=YEAR,
                y=valuerel*100,
                fill=FUEL),
            linewidth=1.2,
            color="black") +
  xlab("") + ylab("%")

### secondary energy
ggplot(Production %>% 
         filter(scen==scen_select & data==data_select & FUEL %in% secondary & storage==storage)) +
  geom_line(aes(x=YEAR,
                y=value,
                color=FUEL),
            linewidth=1.2) +
  xlab("") + ylab("PJ/yr")

### storage
ggplot(Activity %>%
         filter(scen==scen_select & data==data_select & TECHNOLOGY %in% stor & storage==want_storage & YEAR==2010) %>% 
         inner_join(hourly_split) %>%
         filter(yearly_hours <= 24)) +
  geom_line(aes(x=yearly_hours,
                y=value,
                color=MODE_OF_OPERATION,
                linetype=TECHNOLOGY),
            linewidth=1.2) +
  xlab("") + ylab("MW")

## plot final demand
ggplot(ProductionSlice %>% 
         inner_join(hourly_split) %>%
         filter(scen==scen_select & data==data_select & FUEL %in% final & YEAR == 2010 & storage==storage)) +
  geom_line(aes(x=yearly_hours,
                y=value,
                color=FUEL),
            linewidth=0.8) +
  xlab("") + ylab("unit") +
  facet_wrap(FUEL~.,scales="free")

### timeslice for a single day
ggplot(ProductionSlice %>% 
         inner_join(hourly_split) %>%
         filter(scen==scen_select & data==data_select & FUEL %in% final & YEAR == 2010 & yearly_hours <= 24 & storage==storage)) +
  geom_line(aes(x=yearly_hours,
                y=value,
                color=FUEL),
            linewidth=0.8) +
  xlab("") + ylab("PJ/yr") +
  facet_wrap(FUEL~.,scales="free")


### renewables availability
ggplot(CapacityFactor %>% 
         inner_join(hourly_split) %>%
         filter(scen==scen_select & data==data_select & TECHNOLOGY %in% ren & YEAR == 2010 & yearly_hours <= 24 & storage==storage)) +
  geom_line(aes(x=yearly_hours,
                y=value,
                color=TECHNOLOGY),
            linewidth=0.8) +
  xlab("") + ylab("fraction") + 
  ylim(c(0,1))

ggplot(CapacityFactor %>% 
         inner_join(hourly_split) %>%
         filter(scen==scen_select & data==data_select & TECHNOLOGY %in% ren & YEAR == 2010 & storage==storage)) +
  geom_line(aes(x=yearly_hours,
                y=value,
                color=TECHNOLOGY),
            linewidth=0.8) +
  xlab("") + ylab("fraction") + 
  ylim(c(0,1))

