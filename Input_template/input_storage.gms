$set phase %1

** ------------------------------------------------
$ifthen.ph %phase%=='sets'

* ------------------------
* SET DEFINITIONS
* ------------------------

set STORAGE / DAM, BATTERIES /;

set TECHNOLOGY / 
    BEES       "Battery Energy Storage System",
    STOR_HYDRO "Pumped storage"
/;

* Technology subsets
set storage_plants(TECHNOLOGY) / BEES, STOR_HYDRO /;
set batteries(STORAGE)         / BATTERIES /;
set modular_storages(STORAGE)  / /;

** ------------------------------------------------
$elseif.ph %phase%=='data'

* ------------------------
* TECHNOLOGY PARAMETERS
* ------------------------

* Battery Energy Storage System (BEES)
CapitalCost(r,'BEES',y) = 0;  # Unit: €/kW
AvailabilityFactor(r,'BEES',y) = 0.9;
OperationalLife(r,'BEES') = 10;
VariableCost(r,'BEES',m,y) = 0;
FixedCost(r,'BEES',y) = 5;
CapacityFactor(r,'BEES',l,y) = 1; 
TotalAnnualMaxCapacityInvestment(r,'BEES',y) = 15;  

* Pumped Hydro Storage (STOR_HYDRO)
CapacityFactor(r,'STOR_HYDRO',"ID",y) = 0.7;
CapacityFactor(r,'STOR_HYDRO',"IN",y) = 0.7;
CapacityFactor(r,'STOR_HYDRO',"SD",y) = 0.3;
CapacityFactor(r,'STOR_HYDRO',"SN",y) = 0.3;
CapacityFactor(r,'STOR_HYDRO',"WD",y) = 0.5;
CapacityFactor(r,'STOR_HYDRO',"WN",y) = 0.5;

CapitalCost(r,'STOR_HYDRO',y) = 1500;  # Unit: €/kW
VariableCost(r,'STOR_HYDRO',m,y) = 0;
FixedCost(r,'STOR_HYDRO',y) = 5;
OperationalLife(r,'STOR_HYDRO') = 60;
ResidualCapacity(r,'STOR_HYDRO',y) = 7.25;
TotalAnnualMaxCapacityInvestment(r,'STOR_HYDRO',y) = 0;

* ------------------------
* STORAGE PARAMETERS
* ------------------------

* BATTERIES (BEES)
scalar a_BATT / 335    /,
       b_BATT / -0.7   /,
       c_BATT / 239444 /;
CapitalCostStorage(r,'BATTERIES',y)  = a_BATT*exp(b_BATT*(ord(y)-1)) + c_BATT;  # mln€/PJ
ResidualStorageCapacity(r,'BATTERIES',y)    = 0.065;         # PJ
StorageLevelStart(r,'BATTERIES')            = 0;             # PJ
TotalAnnualMaxStorageCapacity(r,'BATTERIES',y) = 10;        # PJ
#TotalAnnualMaxStorageCapacityInvestment(r,'BATTERIES',y)$(y.val < 2027) = 0.00;
#TotalAnnualMaxStorageCapacityInvestment(r,'BATTERIES',y)$(y.val >= 2028) = 0.144;  # PJ
TotalAnnualMaxStorageCapacityInvestment(r,'BATTERIES',y) = 0.144;  # PJ
StorageDuration('BATTERIES') = 4;  # in hours

* DAM (STOR_HYDRO)
CapitalCostStorage(r,'DAM',y) = 10000000;          # Unit: €/PJ
ResidualStorageCapacity(r,'DAM',y) = 0.144;        # Unit: PJ
StorageLevelStart(r,'DAM') = 0.144;  # Match capacity to avoid validation issues
MinStorageCharge(r,'DAM',y) = 0;
TotalAnnualMaxStorageCapacityInvestment(r,'DAM',y) = 0.00;  # PJ
StorageMaxChargeRate(r,'DAM') = 200;  # Unit: PJ/y
StorageMaxDischargeRate(r,'DAM') = 200;  # Unit: PJ/y

* ------------------------
* SELF-DISCHARGE MODELING
* ------------------------

* Monthly self-discharge rate (2%)
scalar BEES_monthly_discharge / 0.05 /;

* Per-time-slice self-discharge rate
loop(l,
    SelfDischargeRate('BATTERIES', l) = 
        1 - (1 - BEES_monthly_discharge) ** (12 * YearSplit(l,'2024'));
);

* Seasonal aggregated self-discharge rate
parameter SeasonSelfDischargeRate(STORAGE, SEASON);

SeasonSelfDischargeRate('BATTERIES', '1') = 1 - (1 - SelfDischargeRate('BATTERIES','WD')) 
                                               * (1 - SelfDischargeRate('BATTERIES','WN'));

SeasonSelfDischargeRate('BATTERIES', '2') = 1 - (1 - SelfDischargeRate('BATTERIES','ID')) 
                                               * (1 - SelfDischargeRate('BATTERIES','IN'));

SeasonSelfDischargeRate('BATTERIES', '3') = 1 - (1 - SelfDischargeRate('BATTERIES','SD')) 
                                               * (1 - SelfDischargeRate('BATTERIES','SN'));

** ------------------------------------------------
$elseif.ph %phase%=='popol'

* ------------------------
* ACTIVITY RATIOS
* ------------------------

* BEES (Battery)
InputActivityRatio(r,'BEES','ELC',"1",y)  = 1 / 0.95;
OutputActivityRatio(r,'BEES','ELC',"2",y) = 1;

* STOR_HYDRO (Pumped Hydro)
InputActivityRatio(r,'STOR_HYDRO','ELC',"1",y)  = 1 / 0.75;  # IEA convention
OutputActivityRatio(r,'STOR_HYDRO','ELC',"2",y) = 1;

* ------------------------
* TECHNOLOGY-STORAGE LINKS
* ------------------------

* BEES ↔ BATTERIES
TechnologyToStorage(r,"1",'BEES','BATTERIES')     = 1;
TechnologyFromStorage(r,"2",'BEES','BATTERIES')   = 1;
TechnologyToStorageMap(r,'BEES', 'BATTERIES',y)   = 1;

* STOR_HYDRO ↔ DAM (commented out intentionally)
TechnologyToStorage(r,"1",'STOR_HYDRO','DAM')     = 1;
TechnologyFromStorage(r,"2",'STOR_HYDRO','DAM')   = 1;
TechnologyToStorageMap(r,'STOR_HYDRO', 'DAM',y)   = 0;

$endif.ph