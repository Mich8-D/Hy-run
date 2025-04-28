#### require results_analysis.R to run 
select_multiple_scens <- "cheapres" #type of policy you want plotted
data_select <- c("renewables","hydrogen")
want_storage <- "yes" #do you want to consider storage?

ggplot(Production %>% 
         filter( (str_detect(scen,select_multiple_scens)|scen=="base") & 
                   data %in% data_select & 
                   FUEL %in% primary & 
                   storage==want_storage) %>%
         group_by(YEAR,scen,FUEL) %>%
         mutate(valuediff=(value-value[data=="renewables"]) ) %>%
         filter(data!="renewables")) +
  geom_line(aes(x=YEAR,
                y=valuediff,
                color=FUEL,
                linetype=scen),
            linewidth=1.2) +
  xlab("") + ylab("PJ/yr")

ggplot(TotalCost %>% 
         filter( (str_detect(scen,select_multiple_scens)|scen=="base") & 
                   data %in% data_select  & 
                   storage==want_storage) %>%
         group_by(YEAR,scen) %>%
         mutate(valuediff=(value-value[data=="renewables"])/value[data=="renewables"] )%>%
         filter(data!="renewables") ) +
  geom_line(aes(x=YEAR,
                y=valuediff,
                color=scen),
            linewidth=1.2) +
  xlab("") + ylab("Costs [fraction of baseline]")
