$set phase %1

** ------------------------------------------------
$ifthen.ph %phase%=='sets'

set     STORAGE / DAM, HYDROGEN /;

SET TECHNOLOGY /HEL   "Hydrogen Electrolyzers",
                STOR_HYDRO 'Pumped storage'/;

set storage_plants(TECHNOLOGY) / HEL, STOR_HYDRO /;


** ------------------------------------------------
$elseif.ph %phase%=='data' 

# Characterize ELECTROLIZERS
AvailabilityFactor(r,'HEL',y) = 0.9;
OperationalLife(r,'HEL') = 10;
CapitalCost(r,'HEL',y) = 1;
VariableCost(r,'HEL',m,y) = 0;
FixedCost(r,'HEL',y) = 0;

# characterize dam hydro storage
CapacityFactor(r,'STOR_HYDRO',"ID",y) = 0.7;
CapacityFactor(r,'STOR_HYDRO',"IN",y) = 0.7;
CapacityFactor(r,'STOR_HYDRO',"SD",y) = 0.3;
CapacityFactor(r,'STOR_HYDRO',"SN",y) = 0.3;
CapacityFactor(r,'STOR_HYDRO',"WD",y) = 0.5;
CapacityFactor(r,'STOR_HYDRO',"WN",y) = 0.5;
CapitalCost(r,'STOR_HYDRO',y) = 1000;
VariableCost(r,'STOR_HYDRO',m,y) = 0;
FixedCost(r,'STOR_HYDRO',y) = 0;
OperationalLife(r,'STOR_HYDRO') = 60;
ResidualCapacity(r,'STOR_HYDRO',y) = 7.25;
TotalAnnualMaxCapacityInvestment(r,'STOR_HYDRO',y) = 0;
CapitalCostStorage(r,'HYDROGEN',y) = 100;
ResidualStorageCapacity(r,'HYDROGEN',y) = 0;
StorageLevelStart(r,'HYDROGEN') = 0;

CapitalCostStorage(r,'DAM',y) = 100;
ResidualStorageCapacity(r,'DAM',y) = 999;
StorageLevelStart(r,'DAM') = 999;


** ------------------------------------------------
$elseif.ph %phase%=='popol'


InputActivityRatio(r,'HEL','ELC',"1",y) = 2; #IEA convention
OutputActivityRatio(r,'HEL','ELC',"2",y) = 0.6; #IEA convention

InputActivityRatio(r,'STOR_HYDRO','ELC',"2",y) = 1; #IEA convention
OutputActivityRatio(r,'STOR_HYDRO','ELC',"1",y) = 1; #IEA convention

TechnologyToStorage(r,"1",'HEL','HYDROGEN') = 1;
TechnologyFromStorage(r,"2",'HEL','HYDROGEN') = 1;

TechnologyToStorage(r,"2",'STOR_HYDRO','DAM') = 1;
TechnologyFromStorage(r,"1",'STOR_HYDRO','DAM') = 1;

$endif.ph