$set phase %1

** ----------------------------------------------------------------
$ifthen.ph %phase%=='sets'

set     TECHNOLOGY      /
        COAL 'Coal power plants'
        OCGT 'Open cycle gas turbines'
        CCGT 'Combined cycle gas turbines'
        CHP 'Cogeneration plants'
        ROR 'run-of-river hydroelectric power plants'
        OIL_GEN 'Oil power plants'
        BIO 'Biomass power plants'
        GEO 'Geothermal power plants'
        WTE 'Waste-to-energy power plants'
        SRE 'Crude oil refinery'
        SPV 'Solar power plants'
        WPP 'Wind power plants' /; 

set    FUEL            /
        DSL 'Diesel'
        ELC 'Electricity'
        GSL 'Gasoline'
        THE 'Thermal energy' /; 

set power_plants(TECHNOLOGY)   / COAL, OCGT, CCGT, CHP, ROR, OIL_GEN, BIO, GEO, WTE, SRE, SPV, WPP /;
set fuel_transformation(TECHNOLOGY) / SRE /;
set renewable_tech(TECHNOLOGY) / SPV, WPP, WTE, BIO, GEO, ROR /;

set secondary_carrier(FUEL) / ELC, DSL, GSL/;

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

# Characterize WIND technology
OperationalLife(r,'WPP') = 15;
CapacityFactor(r,'WPP','ID',y) = 0.2;
CapacityFactor(r,'WPP','IN',y) = 0.3;
CapacityFactor(r,'WPP','SD',y) = 0.1;
CapacityFactor(r,'WPP','SN',y) = 0.15;
CapacityFactor(r,'WPP','WD',y) = 0.3;
CapacityFactor(r,'WPP','WN',y) = 0.4;
CapitalCost(r,'WPP',y) = 1200;
VariableCost(r,'WPP',m,y) = 1e-5;
FixedCost(r,'WPP',y) = 7;
ResidualCapacity(r,"WPP",y) = 12;

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

# Characterize OCGT technology
OperationalLife(r,'OCGT') = 25;
AvailabilityFactor(r,'OCGT',y) = 0.75;
CapitalCost(r,'OCGT',y) = 2000;
VariableCost(r,'OCGT',m,y) = 1e-5;
FixedCost(r,'OCGT',y) = 10;
ResidualCapacity(r,"OCGT",y) = 15;

# Characterize CCGT technology
OperationalLife(r,'CCGT') = 35;
AvailabilityFactor(r,'CCGT',y) = 0.85;
CapitalCost(r,'CCGT',y) = 2000;
VariableCost(r,'CCGT',m,y) = 1e-5;
FixedCost(r,'CCGT',y) = 10;
ResidualCapacity(r,"OCGT",y) = 30;

# Characterize COGENERATION technology
OperationalLife(r,'CHP') = 40;
AvailabilityFactor(r,'CHP',y) = 0.85;
CapitalCost(r,'CHP',y) = 2000;
VariableCost(r,'CHP',m,y) = 1e-5;
FixedCost(r,'CHP',y) = 10;

# Characterize OIL technology
OperationalLife(r,'OIL_GEN') = 40;
AvailabilityFactor(r,'OIL_GEN',y) = 0.85;
CapitalCost(r,'OIL_GEN',y) = 2000;
VariableCost(r,'OIL_GEN',m,y) = 1e-5;
FixedCost(r,'OIL_GEN',y) = 10;
ResidualCapacity(r,"OIL_GEN",y) = 1.55;

# Characterize refineries 
OperationalLife(r,'SRE') = 40;
AvailabilityFactor(r,'SRE',y) = 0.85;
CapitalCost(r,'SRE',y) = 2000;
VariableCost(r,'SRE',m,y) = 1e-5;
FixedCost(r,'SRE',y) = 10;
ResidualCapacity(r,"SRE",y) = 1.55;

** ----------------------------------------------------------------
$elseif.ph %phase%=='popol'

InputActivityRatio(r,'SPV','SUN',"1",y) = 1; #IEA convention
OutputActivityRatio(r,'SPV','ELC',"1",y) = 1; 

InputActivityRatio(r,'WPP','WIN',"1",y) = 1; #IEA convention
OutputActivityRatio(r,'WPP','ELC',"1",y) = 1; 

InputActivityRatio(r,'WTE','WST',"1",y) = 1/0.25; 
OutputActivityRatio(r,'WTE','ELC',"1",y) = 1;

InputActivityRatio(r,'BIO','WBM',"1",y) = 1/0.25;
OutputActivityRatio(r,'BIO','ELC',"1",y) = 1;

InputActivityRatio(r,'GEO','GTH',"1",y) = 1/0.25;
OutputActivityRatio(r,'GEO','ELC',"1",y) = 1;

InputActivityRatio(r,'COAL','HCO',"1",y) = 1/0.45;
OutputActivityRatio(r,'COAL','ELC',"1",y) = 1;

InputActivityRatio(r,'ROR','HYD',"1",y) = 1;
OutputActivityRatio(r,'ROR','ELC',"1",y) = 1;

** open cycle gas turbines
InputActivityRatio(r,'OCGT','GAS',"1",y) = 1/0.35;
OutputActivityRatio(r,'OCGT','ELC',"1",y) = 1;

** cogeneration power plants produce electricity and heat
InputActivityRatio(r,'CHP','GAS',"1",y) = 1/0.6;
OutputActivityRatio(r,'CHP','ELC',"1",y) = 1;
OutputActivityRatio(r,'CHP','THE',"1",y) = 1;

** CCGT can also function as OCGT
InputActivityRatio(r,'CCGT','GAS',"1",y) = 1/0.6;
InputActivityRatio(r,'CCGT','GAS',"2",y) = 1/0.3;
OutputActivityRatio(r,'CCGT','ELC',"1",y) = 1;
OutputActivityRatio(r,'CCGT','ELC',"2",y) = 1;

** oil power plants
InputActivityRatio(r,'OIL_GEN','OIL',"1",y) = 1/0.2;
OutputActivityRatio(r,'OIL_GEN','ELC',"1",y) = 1;

** oil refineries
InputActivityRatio(r,'SRE','OIL',"1",y) = 1.1;
OutputActivityRatio(r,'SRE','GSL',"1",y) = 0.7;
OutputActivityRatio(r,'SRE','DSL',"1",y) = 0.3;

$endif.ph
