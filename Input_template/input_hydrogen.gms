$set phase %1

** ------------------------------------------------
$ifthen.ph %phase%=='sets'

set     STORAGE / HYDROGEN /;

SET TECHNOLOGY /HEL   "Hydrogen Electrolyzers",
                FUEL_CELL "Fuel Cells",
                SMR_CCS "Steam Methane Reforming + CCS" 
                IHH "Industrial Heating - Hydrogen" 
                GRID_H2 "Hydrogen Grid" 
                UHS "Underground Hydrogen Storage" 
                TANKS "H2 tanks" /;  #??????????

set FUEL / H2_stored "Hydrogen stored",
           H2 "Hydrogen" /; #??????????
/;

set storage_plants(TECHNOLOGY) / UHS, TANKS /;

** ------------------------------------------------
$elseif.ph %phase%=='data' 

# Characterize Reversible Electrochemical Devices
AvailabilityFactor(r,'REV_DEV',y) = 0.9;
OperationalLife(r,'REV_DEV') = 10;
CapitalCost(r,'REV_DEV',y) = 1;
VariableCost(r,'REV_DEV',m,y) = 0;
FixedCost(r,'REV_DEV',y) = 0;


** ------------------------------------------------

$elseif.ph %phase%=='popol'


InputActivityRatio(r,'REV_DEV','ELC2',"1",y) = 2; #IEA convention
OutputActivityRatio(r,'REV_DEV','H2',"1",y) = 1; #IEA convention

InputActivityRatio(r,'REV_DEV','H2',"2",y) = 1; #IEA convention
OutputActivityRatio(r,'REV_DEV','ELC1',"2",y) = 0.6; #IEA convention

TechnologyToStorage(r,"1",'REV_DEV','HYDROGEN') = 1;
TechnologyFromStorage(r,"2",'REV_DEV','HYDROGEN') = 1;

$endif.ph