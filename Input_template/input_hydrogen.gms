$set phase %1

$ifthen.ph %phase%=='sets'

set STORAGE / UHS, TANKS /;

set TECHNOLOGY /
    HEL_UHS       "Electrolyzer → UHS",
    HEL_TANKS     "Electrolyzer → TANKS",
    SMR_UHS       "SMR + CCS → UHS",
    SMR_TANKS     "SMR + CCS → TANKS",
    FC_UHS        "Fuel Cell ← UHS",
    FC_TANKS      "Fuel Cell ← TANKS",
    GRID_H2_UHS   "Hydrogen Grid ← UHS",
    GRID_H2_TANKS "Hydrogen Grid ← TANKS",
    IHH           "Industrial Heating - Hydrogen"
/;

set FUEL /
    H2_GREEN "Green Hydrogen",
    H2_BLUE  "Blue Hydrogen",
    H2_TH    "Hydrogen Thermal",
    ELC_ACC_H2 "Electricity from Hydrogen",
    IH_ACC_H2 "Industrial Heating from Hydrogen"
/;

set hydrogen_tech(TECHNOLOGY) / HEL_UHS, HEL_TANKS, SMR_UHS, SMR_TANKS, FC_UHS, FC_TANKS, GRID_H2_UHS, GRID_H2_TANKS /;
set storage_plants(TECHNOLOGY) / HEL_UHS, HEL_TANKS, FC_UHS, FC_TANKS /;
set hydrogen_storages(STORAGE) / UHS, TANKS /;
set modular_storages(STORAGE) / UHS /;
set fuel_consumption(TECHNOLOGY) / IHH /;
set power_plants(TECHNOLOGY) / FC_UHS, FC_TANKS /;

$elseif.ph %phase%=='data'



* ----------- Tech Parameters (Availability, Life) ----------
AvailabilityFactor(r,t,y)$hydrogen_tech(t) = 0.95;
AvailabilityFactor(r,'HEL_UHS',y) = 0.3;
AvailabilityFactor(r,'HEL_TANKS',y) = 0.3;
CapacityFactor(r,t,l,y)$hydrogen_tech(t) = 1;

OperationalLife(r,'HEL_UHS') = 10;
OperationalLife(r,'HEL_TANKS') = 10;
OperationalLife(r,'SMR_UHS') = 25;
OperationalLife(r,'SMR_TANKS') = 25;
OperationalLife(r,'FC_UHS') = 10;
OperationalLife(r,'FC_TANKS') = 10;
OperationalLife(r,'GRID_H2_UHS') = 40;
OperationalLife(r,'GRID_H2_TANKS') = 40;
OperationalLife(r,'IHH') = 15;

* ----------- Capital Costs: alias reused -----------

* HEL (€/kW)
loop(y,
    CapitalCost(r,'HEL_TANKS',y) = 1200 - 32*(ord(y)-1);
);
loop(y,
    CapitalCost(r,'HEL_UHS',y) =  1200 - 32*(ord(y)-1);
);

* SMR (€/kW)
loop(y,
    CapitalCost(r,'SMR_TANKS',y) = 1600 - 24*(ord(y)-1);
);
loop(y,
    CapitalCost(r,'SMR_UHS',y) = 1600 - 24*(ord(y)-1);
);

* FC (€/kW)
loop(y,
    CapitalCost(r,'FC_TANKS',y) = 1600 - 30*(ord(y)-1);
);
loop(y,
    CapitalCost(r,'FC_UHS',y) = 1600 - 30*(ord(y)-1);
);

* GRID H2 (€/kW)
loop(y,
     CapitalCost(r,'GRID_H2_TANKS',y) = 152 - 4*(ord(y)-1);
);
loop(y,
    CapitalCost(r,'GRID_H2_UHS',y) = 152 - 4*(ord(y)-1);
);

CapitalCost(r,'IHH',y) = 0;


* ---------- Fixed Costs ----------
FixedCost(r,t,y) = 0.03 * CapitalCost(r,t,y);
FixedCost(r,'FC_UHS',y) = FixedCost(r,'FC_TANKS',y) = 0.025 * CapitalCost(r,'FC_UHS',y);
FixedCost(r,'IHH',y) = 0;


* ---------- Variable Costs ----------
VariableCost(r,'HEL_UHS',m,y)     = 0.5;
VariableCost(r,'HEL_TANKS',m,y)   = 0.5;
VariableCost(r,'SMR_UHS',m,y)     = 3.5;
VariableCost(r,'SMR_TANKS',m,y)   = 3.5;
VariableCost(r,'FC_UHS',m,y)      = 1;
VariableCost(r,'FC_TANKS',m,y)    = 1;
VariableCost(r,'GRID_H2_UHS',m,y) = 0.3;
VariableCost(r,'GRID_H2_TANKS',m,y) = 0.3;
VariableCost(r,'IHH',m,y)         = 0;


