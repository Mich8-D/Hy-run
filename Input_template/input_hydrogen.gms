$set phase %1

** ------------------------------------------------
$ifthen.ph %phase%=='sets'

* Define hydrogen-related technologies and storage
set     STORAGE / UHS, TANKS /;

SET TECHNOLOGY /
    HEL          "Hydrogen Electrolyzers",
    SMR_CCS      "Steam Methane Reforming + CCS",
    IHH          "Industrial Heating - Hydrogen",
    GRID_H2      "Hydrogen Grid",
    UHS_CHARGE   "Underground Hydrogen Storage Charge", #just accounting technology/compression stage(?)
    TANKS_CHARGE "Hydrogen Tanks Discharge", #just accounting technology/compression stage(?)
    FC           "Fuel Cells" /;

set FUEL / 
    H2,      "Hydrogen",
    H2_TH    "Hydrogen Thermal Usages" /;

set hydrogen_tech(TECHNOLOGY) / HEL, SMR_CCS, IHH, GRID_H2, FC /;
set storage_plants(TECHNOLOGY) / UHS_CHARGE, TANKS_CHARGE /;
set hydrogen_production_tech(TECHNOLOGY) / HEL, SMR_CCS /;
set hydrogen_consumption_tech(TECHNOLOGY) / IHH, FC /;
set hydrogen_storages(STORAGE) / UHS , TANKS /;

** ------------------------------------------------
$elseif.ph %phase%=='data'

*------------------------------------------------------------
* Technical and economic parameters for hydrogen production tech
* Source: Hydrogen Inputs for OSeMOSYS and cost assessment sheets
*------------------------------------------------------------

*----------H2 PRODUCTION TECHNOLOGIES-------------------

###### WATCH OUT! The capacity factor for conversion technologies should be defined over the capacity!!!!!!
# Hydrogen Electrolyzers (HEL)
AvailabilityFactor(r,'HEL',y) = 0.9;
OperationalLife(r,'HEL') = 10;
* CapitalCost defined yearly below from 'H2 Production Cost Assessment' (Green H2 €/kg) 
CapitalCost(r,'HEL','2024') = 4960000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2025') = 4810000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2026') = 4650000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2027') = 4490000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2028') = 4330000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2029') = 4170000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2030') = 4010000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2031') = 3850000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2032') = 3690000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2033') = 3530000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2034') = 3370000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2035') = 3210000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2036') = 3050000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2037') = 2890000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2038') = 2730000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2039') = 2570000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2040') = 2410000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2041') = 2250000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2042') = 2090000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2043') = 1930000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2044') = 1770000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2045') = 1610000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2046') = 1450000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2047') = 1290000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2048') = 1130000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2049') = 970000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'HEL','2050') = 810000;  # Converted from €/kg to €/kW (×1000)
VariableCost(r,'HEL',m,y) = 1e-5;
FixedCost(r,'HEL',y) = 0;

# Steam Methane Reforming with CCS (SMR_CCS)
AvailabilityFactor(r,'SMR_CCS',y) = 0.9;
OperationalLife(r,'SMR_CCS') = 10;
* CapitalCost defined yearly below from 'H2 Production Cost Assessment' (Blue H2 €/kg)
CapitalCost(r,'SMR_CCS','2024') = 2760000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2025') = 2720000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2026') = 2690000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2027') = 2650000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2028') = 2620000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2029') = 2580000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2030') = 2550000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2031') = 2510000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2032') = 2480000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2033') = 2440000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2034') = 2410000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2035') = 2370000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2036') = 2340000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2037') = 2300000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2038') = 2270000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2039') = 2230000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2040') = 2200000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2041') = 2160000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2042') = 2130000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2043') = 2090000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2044') = 2060000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2045') = 2020000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2046') = 1990000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2047') = 1950000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2048') = 1920000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2049') = 1880000;  # Converted from €/kg to €/kW (×1000)
CapitalCost(r,'SMR_CCS','2050') = 1850000;  # Converted from €/kg to €/kW (×1000) #converted from USD
VariableCost(r,'SMR_CCS',m,y) = 1e-5;
FixedCost(r,'SMR_CCS',y) = 0;
EmissionActivityRatio(r,'SMR_CCS','CO2','1',y) = - 0.075; # here you have to put how many kg of CO2 you are captured for each activity unit(energy) of H2 produced

*--------------------H2 CONSUMPTION TECHNOLOGIES-------------------

# Industrial Heating - Hydrogen (IHH)
AvailabilityFactor(r,'IHH',y) = 0.9;
OperationalLife(r,'IHH') = 15;  # Assumed lifetime for industrial heating
CapitalCost(r,'IHH',y) = 1000;   # Rough estimate based on heating techs
VariableCost(r,'IHH',m,y) = 1e-5;
FixedCost(r,'IHH',y) = 0;

# Fuel Cells (FC) #### dummy data
AvailabilityFactor(r,'FC',y) = 0.9;
OperationalLife(r,'FC') = 10;  
CapitalCost(r,'FC',y) = 1000; 
VariableCost(r,'FC',m,y) = 1e-5;
FixedCost(r,'FC',y) = 0;  

