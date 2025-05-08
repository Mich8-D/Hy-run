$set phase %1

** ----------------------------------------------------------------
$ifthen.ph %phase%=='sets'

set     TECHNOLOGY      /
        COAL 'Coal power plants'
        GFPP 'Gas fired power plants'
        ROR 'run-of-river hydroelectric power plants'
        OIL_GEN 'Oil power plants'
        BIO 'Biomass power plants'
        GEO 'Geothermal power plants'
        WTE 'Waste-to-energy power plants'
        SPV 'Solar power plants'
        WPP_ON 'Wind power plants - onshore' 
        WPP_OFF  'Wind power plants - offshore' 
        GRID_ELC 'Electric grid' /; 

set    FUEL            /
        ELC1 'Electricity-to-Grid'
        ELC2 'Electricity-from-grid'/; 

set power_plants(TECHNOLOGY)   / COAL, GFPP, ROR, OIL_GEN, BIO, GEO, WTE, SPV, WPP /;
set fuel_transformation(TECHNOLOGY) / /;
set fuel_transmission(TECHNOLOGY) / GRID_ELC /;
set renewable_tech(TECHNOLOGY) / SPV, WPP, WTE, BIO, GEO, ROR /;

set secondary_carrier(FUEL) / ELC1, ELC2 /;

** ----------------------------------------------------------------
$elseif.ph %phase%=='data'

# Characterize SOLAR technology
OperationalLife(r,'SPV') = 15;
CapacityFactor(r,'SPV','ID',y) = 0.4;
CapacityFactor(r,'SPV','IN',y) = 0;
CapacityFactor(r,'SPV','SD',y) = 0.8;
CapacityFactor(r,'SPV','SN',y) = 0;
CapacityFactor(r,'SPV','WD',y) = 0.1;
CapacityFactor(r,'SPV','WN',y) = 0;
CapitalCost(r,'SPV',y) = 1000;
VariableCost(r,'SPV',m,y) = 1e-5;
FixedCost(r,'SPV',y) = 5;
ResidualCapacity(r,"SPV",y) = 9;

# Characterize WIND-ONSHORE technology
OperationalLife(r,'WPP_ON') = 15;
CapacityFactor(r,'WPP_ON','ID',y) = 0.2;
CapacityFactor(r,'WPP_ON','IN',y) = 0.3;
CapacityFactor(r,'WPP_ON','SD',y) = 0.1;
CapacityFactor(r,'WPP_ON','SN',y) = 0.15;
CapacityFactor(r,'WPP_ON','WD',y) = 0.3;
CapacityFactor(r,'WPP_ON','WN',y) = 0.4;
CapitalCost(r,'WPP_ON',y) = 1200;
VariableCost(r,'WPP_ON',m,y) = 1e-5;
FixedCost(r,'WPP_ON',y) = 7;
ResidualCapacity(r,"WPP_ON",y) = 12;

# Characterize WIND-OFFSHORE technology
OperationalLife(r,'WPP_OFF') = 15;
CapacityFactor(r,'WPP_OFF','ID',y) = 0.2;
CapacityFactor(r,'WPP_OFF','IN',y) = 0.3;
CapacityFactor(r,'WPP_OFF','SD',y) = 0.1;
CapacityFactor(r,'WPP_OFF','SN',y) = 0.15;
CapacityFactor(r,'WPP_OFF','WD',y) = 0.3;
CapacityFactor(r,'WPP_OFF','WN',y) = 0.4;
CapitalCost(r,'WPP_OFF',y) = 1200;
VariableCost(r,'WPP_OFF',m,y) = 1e-5;
FixedCost(r,'WPP_OFF',y) = 7;
ResidualCapacity(r,"WPP_OFF",y) = 12;

# Characterize WASTE-TO-ENERGY technology
OperationalLife(r,'WTE') = 25;
CapitalCost(r,'WTE',y) = 2000;
VariableCost(r,'WTE',m,y) = 1e-5;
FixedCost(r,'WTE',y) = 10;
ResidualCapacity(r,"WTE",y) = 0.67;

# Characterize BIOMASS technology
OperationalLife(r,'BIO') = 25;
AvailabilityFactor(r,'BIO',y) = 0.85;
CapitalCost(r,'BIO',y) = 2000;
VariableCost(r,'BIO',m,y) = 1e-5;
FixedCost(r,'BIO',y) = 10;
ResidualCapacity(r,"BIO",y) = 1.54;

