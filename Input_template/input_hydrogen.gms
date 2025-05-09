$set phase %1

** ------------------------------------------------
$ifthen.ph %phase%=='sets'

* Define hydrogen-related technologies and storage
set     STORAGE / HYDROGEN /;

SET TECHNOLOGY /
    HEL       "Hydrogen Electrolyzers",
    SMR_CCS   "Steam Methane Reforming + CCS",
    IHH       "Industrial Heating - Hydrogen",
    GRID_H2   "Hydrogen Grid",
    UHS       "Underground Hydrogen Storage",
    TANKS     "Hydrogen Tanks" /;

set FUEL / 
    H2_stored "Hydrogen stored",
    H2        "Hydrogen" /;

set storage_plants(TECHNOLOGY) / UHS, TANKS /;

** ------------------------------------------------
$elseif.ph %phase%=='data'

*------------------------------------------------------------
* Technical and economic parameters for hydrogen production tech
* Source: Hydrogen Inputs for OSeMOSYS and cost assessment sheets
*------------------------------------------------------------

# Hydrogen Electrolyzers (HEL)
AvailabilityFactor(r,'HEL',y) = 0.9;
OperationalLife(r,'HEL') = 10;
* CapitalCost defined yearly below from 'H2 Production Cost Assessment' (Green H2 €/kg)
CapitalCost(r,'HEL',2023) = 5120;
CapitalCost(r,'HEL',2024) = 4960;
CapitalCost(r,'HEL',2025) = 4810;
CapitalCost(r,'HEL',2026) = 4650;
CapitalCost(r,'HEL',2027) = 4490;
CapitalCost(r,'HEL',2028) = 4330;
CapitalCost(r,'HEL',2029) = 4170;
CapitalCost(r,'HEL',2030) = 4010;
CapitalCost(r,'HEL',2031) = 3850;
CapitalCost(r,'HEL',2032) = 3690;
CapitalCost(r,'HEL',2033) = 3530;
CapitalCost(r,'HEL',2034) = 3370;
CapitalCost(r,'HEL',2035) = 3210;
CapitalCost(r,'HEL',2036) = 3050;
CapitalCost(r,'HEL',2037) = 2890;
CapitalCost(r,'HEL',2038) = 2730;
CapitalCost(r,'HEL',2039) = 2570;
CapitalCost(r,'HEL',2040) = 2410;
CapitalCost(r,'HEL',2041) = 2250;
CapitalCost(r,'HEL',2042) = 2090;
CapitalCost(r,'HEL',2043) = 1930;
CapitalCost(r,'HEL',2044) = 1770;
CapitalCost(r,'HEL',2045) = 1610;
CapitalCost(r,'HEL',2046) = 1450;
CapitalCost(r,'HEL',2047) = 1290;
CapitalCost(r,'HEL',2048) = 1130;
CapitalCost(r,'HEL',2049) = 970;
CapitalCost(r,'HEL',2050) = 810;
VariableCost(r,'HEL',m,y) = 0;
FixedCost(r,'HEL',y) = 0;

# Steam Methane Reforming with CCS (SMR_CCS)
AvailabilityFactor(r,'SMR_CCS',y) = 0.9;
OperationalLife(r,'SMR_CCS') = 10;
* CapitalCost defined yearly below from 'H2 Production Cost Assessment' (Blue H2 €/kg)
CapitalCost(r,'SMR_CCS',2023) = 2790;
CapitalCost(r,'SMR_CCS',2024) = 2760;
CapitalCost(r,'SMR_CCS',2025) = 2720;
CapitalCost(r,'SMR_CCS',2026) = 2690;
CapitalCost(r,'SMR_CCS',2027) = 2650;
CapitalCost(r,'SMR_CCS',2028) = 2620;
CapitalCost(r,'SMR_CCS',2029) = 2580;
CapitalCost(r,'SMR_CCS',2030) = 2550;
CapitalCost(r,'SMR_CCS',2031) = 2510;
CapitalCost(r,'SMR_CCS',2032) = 2480;
CapitalCost(r,'SMR_CCS',2033) = 2440;
CapitalCost(r,'SMR_CCS',2034) = 2410;
CapitalCost(r,'SMR_CCS',2035) = 2370;
CapitalCost(r,'SMR_CCS',2036) = 2340;
CapitalCost(r,'SMR_CCS',2037) = 2300;
CapitalCost(r,'SMR_CCS',2038) = 2270;
CapitalCost(r,'SMR_CCS',2039) = 2230;
CapitalCost(r,'SMR_CCS',2040) = 2200;
CapitalCost(r,'SMR_CCS',2041) = 2160;
CapitalCost(r,'SMR_CCS',2042) = 2130;
CapitalCost(r,'SMR_CCS',2043) = 2090;
CapitalCost(r,'SMR_CCS',2044) = 2060;
CapitalCost(r,'SMR_CCS',2045) = 2020;
CapitalCost(r,'SMR_CCS',2046) = 1990;
CapitalCost(r,'SMR_CCS',2047) = 1950;
CapitalCost(r,'SMR_CCS',2048) = 1920;
CapitalCost(r,'SMR_CCS',2049) = 1880;
CapitalCost(r,'SMR_CCS',2050) = 1850; (converted from USD)
VariableCost(r,'SMR_CCS',m,y) = 0;
FixedCost(r,'SMR_CCS',y) = 0;

