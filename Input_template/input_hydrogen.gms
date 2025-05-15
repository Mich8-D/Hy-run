$set phase %1

# ------------------------------------------------
$ifthen.ph %phase%=='sets'

# Define hydrogen-related technologies and storage
set     STORAGE / UHS, TANKS /;

SET TECHNOLOGY /
    HEL          "Hydrogen Electrolyzers",
    SMR_CCS      "Steam Methane Reforming + CCS",
    IHH          "Industrial Heating - Hydrogen",
    GRID_H2      "Hydrogen Grid",
    UHS_CHARGE   "Underground Hydrogen Storage Charge", 
    TANKS_CHARGE "Hydrogen Tanks Discharge", 
    FC           "Fuel Cells" /;

set FUEL / 
    H2,      "Hydrogen",
    H2_TH    "Hydrogen Thermal Usages" /;

set hydrogen_tech(TECHNOLOGY) / HEL, SMR_CCS, IHH, GRID_H2, FC /;
set storage_plants(TECHNOLOGY) / UHS_CHARGE, TANKS_CHARGE /;
set hydrogen_production_tech(TECHNOLOGY) / HEL, SMR_CCS /;
set hydrogen_consumption_tech(TECHNOLOGY) / IHH, FC /;
set hydrogen_storages(STORAGE) / UHS , TANKS /;
set modular_storages(STORAGE) / UHS /;

# ------------------------------------------------
$elseif.ph %phase%=='data'

#------------------------------------------------------------------------	
# Parameters - Demands       
#------------------------------------------------------------------------
# we are going to impose in some of the scenarios the hydrogen demand for industrial heating,
# accordingliy to Germany development goals

#SpecifiedAnnualDemand("GERMANY","H2_TH","2050") = 0; # Unit: PJ

#------------------------------------------------------------
# Technical and economic parameters for hydrogen production tech
# Source: Hydrogen Inputs for OSeMOSYS and cost assessment sheets
#------------------------------------------------------------

#----------H2 PRODUCTION TECHNOLOGIES-------------------
###### WATCH OUT! The capacity factor for conversion technologies should be defined over the capacity!!!!!!
# Hydrogen Electrolyzers (HEL)
AvailabilityFactor(r,'HEL',y) = 0.9;
OperationalLife(r,'HEL') = 10;

# CapitalCost for Electrolyzers (HEL) based on IRENA/IEA data in €/kW
# Source: IEA Net Zero 2050, IRENA Hydrogen 2022

CapitalCost(r,'HEL','2024') = 1200;
CapitalCost(r,'HEL','2025') = 1150;
CapitalCost(r,'HEL','2026') = 1100;
CapitalCost(r,'HEL','2027') = 1050;
CapitalCost(r,'HEL','2028') = 1000;
CapitalCost(r,'HEL','2029') = 950;
CapitalCost(r,'HEL','2030') = 900;
CapitalCost(r,'HEL','2031') = 875;
CapitalCost(r,'HEL','2032') = 850;
CapitalCost(r,'HEL','2033') = 825;
CapitalCost(r,'HEL','2034') = 800;
CapitalCost(r,'HEL','2035') = 775;
CapitalCost(r,'HEL','2036') = 750;
CapitalCost(r,'HEL','2037') = 725;
CapitalCost(r,'HEL','2038') = 700;
CapitalCost(r,'HEL','2039') = 675;
CapitalCost(r,'HEL','2040') = 650;
CapitalCost(r,'HEL','2041') = 625;
CapitalCost(r,'HEL','2042') = 600;
CapitalCost(r,'HEL','2043') = 575;
CapitalCost(r,'HEL','2044') = 550;
CapitalCost(r,'HEL','2045') = 525;
CapitalCost(r,'HEL','2046') = 500;
CapitalCost(r,'HEL','2047') = 475;
CapitalCost(r,'HEL','2048') = 450;
CapitalCost(r,'HEL','2049') = 425;
CapitalCost(r,'HEL','2050') = 400;
  
# Units: VariableCost = €/GJ, FixedCost = €/kW/year
VariableCost(r,'HEL',m,y) = 0.5;
FixedCost(r,'HEL',y) = 0.03 * CapitalCost(r,'HEL',y);