# Characterize GEOTHERMAL technology
OperationalLife(r,'GEO') = 25;
CapitalCost(r,'GEO',y) = 2000;
VariableCost(r,'GEO',m,y) = 1e-5;
FixedCost(r,'GEO',y) = 10;
ResidualCapacity(r,"GEO",y) = 0.87;

# Characterize RUN-OF-RIVER technology
OperationalLife(r,'ROR') = 80;
AvailabilityFactor(r,'ROR',y) = 0.27;
CapitalCost(r,'ROR',y) = 3000;
VariableCost(r,'ROR',m,y) = 1e-5;
FixedCost(r,'ROR',y) = 10;
ResidualCapacity(r,"ROR",y) = 12;

# Characterize COAL technology
OperationalLife(r,'COAL') = 50;
AvailabilityFactor(r,'COAL',y) = 0.8;
CapitalCost(r,'COAL',y) = 1200;
VariableCost(r,'COAL',m,y) = 1e-5;
FixedCost(r,'COAL',y) = 10;
ResidualCapacity(r,"COAL",y) = 5;

# Characterize GFPP technology
OperationalLife(r,'GFPP') = 25;
AvailabilityFactor(r,'GFPP',y) = 0.75;
CapitalCost(r,'GFPP',y) = 2000;
VariableCost(r,'GFPP',m,y) = 1e-5;
FixedCost(r,'GFPP',y) = 10;
ResidualCapacity(r,"GFPP",y) = 15;

# Characterize OIL technology
OperationalLife(r,'OIL_GEN') = 40;
AvailabilityFactor(r,'OIL_GEN',y) = 0.85;
CapitalCost(r,'OIL_GEN',y) = 2000;
VariableCost(r,'OIL_GEN',m,y) = 1e-5;
FixedCost(r,'OIL_GEN',y) = 10;
ResidualCapacity(r,"OIL_GEN",y) = 1.55;

# Characterize ELECTRIC GRID technology
OperationalLife(r,'GRID_ELC') = 40;
AvailabilityFactor(r,'GRID_ELC',y) = 0.85;
CapitalCost(r,'GRID_ELC',y) = 2000;
VariableCost(r,'GRID_ELC',m,y) = 1e-5;
FixedCost(r,'GRID_ELC',y) = 10;
ResidualCapacity(r,"GRID_ELC",y) = 1.55;

** ----------------------------------------------------------------
$elseif.ph %phase%=='popol'

InputActivityRatio(r,'SPV','SUN',"1",y) = 1; #IEA convention
OutputActivityRatio(r,'SPV','ELC1',"1",y) = 1; 

InputActivityRatio(r,'WPP','WIN',"1",y) = 1; #IEA convention
OutputActivityRatio(r,'WPP','ELC1',"1",y) = 1; 

InputActivityRatio(r,'WTE','WST',"1",y) = 1/0.25; 
OutputActivityRatio(r,'WTE','ELC1',"1",y) = 1;

InputActivityRatio(r,'BIO','WBM',"1",y) = 1/0.25;
OutputActivityRatio(r,'BIO','ELC1',"1",y) = 1;

InputActivityRatio(r,'GEO','GTH',"1",y) = 1/0.25;
OutputActivityRatio(r,'GEO','ELC1',"1",y) = 1;

InputActivityRatio(r,'COAL','HCO',"1",y) = 1/0.45;
OutputActivityRatio(r,'COAL','ELC1',"1",y) = 1;

InputActivityRatio(r,'ROR','HYD',"1",y) = 1;
OutputActivityRatio(r,'ROR','ELC1',"1",y) = 1;

** open cycle gas turbines
InputActivityRatio(r,'GFPP','GAS2',"1",y) = 1/0.35;
OutputActivityRatio(r,'GFPP','ELC1',"1",y) = 1;

** oil power plants
InputActivityRatio(r,'OIL_GEN','OIL',"1",y) = 1/0.2;
OutputActivityRatio(r,'OIL_GEN','ELC1',"1",y) = 1;

** electric grid
InputActivityRatio(r,'GRID_ELC','ELC1',"1",y) = 1;
OutputActivityRatio(r,'GRID_ELC','ELC2',"1",y) = 1;

$endif.ph