# Underground Hydrogen Storage (UHS)
AvailabilityFactor(r,'UHS',y) = 0.9;
OperationalLife(r,'UHS') = 30;
* CapitalCost defined yearly below from 'H2 Storage Cost Assessment' (€/kg * 1000)
CapitalCost(r,'UHS',2023) = 2140;
CapitalCost(r,'UHS',2024) = 2100;
CapitalCost(r,'UHS',2025) = 2060;
CapitalCost(r,'UHS',2026) = 2030;
CapitalCost(r,'UHS',2027) = 1990;
CapitalCost(r,'UHS',2028) = 1950;
CapitalCost(r,'UHS',2029) = 1910;
CapitalCost(r,'UHS',2030) = 1880;
CapitalCost(r,'UHS',2031) = 1840;
CapitalCost(r,'UHS',2032) = 1800;
CapitalCost(r,'UHS',2033) = 1760;
CapitalCost(r,'UHS',2034) = 1730;
CapitalCost(r,'UHS',2035) = 1690;
CapitalCost(r,'UHS',2036) = 1650;
CapitalCost(r,'UHS',2037) = 1610;
CapitalCost(r,'UHS',2038) = 1580;
CapitalCost(r,'UHS',2039) = 1540;
CapitalCost(r,'UHS',2040) = 1500;
CapitalCost(r,'UHS',2041) = 1460;
CapitalCost(r,'UHS',2042) = 1430;
CapitalCost(r,'UHS',2043) = 1390;
CapitalCost(r,'UHS',2044) = 1350;
CapitalCost(r,'UHS',2045) = 1310;
CapitalCost(r,'UHS',2046) = 1280;
CapitalCost(r,'UHS',2047) = 1240;
CapitalCost(r,'UHS',2048) = 1200;
CapitalCost(r,'UHS',2049) = 1160;
CapitalCost(r,'UHS',2050) = 1130;
VariableCost(r,'UHS',m,y) = 0;
FixedCost(r,'UHS',y) = 0;

# Hydrogen Tanks (TANKS)
AvailabilityFactor(r,'TANKS',y) = 0.9;
OperationalLife(r,'TANKS') = 20;  # Assumed
* CapitalCost defined yearly below from 'H2 Storage Cost Assessment' (Compressed Gas €/kg * 1000)
CapitalCost(r,'TANKS',2023) = 9300;
CapitalCost(r,'TANKS',2024) = 9160;
CapitalCost(r,'TANKS',2025) = 9020;
CapitalCost(r,'TANKS',2026) = 8890;
CapitalCost(r,'TANKS',2027) = 8750;
CapitalCost(r,'TANKS',2028) = 8610;
CapitalCost(r,'TANKS',2029) = 8470;
CapitalCost(r,'TANKS',2030) = 8340;
CapitalCost(r,'TANKS',2031) = 8200;
CapitalCost(r,'TANKS',2032) = 8060;
CapitalCost(r,'TANKS',2033) = 7920;
CapitalCost(r,'TANKS',2034) = 7790;
CapitalCost(r,'TANKS',2035) = 7650;
CapitalCost(r,'TANKS',2036) = 7510;
CapitalCost(r,'TANKS',2037) = 7370;
CapitalCost(r,'TANKS',2038) = 7240;
CapitalCost(r,'TANKS',2039) = 7100;
CapitalCost(r,'TANKS',2040) = 6960;
CapitalCost(r,'TANKS',2041) = 6820;
CapitalCost(r,'TANKS',2042) = 6690;
CapitalCost(r,'TANKS',2043) = 6550;
CapitalCost(r,'TANKS',2044) = 6410;
CapitalCost(r,'TANKS',2045) = 6270;
CapitalCost(r,'TANKS',2046) = 6140;
CapitalCost(r,'TANKS',2047) = 6000;
CapitalCost(r,'TANKS',2048) = 5860;
CapitalCost(r,'TANKS',2049) = 5720;
CapitalCost(r,'TANKS',2050) = 5590;
VariableCost(r,'TANKS',m,y) = 0;
FixedCost(r,'TANKS',y) = 0;