* ---------- Max Capacity Investments
TotalAnnualMaxCapacityInvestment(r,'HEL_UHS',y) = 3;
TotalAnnualMaxCapacityInvestment(r,'HEL_TANKS',y) = 3;
TotalAnnualMaxCapacityInvestment(r,'IHH',y) = 10;

*------------ Storage Parameters -----------

# UHS storage Technology
ResidualStorageCapacity(r,'UHS',y) = 0;  # Unit: PJ (explicitly zero)
StorageLevelStart(r,'UHS') = 0;          # Unit: PJ (explicitly zero)
StorageMaxChargeRate(r,'UHS') = 60;       # Charge/discharge rates set to 1 since UHS_CHARGE tech models actual flow constraints
StorageMaxDischargeRate(r,'UHS') = 60;
#MinStorageCharge(r,'UHS',y) = 0.1;
OperationalLifeStorage(r,'UHS') = 30;
StorageDuration('UHS')   = 720 ;   # 30 days

# Source: H2 Storage Cost Assessment file, aligned with IEA/IRENA/Hydrogen Council reports
# Units: €/PJ of working gas capacity
CapitalCostStorage(r,'UHS','2024') = 17500;
CapitalCostStorage(r,'UHS','2025') = 17167;
CapitalCostStorage(r,'UHS','2026') = 16917;
CapitalCostStorage(r,'UHS','2027') = 16583;
CapitalCostStorage(r,'UHS','2028') = 16250;
CapitalCostStorage(r,'UHS','2029') = 15917;
CapitalCostStorage(r,'UHS','2030') = 15583;
CapitalCostStorage(r,'UHS','2031') = 15333;
CapitalCostStorage(r,'UHS','2032') = 15000;
CapitalCostStorage(r,'UHS','2033') = 14667;
CapitalCostStorage(r,'UHS','2034') = 14333;
CapitalCostStorage(r,'UHS','2035') = 14000;
CapitalCostStorage(r,'UHS','2036') = 13750;
CapitalCostStorage(r,'UHS','2037') = 13417;
CapitalCostStorage(r,'UHS','2038') = 13083;
CapitalCostStorage(r,'UHS','2039') = 12750;
CapitalCostStorage(r,'UHS','2040') = 12417;
CapitalCostStorage(r,'UHS','2041') = 12167;
CapitalCostStorage(r,'UHS','2042') = 11833;
CapitalCostStorage(r,'UHS','2043') = 11500;
CapitalCostStorage(r,'UHS','2044') = 11167;
CapitalCostStorage(r,'UHS','2045') = 10917;
CapitalCostStorage(r,'UHS','2046') = 10583;
CapitalCostStorage(r,'UHS','2047') = 10250;
CapitalCostStorage(r,'UHS','2048') = 9917;
CapitalCostStorage(r,'UHS','2049') = 9583;
CapitalCostStorage(r,'UHS','2050') = 9333;

StorageUnitSize(r, 'UHS', y) = 0.5;  # Unit: PJ
TotalAnnualMaxStorageCapacity(r,'UHS',y) = 126;  # Unit: PJ
TotalAnnualMaxStorageCapacityInvestment(r,'UHS',y)$(y.val <= 2030) = 0;  # Unit: PJ
TotalAnnualMaxStorageCapacityInvestment(r,'UHS',y)$(y.val > 2030) = 0.5;  # Unit: PJ

# Hydrogen Tanks (TANKS)
ResidualStorageCapacity(r,'TANKS',y) = 0;  # Unit: PJ (explicitly zero)
StorageLevelStart(r,'TANKS') = 0;          # Unit: PJ (explicitly zero)
StorageMaxChargeRate(r,'TANKS') = 100;
StorageMaxDischargeRate(r,'TANKS') = 100;
#MinStorageCharge(r,'TANKS',y) = 0.1;
OperationalLifeStorage(r,'TANKS') = 20; 
StorageDuration('TANKS') = 240 ;   # 10 days

# CapitalCostStorage defined yearly in €/PJ
CapitalCostStorage(r,'TANKS','2024') = 76333;
CapitalCostStorage(r,'TANKS','2025') = 75167;
CapitalCostStorage(r,'TANKS','2026') = 74083;
CapitalCostStorage(r,'TANKS','2027') = 72917;
CapitalCostStorage(r,'TANKS','2028') = 71750;
CapitalCostStorage(r,'TANKS','2029') = 70583;
CapitalCostStorage(r,'TANKS','2030') = 69500;
CapitalCostStorage(r,'TANKS','2031') = 68333;
CapitalCostStorage(r,'TANKS','2032') = 67167;
CapitalCostStorage(r,'TANKS','2033') = 66000;
CapitalCostStorage(r,'TANKS','2034') = 64833;
CapitalCostStorage(r,'TANKS','2035') = 63750;
CapitalCostStorage(r,'TANKS','2036') = 62583;
CapitalCostStorage(r,'TANKS','2037') = 61417;
CapitalCostStorage(r,'TANKS','2038') = 60250;
CapitalCostStorage(r,'TANKS','2039') = 59167;
CapitalCostStorage(r,'TANKS','2040') = 58000;
CapitalCostStorage(r,'TANKS','2041') = 56833;
CapitalCostStorage(r,'TANKS','2042') = 55667;
CapitalCostStorage(r,'TANKS','2043') = 54500;
CapitalCostStorage(r,'TANKS','2044') = 53417;
CapitalCostStorage(r,'TANKS','2045') = 52250;
CapitalCostStorage(r,'TANKS','2046') = 51083;
CapitalCostStorage(r,'TANKS','2047') = 49917;
CapitalCostStorage(r,'TANKS','2048') = 48833;
CapitalCostStorage(r,'TANKS','2049') = 47667;
CapitalCostStorage(r,'TANKS','2050') = 46500;