# Steam Methane Reforming with CCS (SMR_CCS)
AvailabilityFactor(r,'SMR_CCS',y) = 0.9;
OperationalLife(r,'SMR_CCS') = 25;

# CapitalCost for SMR + CCS based on IEA/IRENA sources (€/kW)

CapitalCost(r,'SMR_CCS','2024') = 1600;
CapitalCost(r,'SMR_CCS','2025') = 1570;
CapitalCost(r,'SMR_CCS','2026') = 1540;
CapitalCost(r,'SMR_CCS','2027') = 1510;
CapitalCost(r,'SMR_CCS','2028') = 1480;
CapitalCost(r,'SMR_CCS','2029') = 1450;
CapitalCost(r,'SMR_CCS','2030') = 1420;
CapitalCost(r,'SMR_CCS','2031') = 1395;
CapitalCost(r,'SMR_CCS','2032') = 1370;
CapitalCost(r,'SMR_CCS','2033') = 1345;
CapitalCost(r,'SMR_CCS','2034') = 1320;
CapitalCost(r,'SMR_CCS','2035') = 1295;
CapitalCost(r,'SMR_CCS','2036') = 1270;
CapitalCost(r,'SMR_CCS','2037') = 1245;
CapitalCost(r,'SMR_CCS','2038') = 1220;
CapitalCost(r,'SMR_CCS','2039') = 1195;
CapitalCost(r,'SMR_CCS','2040') = 1170;
CapitalCost(r,'SMR_CCS','2041') = 1145;
CapitalCost(r,'SMR_CCS','2042') = 1120;
CapitalCost(r,'SMR_CCS','2043') = 1095;
CapitalCost(r,'SMR_CCS','2044') = 1070;
CapitalCost(r,'SMR_CCS','2045') = 1045;
CapitalCost(r,'SMR_CCS','2046') = 1020;
CapitalCost(r,'SMR_CCS','2047') = 1000;
CapitalCost(r,'SMR_CCS','2048') = 1000;
CapitalCost(r,'SMR_CCS','2049') = 1000;
CapitalCost(r,'SMR_CCS','2050') = 1000;

# Units: VariableCost = €/GJ, FixedCost = €/kW/year 
VariableCost(r,'SMR_CCS',m,y) = 12;
FixedCost(r,'SMR_CCS',y) = 0.03 * CapitalCost(r,'SMR_CCS',y);

# EmissionActivityRatio for SMR + CCS
# Unit: Mt CO₂ per PJ of hydrogen produced
# Assumes 75 kg CO₂ captured per GJ H₂ output = 0.075 Mt/PJ
# Based on 90% capture rate from ~83 kg CO₂/GJ emission baseline (IEA, IPCC)

EmissionActivityRatio(r,'SMR_CCS','CO2','1',y) = -0.075;

#--------------------H2 CONSUMPTION TECHNOLOGIES-------------------

# Industrial Heating - Hydrogen (IHH)
# Assumptions:
# - Availability: 90% (typical for industrial systems)
# - Operational life: 15 years
# - CAPEX: starts at 1200 €/kW in 2024, declines to 800 €/kW by 2044
# - Variable O&M: 0.002 €/kWh = 0.56 €/GJ (excludes fuel cost)
# - Fixed O&M: ~1.7% of CAPEX

AvailabilityFactor(r,'IHH',y) = 0.9;
OperationalLife(r,'IHH') = 15;