# Industrial Heating - Hydrogen (IHH)
AvailabilityFactor(r,'IHH',y) = 0.9;
OperationalLife(r,'IHH') = 15;  # Assumed lifetime for industrial heating
CapitalCost(r,'IHH',y) = 1000;   # Rough estimate based on heating techs
VariableCost(r,'IHH',m,y) = 0;
FixedCost(r,'IHH',y) = 0;

# Hydrogen Grid (GRID_H2) represents hydrogen pipelines and distribution network
AvailabilityFactor(r,'GRID_H2',y) = 0.9;
OperationalLife(r,'GRID_H2') = 40;
* CapitalCost defined yearly from 'Cost Assessment for H2' sheet
* Original pipeline cost in €/km converted to €/kW using the following assumptions:
* - Average pipeline length = 400 km
* - Pipeline capacity = 2 GW
* - Lifetime = 40 years
* Conversion formula: (€/km * 400 km) / 2,000,000 kW
CapitalCost(r,'GRID_H2',2023) = 158;
CapitalCost(r,'GRID_H2',2024) = 152;
CapitalCost(r,'GRID_H2',2025) = 148;
CapitalCost(r,'GRID_H2',2026) = 144;
CapitalCost(r,'GRID_H2',2027) = 140;
CapitalCost(r,'GRID_H2',2028) = 136;
CapitalCost(r,'GRID_H2',2029) = 132;
CapitalCost(r,'GRID_H2',2030) = 128;
CapitalCost(r,'GRID_H2',2031) = 124;
CapitalCost(r,'GRID_H2',2032) = 120;
CapitalCost(r,'GRID_H2',2033) = 116;
CapitalCost(r,'GRID_H2',2034) = 112;
CapitalCost(r,'GRID_H2',2035) = 108;
CapitalCost(r,'GRID_H2',2036) = 104;
CapitalCost(r,'GRID_H2',2037) = 100;
CapitalCost(r,'GRID_H2',2038) = 96;
CapitalCost(r,'GRID_H2',2039) = 92;
CapitalCost(r,'GRID_H2',2040) = 88;
CapitalCost(r,'GRID_H2',2041) = 84;
CapitalCost(r,'GRID_H2',2042) = 80;
CapitalCost(r,'GRID_H2',2043) = 76;
CapitalCost(r,'GRID_H2',2044) = 72;
CapitalCost(r,'GRID_H2',2045) = 68;
CapitalCost(r,'GRID_H2',2046) = 64;
CapitalCost(r,'GRID_H2',2047) = 60;
CapitalCost(r,'GRID_H2',2048) = 56;
CapitalCost(r,'GRID_H2',2049) = 52;
CapitalCost(r,'GRID_H2',2050) = 48;  # Conservative grid infrastructure cost (€/kW)
VariableCost(r,'GRID_H2',m,y) = 0;
FixedCost(r,'GRID_H2',y) = 0;

** ------------------------------------------------
$elseif.ph %phase%=='popol'

*------------------------------------------------------------
* Fuel flows and storage mappings for hydrogen technologies
*------------------------------------------------------------

# HEL: Electricity to Hydrogen
InputActivityRatio(r,'HEL','ELC','1',y) = 1;   # IEA convention
OutputActivityRatio(r,'HEL','H2','1',y) = 1;   # IEA convention
TechnologyToStorage(r,'1','HEL','HYDROGEN') = 1;

# SMR_CCS: Gas to Hydrogen
InputActivityRatio(r,'SMR_CCS','GAS','1',y) = 1;
OutputActivityRatio(r,'SMR_CCS','H2','1',y) = 1;
TechnologyToStorage(r,'1','SMR_CCS','HYDROGEN') = 1;

# Storage flows for UHS
TechnologyToStorage(r,'1','UHS','HYDROGEN') = 1;
TechnologyFromStorage(r,'2','UHS','HYDROGEN') = 1;

# Storage flows for TANKS
TechnologyToStorage(r,'1','TANKS','HYDROGEN') = 1;
TechnologyFromStorage(r,'2','TANKS','HYDROGEN') = 1;

# Industrial Heating with Hydrogen
InputActivityRatio(r,'IHH','H2','1',y) = 1;   # Consumes hydrogen
OutputActivityRatio(r,'IHH','IH','1',y) = 1;   # Delivers industrial heating service

# Industrial Heating with Hydrogen
InputActivityRatio(r,'IHH','H2','1',y) = 1;   # Consumes hydrogen
OutputActivityRatio(r,'IHH','IH','1',y) = 1;   # Delivers industrial heating service

# Hydrogen Grid (GRID_H2)
InputActivityRatio(r,'GRID_H2','H2','1',y) = 1;
OutputActivityRatio(r,'GRID_H2','H2','1',y) = 1;   # Assumes grid redistributes H2 without losses

# Note: Reversible tech 'REV_DEV' intentionally excluded

$endif.ph
