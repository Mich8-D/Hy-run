$include "Data/germany_no_ren_data.gms"
#$include "Data/renewables_data.gms" - for batteries testing only

#model 3
# batteries discharge over time

set YEAR    / 2024*2050 /;
set TECHNOLOGY /
    BATTERY "Battery"
    /;

set REGION /GERMANY/;
set STORAGE / BATTERY "BATTERY" /;

#populating from our researched data
ResidualCapacity(r, "BATTERY", y) = 6500; #for 2023 - to be interpolated?
OutputActivityRatio(r, "BATTERY", "ELC", "1", y) = 0.9; #90% efficiency
CapitalCost(r, "BATTERY", y) = 350; #midpoint of 300-400 $/kwH
#FixedCost(r, "BATTERY", y) = 11,750; #midpoint of 5,500 - 18,000 $/MW/yr
#VariableCost(r, "BATTERY", m, y) = 1.75; #midpoint of 0.5 - 3.0 $/MWh
OperationalLife(r,'BATTERY') = 15;
EmissionActivityRatio(r,'BATTERY','CO2',m,y) = 0;
CapacityFactor(r,'BATTERY',l,y) = 0.228; #load factor 2000/ 8760