# Capital Cost trajectory (€/kW)
CapitalCost(r,'IHH','2024') = 1200;
CapitalCost(r,'IHH','2025') = 1180;
CapitalCost(r,'IHH','2026') = 1160;
CapitalCost(r,'IHH','2027') = 1140;
CapitalCost(r,'IHH','2028') = 1120;
CapitalCost(r,'IHH','2029') = 1100;
CapitalCost(r,'IHH','2030') = 1080;
CapitalCost(r,'IHH','2031') = 1060;
CapitalCost(r,'IHH','2032') = 1040;
CapitalCost(r,'IHH','2033') = 1020;
CapitalCost(r,'IHH','2034') = 1000;
CapitalCost(r,'IHH','2035') = 980;
CapitalCost(r,'IHH','2036') = 960;
CapitalCost(r,'IHH','2037') = 940;
CapitalCost(r,'IHH','2038') = 920;
CapitalCost(r,'IHH','2039') = 900;
CapitalCost(r,'IHH','2040') = 880;
CapitalCost(r,'IHH','2041') = 860;
CapitalCost(r,'IHH','2042') = 840;
CapitalCost(r,'IHH','2043') = 820;
CapitalCost(r,'IHH','2044') = 800;
CapitalCost(r,'IHH','2045') = 800;
CapitalCost(r,'IHH','2046') = 800;
CapitalCost(r,'IHH','2047') = 800;
CapitalCost(r,'IHH','2048') = 800;
CapitalCost(r,'IHH','2049') = 800;
CapitalCost(r,'IHH','2050') = 800;

# O&M Costs
VariableCost(r,'IHH',m,y) = 0.56;                      # €/GJ (minor O&M, excludes H₂ cost)
FixedCost(r,'IHH',y) = 0.017 * CapitalCost(r,'IHH',y); #€/kW/year 


# Fuel Cells (FC)
# Assumptions:
# - Availability: 90%
# - Operational life: 10 years
# - CAPEX: €1600/kW in 2024, down to €800/kW by 2050
# - Variable O&M: €2/GJ (stack maintenance, balance-of-plant)
# - Fixed O&M: 2.5% of CAPEX annually

AvailabilityFactor(r,'FC',y) = 0.9;
OperationalLife(r,'FC') = 10;

# Capital cost trajectory (€/kW)
CapitalCost(r,'FC','2024') = 1600;
CapitalCost(r,'FC','2025') = 1550;
CapitalCost(r,'FC','2026') = 1500;
CapitalCost(r,'FC','2027') = 1450;
CapitalCost(r,'FC','2028') = 1400;
CapitalCost(r,'FC','2029') = 1350;
CapitalCost(r,'FC','2030') = 1300;
CapitalCost(r,'FC','2031') = 1250;
CapitalCost(r,'FC','2032') = 1200;
CapitalCost(r,'FC','2033') = 1150;
CapitalCost(r,'FC','2034') = 1100;
CapitalCost(r,'FC','2035') = 1050;
CapitalCost(r,'FC','2036') = 1000;
CapitalCost(r,'FC','2037') = 975;
CapitalCost(r,'FC','2038') = 950;
CapitalCost(r,'FC','2039') = 925;
CapitalCost(r,'FC','2040') = 900;
CapitalCost(r,'FC','2041') = 875;
CapitalCost(r,'FC','2042') = 850;
CapitalCost(r,'FC','2043') = 825;
CapitalCost(r,'FC','2044') = 800;
CapitalCost(r,'FC','2045') = 800;
CapitalCost(r,'FC','2046') = 800;
CapitalCost(r,'FC','2047') = 800;
CapitalCost(r,'FC','2048') = 800;
CapitalCost(r,'FC','2049') = 800;
CapitalCost(r,'FC','2050') = 800;

# O&M Costs
VariableCost(r,'FC',m,y) = 2;                        # €/GJ
FixedCost(r,'FC',y) = 0.025 * CapitalCost(r,'FC',y); # 2.5% of CAPEX


#--------------------HYDROGEN GRID (PIPELINES): GRID_H2-------------------
# Represents pipeline & distribution network
# Assumptions:
# - 400 km pipeline, 2 GW capacity, 40-year life
# - Conservative early CAPEX declines to 48 €/kW by 2050
# - Variable O&M: 0.3 €/GJ
# - Fixed O&M: 3% of CAPEX

AvailabilityFactor(r,'GRID_H2',y) = 0.9;
OperationalLife(r,'GRID_H2') = 40;

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

VariableCost(r,'GRID_H2',m,y) = 0.3;                         # €/GJ
FixedCost(r,'GRID_H2',y) = 0.03 * CapitalCost(r,'GRID_H2',y); # €/kW/year


#--------------------H2 STORAGE TECHNOLOGIES-------------------

# Underground Hydrogen Storage: Charging Technology
# Models the energy and cost of compressing H₂ into underground storage

