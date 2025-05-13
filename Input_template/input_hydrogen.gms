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

*------------------------------------------------------------------------	
* Parameters - Demands       
*------------------------------------------------------------------------
* we are going to impose in some of the scenarios the hydrogen demand for industrial heating,
* accordingliy to Germany development goals

SpecifiedAnnualDemand("GERMANY","H2_TH","2050") = 0; # Unit: PJ

*------------------------------------------------------------
* Technical and economic parameters for hydrogen production tech
* Source: Hydrogen Inputs for OSeMOSYS and cost assessment sheets
*------------------------------------------------------------

*----------H2 PRODUCTION TECHNOLOGIES-------------------
###### WATCH OUT! The capacity factor for conversion technologies should be defined over the capacity!!!!!!
# Hydrogen Electrolyzers (HEL)
AvailabilityFactor(r,'HEL',y) = 0.9;
OperationalLife(r,'HEL') = 10;
* CapitalCost defined yearly below from 'H2 Production Cost Assessment' (Green H2, Converted from €/kg to €/kW (×1000))
CapitalCost(r,'HEL','2024') = 4960;  
CapitalCost(r,'HEL','2025') = 4810;  
CapitalCost(r,'HEL','2026') = 4650;  
CapitalCost(r,'HEL','2027') = 4490;  
CapitalCost(r,'HEL','2028') = 4330;  
CapitalCost(r,'HEL','2029') = 4170;  
CapitalCost(r,'HEL','2030') = 4010;  
CapitalCost(r,'HEL','2031') = 3850;  
CapitalCost(r,'HEL','2032') = 3690;  
CapitalCost(r,'HEL','2033') = 3530;  
CapitalCost(r,'HEL','2034') = 3370;  
CapitalCost(r,'HEL','2035') = 3210;  
CapitalCost(r,'HEL','2036') = 3050;  
CapitalCost(r,'HEL','2037') = 2890;  
CapitalCost(r,'HEL','2038') = 2730;  
CapitalCost(r,'HEL','2039') = 2570;  
CapitalCost(r,'HEL','2040') = 2410;  
CapitalCost(r,'HEL','2041') = 2250;  
CapitalCost(r,'HEL','2042') = 2090;  
CapitalCost(r,'HEL','2043') = 1930;  
CapitalCost(r,'HEL','2044') = 1770;  
CapitalCost(r,'HEL','2045') = 1610;  
CapitalCost(r,'HEL','2046') = 1450;  
CapitalCost(r,'HEL','2047') = 1290;  
CapitalCost(r,'HEL','2048') = 1130;  
CapitalCost(r,'HEL','2049') = 970;  
CapitalCost(r,'HEL','2050') = 810;  
VariableCost(r,'HEL',m,y) = 1e-5;
FixedCost(r,'HEL',y) = 0;

# Steam Methane Reforming with CCS (SMR_CCS)
AvailabilityFactor(r,'SMR_CCS',y) = 0.9;
OperationalLife(r,'SMR_CCS') = 10;
* CapitalCost defined yearly below from 'H2 Production Cost Assessment' (Blue H2, Converted from €/kg to €/kW (×1000))
CapitalCost(r,'SMR_CCS','2024') = 2760;  
CapitalCost(r,'SMR_CCS','2025') = 2720;  
CapitalCost(r,'SMR_CCS','2026') = 2690;  
CapitalCost(r,'SMR_CCS','2027') = 2650;  
CapitalCost(r,'SMR_CCS','2028') = 2620;  
CapitalCost(r,'SMR_CCS','2029') = 2580;  
CapitalCost(r,'SMR_CCS','2030') = 2550;  
CapitalCost(r,'SMR_CCS','2031') = 2510;  
CapitalCost(r,'SMR_CCS','2032') = 2480;  
CapitalCost(r,'SMR_CCS','2033') = 2440;  
CapitalCost(r,'SMR_CCS','2034') = 2410;  
CapitalCost(r,'SMR_CCS','2035') = 2370;  
CapitalCost(r,'SMR_CCS','2036') = 2340;  
CapitalCost(r,'SMR_CCS','2037') = 2300;  
CapitalCost(r,'SMR_CCS','2038') = 2270;  
CapitalCost(r,'SMR_CCS','2039') = 2230;  
CapitalCost(r,'SMR_CCS','2040') = 2200;  
CapitalCost(r,'SMR_CCS','2041') = 2160;  
CapitalCost(r,'SMR_CCS','2042') = 2130;  
CapitalCost(r,'SMR_CCS','2043') = 2090;  
CapitalCost(r,'SMR_CCS','2044') = 2060;  
CapitalCost(r,'SMR_CCS','2045') = 2020;  
CapitalCost(r,'SMR_CCS','2046') = 1990;  
CapitalCost(r,'SMR_CCS','2047') = 1950;  
CapitalCost(r,'SMR_CCS','2048') = 1920;  
CapitalCost(r,'SMR_CCS','2049') = 1880;  
CapitalCost(r,'SMR_CCS','2050') = 1850;  
VariableCost(r,'SMR_CCS',m,y) = 1e-5;
FixedCost(r,'SMR_CCS',y) = 0;
EmissionActivityRatio(r,'SMR_CCS','CO2','1',y) = - 0.075; # Unit: kg CO₂ per PJ of H₂ produced (negative = captured)

*--------------------H2 CONSUMPTION TECHNOLOGIES-------------------

# Industrial Heating - Hydrogen (IHH)
AvailabilityFactor(r,'IHH',y) = 0.9;
OperationalLife(r,'IHH') = 15;  # Assumed lifetime for industrial heating
CapitalCost(r,'IHH',y) = 1000;  # Rough estimate based on heating techs
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
* Conversion formula: (€/km * 400 km) / 2,000,000 kW    # Conservative grid infrastructure cost (€/kW)
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
CapitalCost(r,'GRID_H2','2050') = 48;  
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

* CapitalCostStorage defined yearly below from 'H2 Storage Cost Assessment' in €/PJ
CapitalCostStorage(r,'UHS','2023') = 17833;
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


# Hydrogen Tanks (TANKS)
ResidualStorageCapacity(r,'TANKS',y) = 0;  # Unit: PJ (explicitly zero)
StorageLevelStart(r,'TANKS') = 0;  # Unit: PJ (explicitly zero)
StorageMaxChargeRate(r, 'TANKS') = 0.5;
StorageMaxDischargeRate(r, 'TANKS') = 0.5;
MinStorageCharge(r,'TANKS',y) = 0.1;
OperationalLifeStorage(r,'TANKS') = 20; # Assumed

* CapitalCostStorage defined yearly below from 'H2 Storage Cost Assessment' in €/PJ for TANKS
CapitalCostStorage(r,'TANKS','2023') = 77500;
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