# Hydrogen Grid (GRID_H2) represents hydrogen pipelines and distribution network
AvailabilityFactor(r,'GRID_H2',y) = 0.9;
OperationalLife(r,'GRID_H2') = 40;
* CapitalCost defined yearly from 'Cost Assessment for H2' sheet
* Original pipeline cost in €/km converted to €/kW using the following assumptions:
* - Average pipeline length = 400 km
* - Pipeline capacity = 2 GW
* - Lifetime = 40 years
* Conversion formula: (€/km * 400 km) / 2,000,000 kW
CapitalCost(r,'GRID_H2','2024') = 152;
CapitalCost(r,'GRID_H2','2025') = 148;
CapitalCost(r,'GRID_H2','2026') = 144;
CapitalCost(r,'GRID_H2','2027') = 140;
CapitalCost(r,'GRID_H2','2028') = 136;
CapitalCost(r,'GRID_H2','2029') = 132;
CapitalCost(r,'GRID_H2','2030') = 128;
CapitalCost(r,'GRID_H2','2031') = 124;
CapitalCost(r,'GRID_H2','2032') = 120;
CapitalCost(r,'GRID_H2','2033') = 116;
CapitalCost(r,'GRID_H2','2034') = 112;
CapitalCost(r,'GRID_H2','2035') = 108;
CapitalCost(r,'GRID_H2','2036') = 104;
CapitalCost(r,'GRID_H2','2037') = 100;
CapitalCost(r,'GRID_H2','2038') = 96;
CapitalCost(r,'GRID_H2','2039') = 92;
CapitalCost(r,'GRID_H2','2040') = 88;
CapitalCost(r,'GRID_H2','2041') = 84;
CapitalCost(r,'GRID_H2','2042') = 80;
CapitalCost(r,'GRID_H2','2043') = 76;
CapitalCost(r,'GRID_H2','2044') = 72;
CapitalCost(r,'GRID_H2','2045') = 68;
CapitalCost(r,'GRID_H2','2046') = 64;
CapitalCost(r,'GRID_H2','2047') = 60;
CapitalCost(r,'GRID_H2','2048') = 56;
CapitalCost(r,'GRID_H2','2049') = 52;
CapitalCost(r,'GRID_H2','2050') = 48;  # Conservative grid infrastructure cost (€/kW)
VariableCost(r,'GRID_H2',m,y) = 1e-5;
FixedCost(r,'GRID_H2',y) = 0;

*--------------------H2 STORAGE TECHNOLOGIES-------------------

# UHS charge technology #dummy data
AvailabilityFactor(r,'UHS_CHARGE',y) = 0.9; 
OperationalLife(r,'UHS_CHARGE') = 30; 
CapitalCost(r,'UHS_CHARGE',y) = 0; # Assumed to be negligible
VariableCost(r,'UHS_CHARGE',m,y) = 1e-5;
FixedCost(r,'UHS_CHARGE',y) = 0;

# TANKS charge technology #dummy data
AvailabilityFactor(r,'TANKS_CHARGE',y) = 0.9;   
OperationalLife(r,'TANKS_CHARGE') = 20;
CapitalCost(r,'TANKS_CHARGE',y) = 0; # Assumed to be negligible
VariableCost(r,'TANKS_CHARGE',m,y) = 1e-5;
FixedCost(r,'TANKS_CHARGE',y) = 0;

# UHS storage Technology
ResidualStorageCapacity(r,'UHS',y) = 0;  # Unit: PJ (explicitly zero)
StorageLevelStart(r,'UHS') = 0;  # Unit: PJ (explicitly zero)
StorageMaxChargeRate(r, 'UHS') = 0.5;
StorageMaxDischargeRate(r, 'UHS') = 0.5;
MinStorageCharge(r,'UHS',y) = 0.1;
OperationalLifeStorage(r,'UHS') = 30;
* CapitalCost defined yearly below from 'H2 Storage Cost Assessment' (€/kg * 1000)
CapitalCostStorage(r,'UHS','2024') = 2100;
CapitalCostStorage(r,'UHS','2025') = 2060;
CapitalCostStorage(r,'UHS','2026') = 2030;
CapitalCostStorage(r,'UHS','2027') = 1990;
CapitalCostStorage(r,'UHS','2028') = 1950;
CapitalCostStorage(r,'UHS','2029') = 1910;
CapitalCostStorage(r,'UHS','2030') = 1880;
CapitalCostStorage(r,'UHS','2031') = 1840;
CapitalCostStorage(r,'UHS','2032') = 1800;
CapitalCostStorage(r,'UHS','2033') = 1760;
CapitalCostStorage(r,'UHS','2034') = 1730;
CapitalCostStorage(r,'UHS','2035') = 1690;
CapitalCostStorage(r,'UHS','2036') = 1650;
CapitalCostStorage(r,'UHS','2037') = 1610;
CapitalCostStorage(r,'UHS','2038') = 1580;
CapitalCostStorage(r,'UHS','2039') = 1540;
CapitalCostStorage(r,'UHS','2040') = 1500;
CapitalCostStorage(r,'UHS','2041') = 1460;
CapitalCostStorage(r,'UHS','2042') = 1430;
CapitalCostStorage(r,'UHS','2043') = 1390;
CapitalCostStorage(r,'UHS','2044') = 1350;
CapitalCostStorage(r,'UHS','2045') = 1310;
CapitalCostStorage(r,'UHS','2046') = 1280;
CapitalCostStorage(r,'UHS','2047') = 1240;
CapitalCostStorage(r,'UHS','2048') = 1200;
CapitalCostStorage(r,'UHS','2049') = 1160;
CapitalCostStorage(r,'UHS','2050') = 1130;