AvailabilityFactor(r,'UHS_CHARGE',y) = 0.9;
OperationalLife(r,'UHS_CHARGE') = 30;

# CAPEX trajectory for compression system (€/kW)
CapitalCost(r,'UHS_CHARGE','2024') = 300;
CapitalCost(r,'UHS_CHARGE','2025') = 290;
CapitalCost(r,'UHS_CHARGE','2026') = 280;
CapitalCost(r,'UHS_CHARGE','2027') = 270;
CapitalCost(r,'UHS_CHARGE','2028') = 260;
CapitalCost(r,'UHS_CHARGE','2029') = 250;
CapitalCost(r,'UHS_CHARGE','2030') = 240;
CapitalCost(r,'UHS_CHARGE','2031') = 230;
CapitalCost(r,'UHS_CHARGE','2032') = 220;
CapitalCost(r,'UHS_CHARGE','2033') = 210;
CapitalCost(r,'UHS_CHARGE','2034') = 200;
CapitalCost(r,'UHS_CHARGE','2035') = 190;
CapitalCost(r,'UHS_CHARGE','2036') = 180;
CapitalCost(r,'UHS_CHARGE','2037') = 170;
CapitalCost(r,'UHS_CHARGE','2038') = 160;
CapitalCost(r,'UHS_CHARGE','2039') = 155;
CapitalCost(r,'UHS_CHARGE','2040') = 150;
CapitalCost(r,'UHS_CHARGE','2041') = 150;
CapitalCost(r,'UHS_CHARGE','2042') = 150;
CapitalCost(r,'UHS_CHARGE','2043') = 150;
CapitalCost(r,'UHS_CHARGE','2044') = 150;
CapitalCost(r,'UHS_CHARGE','2045') = 150;
CapitalCost(r,'UHS_CHARGE','2046') = 150;
CapitalCost(r,'UHS_CHARGE','2047') = 150;
CapitalCost(r,'UHS_CHARGE','2048') = 150;
CapitalCost(r,'UHS_CHARGE','2049') = 150;
CapitalCost(r,'UHS_CHARGE','2050') = 150;

# O&M Costs
VariableCost(r,'UHS_CHARGE',m,y) = 1;                               # €/GJ (compression energy)
FixedCost(r,'UHS_CHARGE',y) = 0.03 * CapitalCost(r,'UHS_CHARGE',y); # €/kW/year


# Hydrogen Storage Interface: Charging into Above-Ground Tanks (TANKS_CHARGE)
# Models compression and injection costs for tank storage

AvailabilityFactor(r,'TANKS_CHARGE',y) = 0.9;
OperationalLife(r,'TANKS_CHARGE') = 20;

# CAPEX trajectory for tank-side compression system (€/kW)
CapitalCost(r,'TANKS_CHARGE','2024') = 250;
CapitalCost(r,'TANKS_CHARGE','2025') = 240;
CapitalCost(r,'TANKS_CHARGE','2026') = 230;
CapitalCost(r,'TANKS_CHARGE','2027') = 220;
CapitalCost(r,'TANKS_CHARGE','2028') = 210;
CapitalCost(r,'TANKS_CHARGE','2029') = 200;
CapitalCost(r,'TANKS_CHARGE','2030') = 190;
CapitalCost(r,'TANKS_CHARGE','2031') = 185;
CapitalCost(r,'TANKS_CHARGE','2032') = 180;
CapitalCost(r,'TANKS_CHARGE','2033') = 175;
CapitalCost(r,'TANKS_CHARGE','2034') = 170;
CapitalCost(r,'TANKS_CHARGE','2035') = 165;
CapitalCost(r,'TANKS_CHARGE','2036') = 160;
CapitalCost(r,'TANKS_CHARGE','2037') = 155;
CapitalCost(r,'TANKS_CHARGE','2038') = 150;
CapitalCost(r,'TANKS_CHARGE','2039') = 150;
CapitalCost(r,'TANKS_CHARGE','2040') = 150;
CapitalCost(r,'TANKS_CHARGE','2041') = 150;
CapitalCost(r,'TANKS_CHARGE','2042') = 150;
CapitalCost(r,'TANKS_CHARGE','2043') = 150;
CapitalCost(r,'TANKS_CHARGE','2044') = 150;
CapitalCost(r,'TANKS_CHARGE','2045') = 150;
CapitalCost(r,'TANKS_CHARGE','2046') = 150;
CapitalCost(r,'TANKS_CHARGE','2047') = 150;
CapitalCost(r,'TANKS_CHARGE','2048') = 150;
CapitalCost(r,'TANKS_CHARGE','2049') = 150;
CapitalCost(r,'TANKS_CHARGE','2050') = 150;

