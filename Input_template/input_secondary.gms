$set phase %1

** ----------------------------------------------------------------
$ifthen.ph %phase%=='sets'

set     TECHNOLOGY      /
        COAL 'Coal power plants'
        GFPP 'Gas fired power plants'
        ROR 'run-of-river hydroelectric power plants'
        OIL_GEN 'Oil power plants'
        BIO 'Biomass power plants'
        GEO 'Geothermal power plants'
        SPV 'Solar power plants'
        WPP_ON 'Wind power plants - onshore' 
        WPP_OFF  'Wind power plants - offshore' 
        GRID_ELC 'Electric grid' /; 

set    FUEL            /
        ELC1 'Electricity-to-Grid'
        ELC2 'Electricity-from-grid'/; 

set power_plants(TECHNOLOGY)   / COAL, GFPP, ROR, OIL_GEN, BIO, GEO, SPV, WPP_ON, WPP_OFF /;
set fuel_transformation(TECHNOLOGY) / /;
set fuel_transmission(TECHNOLOGY) / GRID_ELC /;
set renewable_tech(TECHNOLOGY) / SPV, WPP_ON, WPP_OFF, BIO, GEO, ROR /;

set secondary_carrier(FUEL) / ELC1, ELC2 /;

** ----------------------------------------------------------------
$elseif.ph %phase%=='data'

# Characterize SOLAR technology
OperationalLife(r,'SPV') = 25;
CapacityFactor(r,'SPV','ID',y) = 0.13;
CapacityFactor(r,'SPV','IN',y) = 0;
CapacityFactor(r,'SPV','SD',y) = 0.22;
CapacityFactor(r,'SPV','SN',y) = 0;
CapacityFactor(r,'SPV','WD',y) = 0.04;
CapacityFactor(r,'SPV','WN',y) = 0;


SCALAR 
    a_SPV /269.66/,
    b_SPV /-0.21/,
    c_SPV /450.03/;

CapitalCost(r, 'SPV', y) = a_SPV * exp(b_SPV * (ord(y) - 1)) + c_SPV; # Unit: €/kW
VariableCost(r,'SPV',m,y) = 1e-5; # Unit: €/GJ
FixedCost(r,'SPV',y) = 10; # Unit: €/kW/y
ResidualCapacity(r,"SPV",y) = 102.3;  # Unit: GW (from Excel)
TotalAnnualMaxCapacityInvestment(r,'SPV',y) = 20;
TotalAnnualMinCapacityInvestment(r,'SPV',y) = 9;

# Characterize WIND-ONSHORE technology
OperationalLife(r,'WPP_ON') = 25;
CapacityFactor(r,'WPP_ON','ID',y) = 0.19;
CapacityFactor(r,'WPP_ON','IN',y) = 0.21;
CapacityFactor(r,'WPP_ON','SD',y) = 0.12;
CapacityFactor(r,'WPP_ON','SN',y) = 0.13;
CapacityFactor(r,'WPP_ON','WD',y) = 0.31;
CapacityFactor(r,'WPP_ON','WN',y) = 0.33;

SCALAR 
    a_WON /1940/,
    b_WON /-0.02/,
    c_WON /-140/;

CapitalCost(r,'WPP_ON', y) = a_WON * exp(b_WON * (ord(y)-1)) + c_WON; # Unit: €/kW
VariableCost(r,'WPP_ON',m,y) = 1e-5;
FixedCost(r,'WPP_ON',y) = 40;  # Unit: €/kW/y
ResidualCapacity(r,"WPP_ON",y) = 63.6;  # Unit: GW (from Excel)
TotalAnnualMaxCapacityInvestment(r,'WPP_ON',y) = 20;
TotalAnnualMaxCapacity(r,'WPP_ON',y) = 250; # Unit: GW (from Excel)

