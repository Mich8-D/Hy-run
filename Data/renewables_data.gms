$include "Data/germany_no_ren_data.gms"

### Renewable energy technologies and fuels

set TECHNOLOGY /
* new technologies
        SPV 'Solar power plants'
        WPP_ON 'Onshore wind power plants'
        WPP_OFF 'Offshore wind power plants'
        SUN 'Energy input from the sun'
        WIN 'Energy input from the wind'
        BMPP 'Biomass Power Plants'
        INP_BIOM 'Energy input from biomass'
        ROR 'Run of River Hydro Power Plants'
        RIV 'River'
        GEOTH 'Geothermal Power Plants'
        SOIL 'Geothermal Energy input'
/;

 set FUEL / 
* new fuels 
        SOL 'Solar'
        WND 'Wind' 
        HYD 'Hydro'
        BIO 'Biomass'
        GEOTHEN 'Geothermal Energy'
/;

set renewable_tech(TECHNOLOGY) /SPV, WPP_ON, WPP_OFF, BMPP, ROR, GEOTH/; 
set renewable_fuel(FUEL) /SOL, WND, HYD, BIO, GEOTHEN/; 

set power_plants(TECHNOLOGY) / SPV, WPP_ON, WPP_OFF, BMPP, ROR, GEOTH/;
set fuel_production_fict(TECHNOLOGY) /SUN, WIN, INP_BIOM, RIV, SOIL/;
set secondary_production(TECHNOLOGY) /SUN, WIN, INP_BIOM, RIV, SOIL/;

set primary_fuel(FUEL) / SOL, WND, HYD, GEOTHEN, BIO /;

# -----------------------------------------------------------------------------------------------------------------
#                                     TECHNOLOGIES AND FUELS CHARACTERISTICS
# -----------------------------------------------------------------------------------------------------------------
### OPERATIONAL LIFE

Parameter OperationalLife(r,t,y) /
GERMANY.SPV.(2024*2050) = 15
GERMANY.WPP_ON.(2024*2050) = 15
GERMANY.WPP_OFF.(2024*2050) = 15
GERMANY.BMPP.(2024*2050) = 15
GERMANY.ROR.(2024*2050) = 15
GERMANY.GEOTH.(2024*2050) = 15
/;

OperationalLife(r,t,y)$(OperationalLife(r,t,y) eq 0) = 200;


### RESIDUAL CAPACITY

Parameter ResidualCapacity(r,t,y) /
    GERMANY.SPV.(2024*2050) = 0
    GERMANY.WPP_ON.(2024*2050) = 0
    GERMANY.WPP_OFF.(2024*2050) = 0
    GERMANY.BMPP.(2024*2050) = 0
    GERMANY.ROR.(2024*2050) = 0
    GERMANY.GEOTH.(2024*2050) = 0
/;


### CAPACITY FACTORS

Parameter CapacityFactor(r,t,l,y) /
   # Solar PV
     GERMANY.SPV.ID.(2024*2050) = 0.4
     GERMANY.SPV.IN.(2024*2050) = 0
     GERMANY.SPV.SD.(2024*2050) = 0.8
     GERMANY.SPV.SN.(2024*2050) = 0
     GERMANY.SPV.WD.(2024*2050) = 0.1
     GERMANY.SPV.WN.(2024*2050) = 0
   # On-shore wind power plants
     GERMANY.WPP_ON.ID.(2024*2050) = 0.2
     GERMANY.WPP_ON.IN.(2024*2050) = 0.3
     GERMANY.WPP_ON.SD.(2024*2050) = 0.1
     GERMANY.WPP_ON.SN.(2024*2050) = 0.15
     GERMANY.WPP_ON.WD.(2024*2050) = 0.3
     GERMANY.WPP_ON.WN.(2024*2050) = 0.4
   # Off-shore wind power plants
     GERMANY.WPP_OFF.ID.(2024*2050) = 0.2
     GERMANY.WPP_OFF.IN.(2024*2050) = 0.3
     GERMANY.WPP_OFF.SD.(2024*2050) = 0.1
     GERMANY.WPP_OFF.SN.(2024*2050) = 0.15
     GERMANY.WPP_OFF.WD.(2024*2050) = 0.3
     GERMANY.WPP_OFF.WN.(2024*2050) = 0.4