# O&M Costs
VariableCost(r,'TANKS_CHARGE',m,y) = 0.8;                           # €/GJ
FixedCost(r,'TANKS_CHARGE',y) = 0.03 * CapitalCost(r,'TANKS_CHARGE',y);  # €/kW/year


# UHS storage Technology
ResidualStorageCapacity(r,'UHS',y) = 0;  # Unit: PJ (explicitly zero)
StorageLevelStart(r,'UHS') = 0;          # Unit: PJ (explicitly zero)
StorageMaxChargeRate(r,'UHS') = 1;       # Charge/discharge rates set to 1 since UHS_CHARGE tech models actual flow constraints
StorageMaxDischargeRate(r,'UHS') = 1;
MinStorageCharge(r,'UHS',y) = 0.1;
OperationalLifeStorage(r,'UHS') = 30;

# Source: H2 Storage Cost Assessment file, aligned with IEA/IRENA/Hydrogen Council reports
# Units: €/PJ of working gas capacity
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

StorageUnitSize(r, 'UHS', y) = 200;  # Unit: PJ


# Hydrogen Tanks (TANKS)
ResidualStorageCapacity(r,'TANKS',y) = 0;  # Unit: PJ (explicitly zero)
StorageLevelStart(r,'TANKS') = 0;          # Unit: PJ (explicitly zero)
StorageMaxChargeRate(r,'TANKS') = 1;
StorageMaxDischargeRate(r,'TANKS') = 1;
MinStorageCharge(r,'TANKS',y) = 0.1;
OperationalLifeStorage(r,'TANKS') = 20; 

# CapitalCostStorage defined yearly in €/PJ
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


# ------------------------------------------------
$elseif.ph %phase%=='popol'

#------------------------------------------------------------
# Fuel flows and storage mappings for hydrogen technologies
#------------------------------------------------------------

# HEL: Electricity to Hydrogen
InputActivityRatio(r,'HEL','ELC2','1',y) = 1;
OutputActivityRatio(r,'HEL','H2','1',y) = 0.68;   # ~68% efficiency

# SMR_CCS: Gas to Hydrogen
InputActivityRatio(r,'SMR_CCS','GAS2','1',y) = 1;
OutputActivityRatio(r,'SMR_CCS','H2','1',y) = 0.78;   # ~78% conversion

# Storage flows for UHS
InputActivityRatio(r,'UHS_CHARGE','H2','1',y) = 1;
OutputActivityRatio(r,'UHS_CHARGE','H2','2',y) = 1;
TechnologyToStorage(r,'1','UHS_CHARGE','UHS') = 1;
TechnologyFromStorage(r,'2','UHS_CHARGE','UHS') = 0.9;

# Storage flows for TANKS
InputActivityRatio(r,'TANKS_CHARGE','H2','1',y) = 1;
OutputActivityRatio(r,'TANKS_CHARGE','H2','2',y) = 1;
TechnologyToStorage(r,'1','TANKS_CHARGE','TANKS') = 1;
TechnologyFromStorage(r,'2','TANKS_CHARGE','TANKS') = 0.9;

# Industrial Heating with Hydrogen
InputActivityRatio(r,'IHH','H2_TH','1',y) = 1.11;   # ~90% efficiency
OutputActivityRatio(r,'IHH','IH','1',y) = 1;

# Hydrogen Grid (GRID_H2)
InputActivityRatio(r,'GRID_H2','H2','1',y) = 1;
OutputActivityRatio(r,'GRID_H2','H2_TH','1',y) = 1;   # Redistributes H2 without loss

$endif.ph

