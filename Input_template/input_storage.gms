$set phase %1

** ------------------------------------------------
$ifthen.ph %phase%=='sets'

set     STORAGE / DAM, BATTERIES /;

SET TECHNOLOGY /BEES "Battery Energy Storage System"
                STOR_HYDRO 'Pumped storage'/;

set storage_plants(TECHNOLOGY) / BEES, STOR_HYDRO /;
set batteries(TECHNOLOGY) / BEES /;

set TechnologyToSorageMap(r,t,s,y)

** ------------------------------------------------
$elseif.ph %phase%=='data' 

# Characterize Battery Energy Storage System (BEES)
AvailabilityFactor(r,'BEES',y) = 0.9;
OperationalLife(r,'BEES') = 10;
VariableCost(r,'BEES',m,y) = 0;
FixedCost(r,'BEES',y) = 0;
StorageDuration('BEES')  = 4;

# characterize dam hydro storage
CapacityFactor(r,'STOR_HYDRO',"ID",y) = 0.7;
CapacityFactor(r,'STOR_HYDRO',"IN",y) = 0.7;
CapacityFactor(r,'STOR_HYDRO',"SD",y) = 0.3;
CapacityFactor(r,'STOR_HYDRO',"SN",y) = 0.3;
CapacityFactor(r,'STOR_HYDRO',"WD",y) = 0.5;
CapacityFactor(r,'STOR_HYDRO',"WN",y) = 0.5;
VariableCost(r,'STOR_HYDRO',m,y) = 1e-6;
FixedCost(r,'STOR_HYDRO',y) = 0;
OperationalLife(r,'STOR_HYDRO') = 60;
ResidualCapacity(r,'STOR_HYDRO',y) = 7.25;
TotalAnnualMaxCapacityInvestment(r,'STOR_HYDRO',y) = 0;
StorageDuration('STOR_HYDRO') = 6;

CapitalCostStorage(r,'BATTERIES',y) = 30000000;  # Unit: €/PJ
ResidualStorageCapacity(r,'BATTERIES',y) = 0;     # Unit: PJ
StorageLevelStart(r,'BATTERIES') = 0;             # Unit: PJ

CapitalCostStorage(r,'DAM',y) = 10000000;          # Unit: €/PJ
ResidualStorageCapacity(r,'DAM',y) = 3.596;        # Unit: PJ
StorageLevelStart(r,'DAM') = 3.596;  # Match capacity to avoid validation issues


** ------------------------------------------------
$elseif.ph %phase%=='popol'


InputActivityRatio(r,'BEES','ELC2',"1",y) = 1;
OutputActivityRatio(r,'BEES','ELC1',"2",y) = 0.9;

InputActivityRatio(r,'STOR_HYDRO','ELC2',"1",y) = 1; #IEA convention
OutputActivityRatio(r,'STOR_HYDRO','ELC1',"2",y) = 1; #IEA convention

TechnologyToStorage(r,"1",'BEES','BATTERIES') = 1;
TechnologyFromStorage(r,"2",'BEES','BATTERIES') = 1;

TechnologyToStorage(r,"1",'STOR_HYDRO','DAM') = 1;
TechnologyFromStorage(r,"2",'STOR_HYDRO','DAM') = 1;

TechnologyToStorageMap('BEES', 'BATTERIES') = yes;
TechnologyToStorageMap('STOR_HYDRO', 'DAM') = yes;

$endif.ph