TotalAnnualMaxStorageCapacityInvestment(r,'TANKS',y)$(y.val > 2030) = 1;  # Unit: PJ


* Monthly self-discharge rate (2%)
scalar UHS_monthly_discharge / 0.01 /;

* Per-time-slice self-discharge rate
loop(l,
    SelfDischargeRate('UHS', l) = 
        1 - (1 - UHS_monthly_discharge) ** (12 * YearSplit(l,'2024'));
);

* Seasonal aggregated self-discharge rate


SeasonSelfDischargeRate('UHS', '1') = 1 - (1 - SelfDischargeRate('UHS','WD')) 
                                               * (1 - SelfDischargeRate('UHS','WN'));

SeasonSelfDischargeRate('UHS', '2') = 1 - (1 - SelfDischargeRate('UHS','ID')) 
                                               * (1 - SelfDischargeRate('UHS','IN'));

SeasonSelfDischargeRate('UHS', '3') = 1 - (1 - SelfDischargeRate('UHS','SD')) 
                                               * (1 - SelfDischargeRate('UHS','SN'));


* Monthly self-discharge rate (2%)
scalar TANKS_monthly_discharge / 0.005 /;

* Per-time-slice self-discharge rate
loop(l,
    SelfDischargeRate('TANKS', l) = 
        1 - (1 - TANKS_monthly_discharge) ** (12 * YearSplit(l,'2024'));
);

* Seasonal aggregated self-discharge rate

SeasonSelfDischargeRate('TANKS', '1') = 1 - (1 - SelfDischargeRate('TANKS','WD')) 
                                               * (1 - SelfDischargeRate('TANKS','WN'));

SeasonSelfDischargeRate('TANKS', '2') = 1 - (1 - SelfDischargeRate('TANKS','ID')) 
                                               * (1 - SelfDischargeRate('TANKS','IN'));

SeasonSelfDischargeRate('TANKS', '3') = 1 - (1 - SelfDischargeRate('TANKS','SD')) 
                                               * (1 - SelfDischargeRate('TANKS','SN'));




$elseif.ph %phase%=='popol'

* --- Electrolyzers: only ELC in, storage out ---
InputActivityRatio(r,'HEL_UHS','ELC','1',y) = 1/0.68;
TechnologyToStorage(r,'1','HEL_UHS','UHS') = 1;

InputActivityRatio(r,'HEL_TANKS','ELC','1',y) = 1/0.68;
TechnologyToStorage(r,'1','HEL_TANKS','TANKS') = 1;

* --- SMR: GAS2 in, H2 out → storage ---
InputActivityRatio(r,'SMR_UHS','GAS_SMR','1',y) = 1/0.78;
TechnologyToStorage(r,'1','SMR_UHS','UHS') = 1;

InputActivityRatio(r,'SMR_TANKS','GAS_SMR','1',y) = 1/0.78;
TechnologyToStorage(r,'1','SMR_TANKS','TANKS') = 1;

* --- FC: H2 from storage, ELC out ---
OutputActivityRatio(r,'FC_UHS','ELC','2',y) = 0.6;
OutputActivityRatio(r,'FC_UHS','ELC_ACC_H2','2',y) = 0.6;   
TechnologyFromStorage(r,'2','FC_UHS','UHS') = 1;

OutputActivityRatio(r,'FC_TANKS','ELC','2',y) = 0.6;
OutputActivityRatio(r,'FC_TANKS','ELC_ACC_H2','2',y) = 0.6;
TechnologyFromStorage(r,'2','FC_TANKS','TANKS') = 1;

* --- GRID_H2: H2 from storage, H2_TH out ---
OutputActivityRatio(r,'GRID_H2_UHS','H2_TH','2',y) = 0.98;
TechnologyFromStorage(r,'2','GRID_H2_UHS','UHS') = 1;

OutputActivityRatio(r,'GRID_H2_TANKS','H2_TH','2',y) = 0.98;
TechnologyFromStorage(r,'2','GRID_H2_TANKS','TANKS') = 1;

* --- Industrial H2 Heating ---
InputActivityRatio(r,'IHH','H2_TH','1',y) = 1.11;
OutputActivityRatio(r,'IHH','IH','1',y) = 1;
OutputActivityRatio(r,'IHH','IH_ACC_H2','1',y) = 1;

$endif.ph
