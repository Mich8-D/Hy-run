$include "Data/germany_no_ren_data.gms"
$include "Data/renewables_data.gms"

* Hydrogen Production Technologies

*------------------------------------------------------------
* Technologies and model years considered
*------------------------------------------------------------
SET
    h2tech    / Electrolyzer, SMR_CCS /
    year      / 2023*2050 /;

*------------------------------------------------------------
* Parameters:
* Cost_H2Prod: Production cost of hydrogen in €/kg H2
* Eff_H2Prod: Efficiency of each production technology (%)
* Emission_H2Prod: CO2 emissions in kg CO2 per kg H2
* InvCost_H2Prod: Investment cost in €/kW
*------------------------------------------------------------
PARAMETER
    Cost_H2Prod(h2tech, year)   "Cost of hydrogen production (€/kg H2)"
    Eff_H2Prod(h2tech)          "Efficiency of hydrogen production (%)"
    Emission_H2Prod(h2tech)     "CO2 emission factor (kg CO2/kg H2)"
    InvCost_H2Prod(h2tech)      "Investment cost of production technology (€/kW)";

*------------------------------------------------------------
* UPDATED COST DATA (2023–2050)
* Source: 'H2 Production Cost Assessment' sheet (interpolated values)
* Electrolyzer = Green Hydrogen
* SMR_CCS     = Blue Hydrogen
*------------------------------------------------------------
Cost_H2Prod('Electrolyzer', 2023) = 5.12;
Cost_H2Prod('Electrolyzer', 2024) = 4.96;
Cost_H2Prod('Electrolyzer', 2025) = 4.81;
Cost_H2Prod('Electrolyzer', 2026) = 4.65;
Cost_H2Prod('Electrolyzer', 2027) = 4.49;
Cost_H2Prod('Electrolyzer', 2028) = 4.33;
Cost_H2Prod('Electrolyzer', 2029) = 4.17;
Cost_H2Prod('Electrolyzer', 2030) = 4.01;
Cost_H2Prod('Electrolyzer', 2031) = 3.85;
Cost_H2Prod('Electrolyzer', 2032) = 3.69;
Cost_H2Prod('Electrolyzer', 2033) = 3.53;
Cost_H2Prod('Electrolyzer', 2034) = 3.37;
Cost_H2Prod('Electrolyzer', 2035) = 3.21;
Cost_H2Prod('Electrolyzer', 2036) = 3.05;
Cost_H2Prod('Electrolyzer', 2037) = 2.89;
Cost_H2Prod('Electrolyzer', 2038) = 2.73;
Cost_H2Prod('Electrolyzer', 2039) = 2.57;
Cost_H2Prod('Electrolyzer', 2040) = 2.41;
Cost_H2Prod('Electrolyzer', 2041) = 2.25;
Cost_H2Prod('Electrolyzer', 2042) = 2.09;
Cost_H2Prod('Electrolyzer', 2043) = 1.93;
Cost_H2Prod('Electrolyzer', 2044) = 1.77;
Cost_H2Prod('Electrolyzer', 2045) = 1.61;
Cost_H2Prod('Electrolyzer', 2046) = 1.45;
Cost_H2Prod('Electrolyzer', 2047) = 1.29;
Cost_H2Prod('Electrolyzer', 2048) = 1.13;
Cost_H2Prod('Electrolyzer', 2049) = 0.97;
Cost_H2Prod('Electrolyzer', 2050) = 0.81;