# Characterize WIND-OFFSHORE technology
OperationalLife(r,'WPP_OFF') = 25;
CapacityFactor(r,'WPP_OFF','ID',y) = 0.31;
CapacityFactor(r,'WPP_OFF','IN',y) = 0.34;
CapacityFactor(r,'WPP_OFF','SD',y) = 0.21;
CapacityFactor(r,'WPP_OFF','SN',y) = 0.26;
CapacityFactor(r,'WPP_OFF','WD',y) = 0.42;
CapacityFactor(r,'WPP_OFF','WN',y) = 0.43;

SCALAR 
    a_WOFF /528/,
    b_WOFF /-0.22/,
    c_WOFF /2600/;

CapitalCost(r,'WPP_OFF', y) = a_WOFF * exp(b_WOFF * (ord(y)-1)) + c_WOFF; # Unit: €/kW
VariableCost(r,'WPP_OFF',m,y) = 1e-5;
FixedCost(r,'WPP_OFF',y) = 100;  # Unit: €/kW/y
ResidualCapacity(r,"WPP_OFF",y) = 9.2;
TotalAnnualMaxCapacityInvestment(r,'WPP_OFF',y) = 10;
TotalAnnualMaxCapacity(r,'WPP_OFF',y) = 100; 

# Characterize BIOMASS technology
OperationalLife(r,'BIO') = 25;
AvailabilityFactor(r,'BIO',y) = 0.81;
CapitalCost(r,'BIO',y) = 4000 - 5 * (y.val - 2024); # Unit: €/kW
VariableCost(r,'BIO',m,y) = 0.005; 
FixedCost(r,'BIO',y) = 50; # Unit: €/kW
ResidualCapacity(r,"BIO",y) = 9.19;  # Unit: GW (from Excel)
TotalAnnualMaxCapacity(r,'BIO',y)$(y.val <= 2034) = 19;
TotalAnnualMaxCapacityInvestment(r,'BIO',y)$(y.val > 2034) = 1.2;

# Characterize GEOTHERMAL technology
OperationalLife(r,'GEO') = 25;
CapitalCost(r,'GEO',y) = 4200;  # Unit: €/kW
AvailabilityFactor(r,'GEO',y) = 0.9;
VariableCost(r,'GEO',m,y) = 1e-5;
FixedCost(r,'GEO',y) = 70;
ResidualCapacity(r,"GEO",y) = 0.016;  # Unit: GW (from Excel)
TotalAnnualMaxCapacity(r,'GEO',y) = 0.02;

# Characterize RUN-OF-RIVER technology
OperationalLife(r,'ROR') = 80;
CapacityFactor(r,'ROR',l,y) = 0.31;
CapitalCost(r,'ROR',y) = 3000;
VariableCost(r,'ROR',m,y) = 1e-5;
FixedCost(r,'ROR',y) = 50;
ResidualCapacity(r,"ROR",y) = 6.4;  # Unit: GW (from Excel)
TotalAnnualMaxCapacityInvestment(r,'ROR',y) = 0;

# Characterize COAL technology
OperationalLife(r,'COAL') = 50;
AvailabilityFactor(r,'COAL',y) = 0.9;
CapitalCost(r,'COAL',y) = 2000;             # €/kW
VariableCost(r,'COAL',m,y) = 0.1;
FixedCost(r,'COAL',y) = 10;
# From 2024 to 2029 (inclusive) interrolation via the following formula:
# m = (0 - 18.9) / (2050 - 2024) = -0.945
# And thus for any year y:
ResidualCapacity(r,"COAL",y)$(y.val < 2035) = 31.2 - 3.12 * (y.val - 2024);
TotalAnnualMaxCapacityInvestment(r,'COAL',y) = 0;
EmissionActivityRatio(r,'COAL','CO2_PP','1',y) = 0.0895/0.45; # Unit: kton CO2 per PJ (infra ops)

