$set phase %1

** ----------------------------------------------------------------
$ifthen.ph %phase%=='sets'

set     TECHNOLOGY      /
        #fossil fuels
        IMPGAS 'Gas imports' 
        GRIDGAS 'Gas grid' 
        IMPHCO1 'Coal imports' 
        IMPOIL1 'Crude oil imports' 
        IMPBIO1 'Biomass supply'

        #renewable technologies
        VIR_SUN 'Virtual sun technology' 
        VIR_WIN 'Virtual wind technology' 
        VIR_GTH 'Virtual geothermal technology'
        RIV 'River'
        SOIL 'Geothermal Energy input'
/;


set     FUEL    /
        # fossil fuels
        HCO 'Coal' #HCO
        GAS 'Import gas'
        GAS2 'Grid gas' ##we must force the gas through the gas grid first, so we convert GAS to GAS2 to force gas into the gas grid first
        OIL 'Crude oil'

        #renewables
        GTH 'Geothermal energy'
        SUN 'Solar energy'
        WIN 'Wind energy'
        HYD 'Hydro energy'
        BIO 'Biomass energy'
/;

** ----------------------------------------------------------------
$elseif.ph %phase%=='data'

*** characterize technologies

#FOSSIL FUELS
CapitalCost(r,'IMPGAS',y) = 0;
VariableCost(r,'IMPGAS',m,y) = 2; # cost of gasoline in $/MWh
FixedCost(r,'IMPGAS',y) = 0;
OperationalLife(r,'IMPGAS') = 999;
AvailabilityFactor(r,'IMPGAS',y) = 1;
EmissionActivityRatio(r,'IMPGAS','CO2','1',y) = 0.075;
ResidualCapacity(r,"IMPGAS",y) = 999;

CapitalCost(r,'IMPHCO1',y) = 0;
VariableCost(r,'IMPHCO1',m,y) = 2; # cost of coal in $/MWh
FixedCost(r,'IMPHCO1',y) = 0;
OperationalLife(r,'IMPHCO1') = 999;
AvailabilityFactor(r,'IMPHCO1',y) = 1;
EmissionActivityRatio(r,'IMPHCO1','CO2','1',y) = 0.089;
ResidualCapacity(r,"IMPHCO1",y) = 999;

CapitalCost(r,'IMPOIL1',y) = 0;
VariableCost(r,'IMPOIL1',m,y) = 10; # cost of oil in $/MWh
FixedCost(r,'IMPOIL1',y) = 0;
OperationalLife(r,'IMPOIL1') = 999;
AvailabilityFactor(r,'IMPOIL1',y) = 1;
EmissionActivityRatio(r,'IMPOIL1','CO2','1',y) = 0.075;
ResidualCapacity(r,"IMPOIL1",y) = 999;

CapitalCost(r,'GRIDGAS',y) = 0;
VariableCost(r,'GRIDGAS',m,y) = 0; # cost of gas in $/MWh
FixedCost(r,'GRIDGAS',y) = 0;
OperationalLife(r,'GRIDGAS') = 40;
AvailabilityFactor(r,'GRIDGAS',y) = 1;
EmissionActivityRatio(r,'GRIDGAS','CO2','1',y) = 0.055;
ResidualCapacity(r,"GRIDGAS",y) = 999;


###RENEWABLES
CapitalCost(r,'IMPBIO1',y) = 0;
VariableCost(r,'IMPBIO1',m,y) = 1e-5; #pasted cmt: not that free actually | cost of biomass in $/MWh  
FixedCost(r,'IMPBIO1',y) = 0;
OperationalLife(r,'IMPBIO1') = 999;
AvailabilityFactor(r,'IMPBIO1',y) = 1;
EmissionActivityRatio(r,'IMPBIO1','CO2','1',y) = 0;
ResidualCapacity(r,"IMPBIO1",y) = 999;

#SUN
CapitalCost(r,'VIR_SUN',y) = 0;
VariableCost(r,'VIR_SUN',m,y) = 0; 
FixedCost(r,'VIR_SUN',y) = 0;
OperationalLife(r,'VIR_SUN') = 999;
AvailabilityFactor(r,'VIR_SUN',y) = 1;
ResidualCapacity(r,"VIR_SUN",y) = 999;

#WIN
CapitalCost(r,'VIR_WIN',y) = 0;
VariableCost(r,'VIR_WIN',m,y) = 0; 
FixedCost(r,'VIR_WIN',y) = 0;
OperationalLife(r,'VIR_WIN') = 999;
AvailabilityFactor(r,'VIR_WIN',y) = 1;
ResidualCapacity(r,"VIR_WIN",y) = 999;

#HYD (technology non existent in previous files)
CapitalCost(r,'VIR_HYD',y) = 0;
VariableCost(r,'VIR_HYD',m,y) = 0; 
FixedCost(r,'VIR_HYD',y) = 0;
OperationalLife(r,'VIR_HYD') = 999;
AvailabilityFactor(r,'VIR_HYD',y) = 1;
ResidualCapacity(r,"VIR_HYD",y) = 999;

** ----------------------------------------------------------------
$elseif.ph %phase%=="popol"
#Fossil fuels + gas grid
OutputActivityRatio(r,'IMPHCO1','HCO',"1",y) = 1;
OutputActivityRatio(r,'IMPGAS','GAS',"1",y) = 1; #imported gas turns into gas
InputActivityRatio(r, 'GRIDGAS', 'GAS', "1", y) = 1; #incorrect value, ratio as grid turns into gas
OutputActivityRatio(r, "GRIDGAS", 'GAS2', "1", y) = 1; #conversion to gas usable from gas grid
InputActivityRatio(r, "IMPOIL1", "OIL", "1", y) = 1; #conversion to oil
OutputActivityRatio(r, 'IMPBIO1','BIO',"1",y) = 1; #conversion to bio energy

#Renewables
OutputActivityRatio(r,'VIR_SUN','SUN',"1",y) = 1;
OutputActivityRatio(r,'VIR_WIN','WIN',"1",y) = 1;
OutputActivityRatio(r,'VIR_GTH','GTH',"1",y) = 1;
OutputActivityRatio(r,'VIR_HYD','HYD',"1",y) = 1;
InputActivityRatio(r, "RIV", "HYD", "1", y) = 1; #conversion to hydro energy
InputActivityRatio(r, "SOIL", "GTH", "1", y) = 1; #conversion to geothermal energy


$endif.ph