Cost_H2Prod('SMR_CCS', 2023) = 2.79;
Cost_H2Prod('SMR_CCS', 2024) = 2.76;
Cost_H2Prod('SMR_CCS', 2025) = 2.72;
Cost_H2Prod('SMR_CCS', 2026) = 2.69;
Cost_H2Prod('SMR_CCS', 2027) = 2.65;
Cost_H2Prod('SMR_CCS', 2028) = 2.62;
Cost_H2Prod('SMR_CCS', 2029) = 2.58;
Cost_H2Prod('SMR_CCS', 2030) = 2.55;
Cost_H2Prod('SMR_CCS', 2031) = 2.51;
Cost_H2Prod('SMR_CCS', 2032) = 2.48;
Cost_H2Prod('SMR_CCS', 2033) = 2.44;
Cost_H2Prod('SMR_CCS', 2034) = 2.41;
Cost_H2Prod('SMR_CCS', 2035) = 2.37;
Cost_H2Prod('SMR_CCS', 2036) = 2.34;
Cost_H2Prod('SMR_CCS', 2037) = 2.30;
Cost_H2Prod('SMR_CCS', 2038) = 2.27;
Cost_H2Prod('SMR_CCS', 2039) = 2.23;
Cost_H2Prod('SMR_CCS', 2040) = 2.20;
Cost_H2Prod('SMR_CCS', 2041) = 2.16;
Cost_H2Prod('SMR_CCS', 2042) = 2.13;
Cost_H2Prod('SMR_CCS', 2043) = 2.09;
Cost_H2Prod('SMR_CCS', 2044) = 2.06;
Cost_H2Prod('SMR_CCS', 2045) = 2.02;
Cost_H2Prod('SMR_CCS', 2046) = 1.99;
Cost_H2Prod('SMR_CCS', 2047) = 1.95;
Cost_H2Prod('SMR_CCS', 2048) = 1.92;
Cost_H2Prod('SMR_CCS', 2049) = 1.88;
Cost_H2Prod('SMR_CCS', 2050) = 1.85;

*------------------------------------------------------------
* Technology efficiencies
* Source: Hydrogen Inputs for OSeMOSYS
*------------------------------------------------------------
Eff_H2Prod('Electrolyzer') = 70;

*------------------------------------------------------------
* Emission factors (only SMR provided)
* Source: Hydrogen Inputs for OSeMOSYS — SMR emission before CCS
*------------------------------------------------------------
Emission_H2Prod('SMR_CCS') = 10;

*------------------------------------------------------------
* Capital investment cost in €/kW
* Source: Hydrogen Inputs for OSeMOSYS — Electrolyzer CAPEX
*------------------------------------------------------------
InvCost_H2Prod('Electrolyzer') = 930;
InvCost_H2Prod('SMR_CCS') = 1423;
* Source: S&P Global (2024), Netherlands estimate converted to € using 1 USD = 0.85 EUR

*------------------------------------------------------------
* Required OSeMOSYS parameters for technology operation
*------------------------------------------------------------

OutputActivityRatio('DEU','Electrolyzer','1','HYDROGEN',y) = 1;
OutputActivityRatio('DEU','SMR_CCS','1','HYDROGEN',y) = 1;
* For simplicity, assume OutputActivityRatio is 1 for all hydrogen production technologies.
* This matches IEA convention where 1 unit of input results in 1 unit of output energy.
* Note: 'DEU' is assumed as region label based on dataset naming (Germany)
* 'ELC' is input for Electrolyzer, 'GAS' is input for SMR_CCS, both produce 'HYDROGEN'

PARAMETER
    CapacityFactor(r,t,l,y)     "Technology capacity factor"
    AvailabilityFactor(r,t,y)   "Technology availability"
    InputActivityRatio(r,t,f,m,y) "Input fuel per output unit"
    TechnologyToStorage(r,m,t,s) "Output from tech to storage"
    OperationalLife(r,t)        "Tech lifetime"
    CapitalCost(r,t,y)          "CAPEX €/kW"
    VariableCost(r,t,m,y)       "€/unit variable cost"
    FixedCost(r,t,y)            "€/kW fixed cost";

* Electrolyzer definitions
CapacityFactor('DEU','Electrolyzer','1',y) = 1;
AvailabilityFactor('DEU','Electrolyzer',y) = 0.9;
InputActivityRatio('DEU','Electrolyzer','ELC','1',y) = 1;
TechnologyToStorage('DEU','1','Electrolyzer','HYDROGEN') = 1;
OperationalLife('DEU','Electrolyzer') = 10;
CapitalCost('DEU','Electrolyzer',y) = InvCost_H2Prod('Electrolyzer');
VariableCost('DEU','Electrolyzer','1',y) = 0;
FixedCost('DEU','Electrolyzer',y) = 0;

* SMR + CCS definitions
CapacityFactor('DEU','SMR_CCS','1',y) = 1;
AvailabilityFactor('DEU','SMR_CCS',y) = 0.9;
InputActivityRatio('DEU','SMR_CCS','GAS','1',y) = 1;
TechnologyToStorage('DEU','1','SMR_CCS','HYDROGEN') = 1;
OperationalLife('DEU','SMR_CCS') = 10;
CapitalCost('DEU','SMR_CCS',y) = InvCost_H2Prod('SMR_CCS');
VariableCost('DEU','SMR_CCS','1',y) = 0;
FixedCost('DEU','SMR_CCS',y) = 0;