/;

CapacityFactor('GERMANY', 'ROR', l, 2024*2050) = 0.27;
CapacityFactor(r,t,l,y)$(CapacityFactor(r,t,l,y) eq 0) = 1;


### AVALABILITY FACTORS

Parameter AvailabilityFactor(r,t,y) /
   # Biomass Power Plants
     GERMANY.BMPP.(2024*2050) = 0.9
   # Geothermal Power Plants
     GERMANY.GEOTH.(2024*2050) = 0.9
/;

AvailabilityFactor(r,t,y)$(AvailabilityFactor(r,t,y) eq 0) = 1;


### INPUT TO ACTIVITY RATIOS

Parameter InputActivityRatio(r,t,f,m,y) /
  GERMANY.SPV.SOL."1".(2024*2050) = 1  #IEA convention
  GERMANY.WPP_ON.WND."1".(2024*2050) = 1  
  GERMANY.WPP_OFF.WND."1".(2024*2050) = 1  
  GERMANY.BMPP.BIO."1".(2024*2050) = 1  
  GERMANY.ROR.HYD."1".(2024*2050) = 1  
  GERMANY.GEOTH.GEOTHEN."1".(2024*2050) = 1
/;


### OUTPUT TO ACTIVITY RATIOS

Parameter OutputActivityRatio(r,t,f,m,y) /
GERMANY.SPV.ELC."1".(2024*2050) = 1
GERMANY.SOL.SUN."1".(2024*2050) = 1
GERMANY.WPP_ON.ELC."1".(2024*2050) = 1
GERMANY.WPP_OFF.ELC."1".(2024*2050) = 1
GERMANY.WND.WIN."1".(2024*2050) = 1
GERMANY.BMPP.ELC."1".(2024*2050) = 1
GERMANY.INP_BIOM.BIO."1".(2024*2050) = 1
GERMANY.ROR.ELC."1".(2024*2050) = 1
GERMANY.RIV.HYD."1".(2024*2050) = 1
GERMANY.GEOTH.ELC."1".(2024*2050) = 1
GERMANY.SOIL.GEOTHEN."1".(2024*2050) = 1
/;


#------------------------------------------------------------------------------------------------------------------
#                                          COSTS CHARACTERIZATION
#------------------------------------------------------------------------------------------------------------------


### CAPITAL COSTS

Parameter CapitalCost(r,t,y) /
GERMANY.SPV.(2024*2050) = 1000
GERMANY.WPP_ON.(2024*2050) = 1200
GERMANY.WPP_OFF.(2024*2050) = 1200
GERMANY.BMPP.(2024*2050) = 1000
GERMANY.ROR.(2024*2050) = 1000
GERMANY.GEOTH.(2024*2050) = 1000
/;

CapitalCost(r,t,y)$(CapitalCost(r,t,y) eq 0) = 0; #sources of RES are free (what about BIOMASS????)


### VARIABLE O&M COSTS

Parameter VariableCost(r,t,m,y) /       
GERMANY.SPV."1".(2024*2050) = 1e-5
GERMANY.WPP_ON."1".(2024*2050) = 1e-5
GERMANY.WPP_OFF."1".(2024*2050) = 1e-5
GERMANY.BMPP."1".(2024*2050) = 1e-5 #not that free actually....
GERMANY.ROR."1".(2024*2050) = 1e-5
GERMANY.GEOTH."1".(2024*2050) = 1e-5
/;


### FIXED O&M COSTS

Parameter FixedCost(r,t,y) /
GERMANY.SPV.(2024*2050) = 5
GERMANY.WPP_ON.(2024*2050) = 7
GERMANY.WPP_OFF.(2024*2050) = 7
GERMANY.BMPP.(2024*2050) = 10
GERMANY.ROR.(2024*2050) = 15
GERMANY.GEOTH.(2024*2050) = 40
/;



