$set phase %1

** ------------------------------------------------
$ifthen.ph %phase%=='sets'

set     STORAGE / DAM, BATTERIES /;

SET TECHNOLOGY /BEES "Battery Energy Storage System"
                STOR_HYDRO 'Pumped storage'/;

set storage_plants(TECHNOLOGY) / BEES, STOR_HYDRO /;
set batteries(TECHNOLOGY) / BEES /;

** ------------------------------------------------
$elseif.ph %phase%=='data' 

# Characterize ELECTROLIZERS
AvailabilityFactor(r,'BEES',y) = 0.9;
OperationalLife(r,'BEES') = 10;
CapitalCost(r,'BEES',y) = 1;
VariableCost(r,'BEES',m,y) = 0;
FixedCost(r,'BEES',y) = 0;

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

CapitalCostStorage(r,'BATTERIES',y) = 100;
ResidualStorageCapacity(r,'BATTERIES',y) = 0;
StorageLevelStart(r,'BATTERIES') = 0;
StorageMaxChargeRate(r, 'BATTERIES',y) = 0.5;
StorageMaxDischargeRate(r, 'BATTERIES',y) = 0.5;
MinStorageCharge(r,'BATTERIES',y);
OperationalLifeStorage(r,'BATTERIES') = 10;


CapitalCostStorage(r,'DAM',y) = 100;
ResidualStorageCapacity(r,'DAM',y) = 999;
StorageLevelStart(r,'DAM') = 999;
StorageMaxChargeRate(r, 'DAM',y) = 0.5;
StorageMaxDischargeRate(r, 'DAM',y) = 0.5;
MinStorageCharge(r,'DAM',y);
OperationalLifeStorage(r,'DAM') = 60;


** ------------------------------------------------
$elseif.ph %phase%=='popol'


InputActivityRatio(r,'BEES','ELC2',"1",y) = 2; #IEA convention
OutputActivityRatio(r,'BEES','ELC1',"2",y) = 0.6; #IEA convention

InputActivityRatio(r,'STOR_HYDRO','ELC2',"1",y) = 1; #IEA convention
OutputActivityRatio(r,'STOR_HYDRO','ELC1',"2",y) = 1; #IEA convention

TechnologyToStorage(r,"1",'BEES','BATTERIES') = 1;
TechnologyFromStorage(r,"2",'BEES','BATTERIES') = 1;

TechnologyToStorage(r,"1",'STOR_HYDRO','DAM') = 1;
TechnologyFromStorage(r,"2",'STOR_HYDRO','DAM') = 1;

$endif.ph