$set phase %1

** ----------------------------------------------------------------
$ifthen.ph %phase%=='sets'
set     TECHNOLOGY      /
# fossil fuels import
        IMPGAS 'Gas imports' 
        GRIDGAS 'Gas grid' 
        IMPHCO1 'Coal imports' 
        IMPOIL1 'Crude oil imports' 
# renewable fuel "import"    
        IMPBIO1 'Biomass supply'
        VIR_SUN 'Virtual sun technology' 
        VIR_WIN 'Virtual wind technology' 
        VIR_GTH 'Virtual geothermal technology'
        VIR_HYD 'Virtual hydro technology'
/;


set     FUEL    /
        HCO 'Coal' #HCO
        GAS 'Import gas'
        GAS2 'Grid gas' ##we must force the gas through the gas grid first, so we convert GAS to GAS2 to force gas into the gas grid first
        OIL 'Crude oil'
        GTH 'Geothermal energy'
        SUN 'Solar energy'
        WIN 'Wind energy'
        HYD 'Hydro energy'
        WBM 'Biomass energy'
/;

set renewable_fuel(FUEL) /GTH, SUN, WIN, HYD, WBM/;
** ----------------------------------------------------------------
$elseif.ph %phase%=='data'

*** characterize technologies

#FOSSIL FUELS
CapitalCost(r,'IMPGAS',y) = 0;  # Unit: €/kW
VariableCost(r,'IMPGAS',m,y) = 20;  # Unit: €/MWh # cost of imported natural gas in €/MWh
FixedCost(r,'IMPGAS',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'IMPGAS') = 999;  # Unit: years
AvailabilityFactor(r,'IMPGAS',y) = 1;  # Unit: dimensionless
EmissionActivityRatio(r,'IMPGAS','CO2','1',y) = 0.075;  # Unit: Gton CO2 per PJ
ResidualCapacity(r,"IMPGAS",y) = 999;  # Unit: GW

CapitalCost(r,'IMPHCO1',y) = 0;  # Unit: €/kW
VariableCost(r,'IMPHCO1',m,y) = 15;  # Unit: €/MWh # cost of imported coal in €/MWh
FixedCost(r,'IMPHCO1',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'IMPHCO1') = 999;  # Unit: years
AvailabilityFactor(r,'IMPHCO1',y) = 1;  # Unit: dimensionless
EmissionActivityRatio(r,'IMPHCO1','CO2','1',y) = 0.089;  # Unit: Gton CO2 per PJ
ResidualCapacity(r,"IMPHCO1",y) = 999;  # Unit: GW

CapitalCost(r,'IMPOIL1',y) = 0;  # Unit: €/kW
VariableCost(r,'IMPOIL1',m,y) = 35;  # Unit: €/MWh # cost of imported oil in €/MWh
FixedCost(r,'IMPOIL1',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'IMPOIL1') = 999;  # Unit: years
AvailabilityFactor(r,'IMPOIL1',y) = 1;  # Unit: dimensionless
EmissionActivityRatio(r,'IMPOIL1','CO2','1',y) = 0.075;  # Unit: Gton CO2 per PJ
ResidualCapacity(r,"IMPOIL1",y) = 999;  # Unit: GW

CapitalCost(r,'GRIDGAS',y) = 0;  # Unit: €/kW
VariableCost(r,'GRIDGAS',m,y) = 0;  # Unit: €/MWh # cost of gas in $/MWh
FixedCost(r,'GRIDGAS',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'GRIDGAS') = 40;  # Unit: years
AvailabilityFactor(r,'GRIDGAS',y) = 1;  # Unit: dimensionless
EmissionActivityRatio(r,'GRIDGAS','CO2','1',y) = 0.055;  # Unit: kg CO2 per PJ
ResidualCapacity(r,"GRIDGAS",y) = 999;  # Unit: GW


###RENEWABLES
CapitalCost(r,'IMPBIO1',y) = 0;  # Unit: €/kW
VariableCost(r,'IMPBIO1',m,y) = 5;  # Unit: €/MWh # estimated cost of biomass (€/MWh)  
FixedCost(r,'IMPBIO1',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'IMPBIO1') = 999;  # Unit: years
AvailabilityFactor(r,'IMPBIO1',y) = 1;  # Unit: dimensionless
EmissionActivityRatio(r,'IMPBIO1','CO2','1',y) = 0.0;  # Unit: kg CO2 per PJ
ResidualCapacity(r,"IMPBIO1",y) = 999;  # Unit: GW

#SUN
CapitalCost(r,'VIR_SUN',y) = 0;  # Unit: €/kW
VariableCost(r,'VIR_SUN',m,y) = 0;  # Unit: €/MWh 
FixedCost(r,'VIR_SUN',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'VIR_SUN') = 999;  # Unit: years
AvailabilityFactor(r,'VIR_SUN',y) = 1;  # Unit: dimensionless
ResidualCapacity(r,"VIR_SUN",y) = 999;  # Unit: GW

#WIN
CapitalCost(r,'VIR_WIN',y) = 0;  # Unit: €/kW
VariableCost(r,'VIR_WIN',m,y) = 0;  # Unit: €/MWh 
FixedCost(r,'VIR_WIN',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'VIR_WIN') = 999;  # Unit: years
AvailabilityFactor(r,'VIR_WIN',y) = 1;  # Unit: dimensionless
ResidualCapacity(r,"VIR_WIN",y) = 999;  # Unit: GW

#HYD (technology non existent in previous files)
CapitalCost(r,'VIR_HYD',y) = 0;  # Unit: €/kW
VariableCost(r,'VIR_HYD',m,y) = 0;  # Unit: €/MWh 
FixedCost(r,'VIR_HYD',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'VIR_HYD') = 999;  # Unit: years
AvailabilityFactor(r,'VIR_HYD',y) = 1;  # Unit: dimensionless
ResidualCapacity(r,"VIR_HYD",y) = 999;  # Unit: GW

#GTH (Geothermal)
CapitalCost(r,'VIR_GTH',y) = 0;  # Unit: €/kW
VariableCost(r,'VIR_GTH',m,y) = 0;  # Unit: €/MWh 
FixedCost(r,'VIR_GTH',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'VIR_GTH') = 999;  # Unit: years
AvailabilityFactor(r,'VIR_GTH',y) = 1;  # Unit: dimensionless
ResidualCapacity(r,"VIR_GTH",y) = 999;  # Unit: GW

** ----------------------------------------------------------------
$elseif.ph %phase%=="popol"
#Fossil fuels + gas grid
OutputActivityRatio(r,'IMPHCO1','HCO',"1",y) = 1;
OutputActivityRatio(r,'IMPGAS','GAS',"1",y) = 1; #imported gas turns into gas
InputActivityRatio(r, 'GRIDGAS', 'GAS', "1", y) = 1; # gas is routed through the grid, converted from GAS to GAS2
OutputActivityRatio(r, "GRIDGAS", 'GAS2', "1", y) = 1; #conversion to gas usable from gas grid
OutputActivityRatio(r, "IMPOIL1", "OIL", "1", y) = 1;  # oil is directly available from imports (no input fuel) #conversion to oil
OutputActivityRatio(r, 'IMPBIO1','WBM',"1",y) = 1; #conversion to bio energy

#Renewables
OutputActivityRatio(r,'VIR_SUN','SUN',"1",y) = 1;
OutputActivityRatio(r,'VIR_WIN','WIN',"1",y) = 1;
OutputActivityRatio(r,'VIR_GTH','GTH',"1",y) = 1;
OutputActivityRatio(r,'VIR_HYD','HYD',"1",y) = 1;


$endif.ph