# Characterize GFPP technology
OperationalLife(r,'GFPP') = 30;
AvailabilityFactor(r,'GFPP',y) = 0.90;
CapitalCost(r,'GFPP',y) = 1200;             # €/kW
VariableCost(r,'GFPP',m,y) = 1e-5;
FixedCost(r,'GFPP',y) = 15;
ResidualCapacity(r,"GFPP",y)$(y.val < 2030) = 36.7 - 2*(y.val - 2024); # Unit: GW
ResidualCapacity(r, "GFPP", y)$(y.val >= 2030) = 22.5;
TotalAnnualMaxCapacityInvestment(r,'GFPP',y) = 15;
EmissionActivityRatio(r,'GFPP','CO2_PP','1',y) = 0.0561/0.55; # Unit: kton CO2 per PJ (infra ops)

# Characterize OIL technology
OperationalLife(r,'OIL_GEN') = 40;
AvailabilityFactor(r,'OIL_GEN',y) = 0.85;
CapitalCost(r,'OIL_GEN',y) = 1800;          # €/kW
VariableCost(r,'OIL_GEN',m,y) = 1e-5;
FixedCost(r,'OIL_GEN',y) = 10;
ResidualCapacity(r, "OIL_GEN", y) = 4.4;
EmissionActivityRatio(r,'OIL_GEN','CO2_PP','1',y) = 0.073/0.4; # Unit: kton CO2 per PJ (infra ops)
TotalAnnualMaxCapacityInvestment(r,'OIL_GEN',y) = 0;

# Characterize ELECTRIC GRID technology
OperationalLife(r,'GRID_ELC') = 40;
AvailabilityFactor(r,'GRID_ELC',y) = 1;
CapitalCost(r,'GRID_ELC',y) = 1.5;        # €/kW - Based on midpoint of 2023 cost range
VariableCost(r,'GRID_ELC',m,y) = 0.00001; # €/kWh - minor O&M
FixedCost(r,'GRID_ELC',y) = 0.02;         # €/kW/year - 1.5% of CAPEX as fixed O&M
ResidualCapacity(r,"GRID_ELC",y) = 1.55;  # GW 

** ----------------------------------------------------------------
$elseif.ph %phase%=='popol'

InputActivityRatio(r,'SPV','SUN',"1",y) = 1; #IEA convention
OutputActivityRatio(r,'SPV','ELC1',"1",y) = 1; 

InputActivityRatio(r,'WPP_ON','WIN',"1",y) = 1; #IEA convention
OutputActivityRatio(r,'WPP_ON','ELC1',"1",y) = 1; 

InputActivityRatio(r,'WPP_OFF','WIN',"1",y) = 1; #IEA convention
OutputActivityRatio(r,'WPP_OFF','ELC1',"1",y) = 1; 

InputActivityRatio(r,'BIO','WBM',"1",y) = 1/0.28;
OutputActivityRatio(r,'BIO','ELC1',"1",y) = 1;

InputActivityRatio(r,'GEO','GTH',"1",y) = 1;
OutputActivityRatio(r,'GEO','ELC1',"1",y) = 1;

InputActivityRatio(r,'COAL','HCO',"1",y) = 1/0.45;
OutputActivityRatio(r,'COAL','ELC1',"1",y) = 1;

InputActivityRatio(r,'ROR','HYD',"1",y) = 1;
OutputActivityRatio(r,'ROR','ELC1',"1",y) = 1;

** open cycle gas turbines
InputActivityRatio(r,'GFPP','GAS2',"1",y) = 1/0.55;
OutputActivityRatio(r,'GFPP','ELC1',"1",y) = 1;

** oil power plants
InputActivityRatio(r,'OIL_GEN','OIL',"1",y) = 1/0.4;
OutputActivityRatio(r,'OIL_GEN','ELC1',"1",y) = 1;

** electric grid
InputActivityRatio(r,'GRID_ELC','ELC1',"1",y) = 1/0.96;
OutputActivityRatio(r,'GRID_ELC','ELC2',"1",y) = 1;

$endif.ph