# Hydrogen Tanks (TANKS)
ResidualStorageCapacity(r,'TANKS',y) = 0;  # Unit: PJ (explicitly zero)
StorageLevelStart(r,'TANKS') = 0;  # Unit: PJ (explicitly zero)
StorageMaxChargeRate(r, 'TANKS') = 0.5;
StorageMaxDischargeRate(r, 'TANKS') = 0.5;
MinStorageCharge(r,'TANKS',y) = 0.1;
OperationalLifeStorage(r,'TANKS') = 20; # Assumed
* CapitalCostStorage defined yearly below from 'H2 Storage Cost Assessment' (Compressed Gas €/kg * 1000)
CapitalCostStorage(r,'TANKS','2024') = 9160;
CapitalCostStorage(r,'TANKS','2025') = 9020;
CapitalCostStorage(r,'TANKS','2026') = 8890;
CapitalCostStorage(r,'TANKS','2027') = 8750;
CapitalCostStorage(r,'TANKS','2028') = 8610;
CapitalCostStorage(r,'TANKS','2029') = 8470;
CapitalCostStorage(r,'TANKS','2030') = 8340;
CapitalCostStorage(r,'TANKS','2031') = 8200;
CapitalCostStorage(r,'TANKS','2032') = 8060;
CapitalCostStorage(r,'TANKS','2033') = 7920;
CapitalCostStorage(r,'TANKS','2034') = 7790;
CapitalCostStorage(r,'TANKS','2035') = 7650;
CapitalCostStorage(r,'TANKS','2036') = 7510;
CapitalCostStorage(r,'TANKS','2037') = 7370;
CapitalCostStorage(r,'TANKS','2038') = 7240;
CapitalCostStorage(r,'TANKS','2039') = 7100;
CapitalCostStorage(r,'TANKS','2040') = 6960;
CapitalCostStorage(r,'TANKS','2041') = 6820;
CapitalCostStorage(r,'TANKS','2042') = 6690;
CapitalCostStorage(r,'TANKS','2043') = 6550;
CapitalCostStorage(r,'TANKS','2044') = 6410;
CapitalCostStorage(r,'TANKS','2045') = 6270;
CapitalCostStorage(r,'TANKS','2046') = 6140;
CapitalCostStorage(r,'TANKS','2047') = 6000;
CapitalCostStorage(r,'TANKS','2048') = 5860;
CapitalCostStorage(r,'TANKS','2049') = 5720;
CapitalCostStorage(r,'TANKS','2050') = 5590;


** ------------------------------------------------
$elseif.ph %phase%=='popol'

*------------------------------------------------------------
* Fuel flows and storage mappings for hydrogen technologies
*------------------------------------------------------------

# HEL: Electricity to Hydrogen
InputActivityRatio(r,'HEL','ELC2','1',y) = 1;   # IEA convention
OutputActivityRatio(r,'HEL','H2','1',y) = 1;   # IEA convention

# SMR_CCS: Gas to Hydrogen
InputActivityRatio(r,'SMR_CCS','GAS2','1',y) = 1;
OutputActivityRatio(r,'SMR_CCS','H2','1',y) = 1;

# Storage flows for UHS
InputActivityRatio(r,'UHS_CHARGE','H2','1',y) = 1;   # Charge phase
OutputActivityRatio(r,'UHS_CHARGE','H2','2',y) = 1;   # Discharge phase
TechnologyToStorage(r,'1','UHS_CHARGE','UHS') = 1;
TechnologyFromStorage(r,'2','UHS_CHARGE','UHS') = 0.9;

# Storage flows for TANKS
InputActivityRatio(r,'TANKS_CHARGE','H2','1',y) = 1;   # Charge phase
OutputActivityRatio(r,'TANKS_CHARGE','H2','2',y) = 1;   # Discharge phase
TechnologyToStorage(r,'1','TANKS_CHARGE','TANKS') = 1;
TechnologyFromStorage(r,'2','TANKS_CHARGE','TANKS') = 0.9;

# Industrial Heating with Hydrogen
InputActivityRatio(r,'IHH','H2_TH','1',y) = 1;   # Consumes hydrogen
OutputActivityRatio(r,'IHH','IH','1',y) = 1;   # Delivers industrial heating service

# Hydrogen Grid (GRID_H2)
InputActivityRatio(r,'GRID_H2','H2','1',y) = 1;
OutputActivityRatio(r,'GRID_H2','H2_TH','1',y) = 1;   # Assumes grid redistributes H2 without losses

# Note: Reversible tech 'REV_DEV' intentionally excluded

$endif.ph
