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

set fuel_transmission(TECHNOLOGY) / GRIDGAS /;
** ----------------------------------------------------------------
$elseif.ph %phase%=='data'

*** characterize technologies

#FOSSIL FUELS
CapitalCost(r,'IMPGAS',y) = 0;  # based on mid-point 2023 | Unit: €/kW
VariableCost(r,'IMPGAS',m,y) = 7.5;  # Unit: €/GJ <-> mln€/PJ
FixedCost(r,'IMPGAS',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'IMPGAS') = 40;  # Unit: years
#AvailabilityFactor(r,'IMPGAS',y) = 1;  # Unit: dimensionless
EmissionActivityRatio(r,'IMPGAS','CO2','1',y) = 0.0561;  # Unit: Mton CO2 per PJ
ResidualCapacity(r,"IMPGAS",y) = 999;  # Unit: GW

CapitalCost(r,'IMPHCO1',y) = 0;  # Unit: €/kW
VariableCost(r,'IMPHCO1',m,y) = 1.3;  # Unit: €/GJ <-> mln€/PJ
FixedCost(r,'IMPHCO1',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'IMPHCO1') = 999;  # Unit: years
#AvailabilityFactor(r,'IMPHCO1',y) = 1;  # Unit: dimensionless
EmissionActivityRatio(r,'IMPHCO1','CO2','1',y) = 0.0895;  # Unit: Mton CO2 per PJ
ResidualCapacity(r,"IMPHCO1",y) = 999;  # Unit: GW

CapitalCost(r,'IMPOIL1',y) = 0;  # Unit: €/kW
VariableCost(r,'IMPOIL1',m,y) = 7.5;  # Unit: €/GJ <-> mln€/PJ
FixedCost(r,'IMPOIL1',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'IMPOIL1') = 999;  # Unit: years
#AvailabilityFactor(r,'IMPOIL1',y) = 1;  # Unit: dimensionless
EmissionActivityRatio(r,'IMPOIL1','CO2','1',y) = 0.073;  # Unit: Mton CO2 per PJ
ResidualCapacity(r,"IMPOIL1",y) = 999;  # Unit: GW

CapitalCost(r,'GRIDGAS',y) = 0.7;            # €/kW - Based on midpoint of 2023 cost range
VariableCost(r,'GRIDGAS',m,y) = 0.00001;     # €/MWh - Minor O&M cost
FixedCost(r,'GRIDGAS',y) = 0.01;             # €/kW-year - ~1.5% of CAPEX
OperationalLife(r,'GRIDGAS') = 40;           # Years
#AvailabilityFactor(r,'GRIDGAS',y) = 1;       # Dimensionless
EmissionActivityRatio(r,'GRIDGAS','CO2','1',y) = 0.0561;  # kton CO2 per PJ (infra ops)
ResidualCapacity(r,"GRIDGAS",y) = 60;        # GW - National-scale gas grid capacity (assumed constant)


###RENEWABLES
CapitalCost(r,'IMPBIO1',y) = 0;  # Unit: €/kW
VariableCost(r,'IMPBIO1',m,y) = 9;  # Unit: €/GJ <-> mln€/PJ  
FixedCost(r,'IMPBIO1',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'IMPBIO1') = 999;  # Unit: years
#AvailabilityFactor(r,'IMPBIO1',y) = 1;  # Unit: dimensionless
EmissionActivityRatio(r,'IMPBIO1','CO2','1',y) = 0.0;  # Unit: kg CO2 per PJ
ResidualCapacity(r,"IMPBIO1",y) = 999;  # Unit: GW

#SUN
CapitalCost(r,'VIR_SUN',y) = 0;  # Unit: €/kW
VariableCost(r,'VIR_SUN',m,y) = 0;  # Unit: €/GJ <-> mln€/PJ 
FixedCost(r,'VIR_SUN',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'VIR_SUN') = 25;  # Unit: years
#AvailabilityFactor(r,'VIR_SUN',y) = 0.2;  # Unit: dimensionless
ResidualCapacity(r,"VIR_SUN",y) = 999;  # Unit: GW

#WIN
CapitalCost(r,'VIR_WIN',y) = 0;  # Unit: €/kW
VariableCost(r,'VIR_WIN',m,y) = 0;  # Unit: €/GJ <-> mln€/PJ 
FixedCost(r,'VIR_WIN',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'VIR_WIN') = 25;  # Unit: years
#AvailabilityFactor(r,'VIR_WIN',y) = 0.3;  # Unit: dimensionless
ResidualCapacity(r,"VIR_WIN",y) = 999;  # Unit: GW

#HYD (technology non existent in previous files)
CapitalCost(r,'VIR_HYD',y) = 0;  # Unit: €/kW
VariableCost(r,'VIR_HYD',m,y) = 0;  # Unit: €/GJ <-> mln€/PJ 
FixedCost(r,'VIR_HYD',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'VIR_HYD') = 80;  # Unit: years
#AvailabilityFactor(r,'VIR_HYD',y) = 0.45;  # Unit: dimensionless
ResidualCapacity(r,"VIR_HYD",y) = 999;  # Unit: GW

#GTH (Geothermal)
CapitalCost(r,'VIR_GTH',y) = 0;  # Unit: €/kW
VariableCost(r,'VIR_GTH',m,y) = 0;  # Unit: €/GJ <-> mln€/PJ 
FixedCost(r,'VIR_GTH',y) = 0;  # Unit: €/kW-year
OperationalLife(r,'VIR_GTH') = 30;  # Unit: years
#AvailabilityFactor(r,'VIR_GTH',y) = 0.9;  # Unit: dimensionless
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