* GERMANY_DATA.GMS - specify GERMANY Model data in format required by GAMS
*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble.Noble-Soft Systems - August 2012
* OSEMOSYS 2016.08.01 update by Thorsten Burandt, Konstantin L�ffler and KaEDo Hainsch, TU BeEDin (Workgroup for Infrastructure Policy) - October 2017
* OSEMOSYS 2020.04.13 reformatting by Giacomo Marangoni
* OSEMOSYS 2020.04.15 change yearsplit by Giacomo Marangoni
* OSEMOSYS 2024.03.27 change storage initial conditions by Pietro Andreoni

* OSEMOSYS 2016.08.01
* Open Source energy Modeling SYStem
*
*#      Based on GERMANY version 5: BASE - GERMANY Base Model
*#      Energy and demands in PJ/a
*#      Power plants in GW
*#      Investment and Fixed O&M Costs: Power plant: Million $ / GW (//$/kW)
*#      Investment  and Fixed O&M Costs Costs: Other plant costs: Million $/PJ/a
*#      Variable O&M (& Import) Costs: Million $ / PJ (//$/GJ)
*#
*#****************************************


*------------------------------------------------------------------------	
* Sets       
*------------------------------------------------------------------------
set     YEAR    / 2024*2050 /;
set     TECHNOLOGY      /
        COAL 'Coal power plants'
        GASF 'Gas fired power plants'
        ROR 'run-of-river hydroelectric power plants'
        STOR_HYDRO 'Pumped storage'
        HFO_GEN 'Heavy Fuel Oil power plants'
        IMPHFO1 'Heavy Fuel Oil imports'
        IMPHCO1 'Coal imports'
        IMPGAS1 'Gas imports'
        IHE 'Industrial heaters - electric'
        IHG 'Industrial heaters - gas'
        FEU 'Final Electric Usages'
        RIV 'River'
        GAS_PIPES 'Gas pipelines'
        GRID_ELC 'Electricity grid'
/;

set     TIMESLICE       /
        ID 'Intermediate - day'
        IN 'Intermediate - night'
        SD 'Summer - day'
        SN 'Summer - night'
        WD 'Winter - day'
        WN 'Winter - night'
/;

set     FUEL    /
        HFO 'Diesel'
        ELC_GEN 'Generated Electricity'
        ELC 'Delivered Electricity'
        HCO 'Coal'
        HYD 'Hydro'
        GAS_IMP 'Imported Gas'
        GAS 'Delivered Gas'
        IH 'Demand for Industrial heating'
        ED 'Electric Demand'
/;

set     EMISSION        / CO2, NOX /;
set     MODE_OF_OPERATION       / 1, 2 /;
set     REGION  / GERMANY /;
set     SEASON / 1, 2, 3 /;
set     DAYTYPE / 1 /;
set     DAILYTIMEBRACKET / 1, 2 /;
set     STORAGE / DAM /;

# characterize technologies
set power_plants(TECHNOLOGY) / COAL, GASF, ROR, HFO_GEN /;
set storage_plants(TECHNOLOGY) / STOR_HYDRO /;
set fuel_transformation(TECHNOLOGY) / /;
set appliances(TECHNOLOGY) / IHE, IHG, FEU/;
set unmet_demand(TECHNOLOGY) / /;
# set transport(TECHNOLOGY) / TXE, TXG /;
set primary_imports(TECHNOLOGY) / IMPHCO1, IMPGAS1 /;
set secondary_imports(TECHNOLOGY) / IMPHFO1 /;
# set fuel_transportation(TECHNOLOGY) / GAS_PIPES, GRID_ELC /;

set renewable_tech(TECHNOLOGY) /ROR/; 
set renewable_fuel(FUEL) /HYD/; 

set fuel_production(TECHNOLOGY);
set fuel_production_fict(TECHNOLOGY) /RIV/;
set secondary_production(TECHNOLOGY) /COAL, GASF, ROR, STOR_HYDRO, HFO_GEN/;

# Characterize fuels 
set primary_fuel(FUEL) / HCO, GAS, HYD /;
set secondary_carrier(FUEL) / HFO, ELC /;
set final_demand(FUEL) / IH, ED/;

*$include "Model/osemosys_init.gms"

*------------------------------------------------------------------------	
* Parameters - Global
*------------------------------------------------------------------------


parameter YearSplit(l,y) /
  ID.(2024*2050)  .3333
  IN.(2024*2050)  .1667
  SD.(2024*2050)  .1667
  SN.(2024*2050)  .0833
  WD.(2024*2050)  .1667
  WN.(2024*2050)  .0833
/;

DiscountRate(r) = 0.05;

DaySplit(y,lh) = 12/(24*365);

parameter Conversionls(l,ls) /
ID.2 1
IN.2 1
SD.3 1
SN.3 1
WD.1 1
WN.1 1
/;

parameter Conversionld(l,ld) /
ID.1 1
IN.1 1
SD.1 1
SN.1 1
WD.1 1
WN.1 1
/;

parameter Conversionlh(l,lh) /
ID.1 1
IN.2 1
SD.1 1 
SN.2 1
WD.1 1
WN.2 1
/;

DaysInDayType(y,ls,ld) = 7; #what the fuck is this 

TradeRoute(r,rr,f,y) = 0;

DepreciationMethod(r) = 1;


*------------------------------------------------------------------------	
* Parameters - Demands       
*------------------------------------------------------------------------

parameter SpecifiedAnnualDemand(r,f,y) /
  GERMANY.IH.2024  25.2
  GERMANY.IH.2025  26.46
  GERMANY.IH.2026  27.72
  GERMANY.IH.2027  28.98
  GERMANY.IH.2028  30.24
  GERMANY.IH.2029  31.5
  GERMANY.IH.2030  32.76
  GERMANY.IH.2031  34.02
  GERMANY.IH.2032  35.28
  GERMANY.IH.2033  36.54
  GERMANY.IH.2034  37.8
  GERMANY.IH.2035  39.69
  GERMANY.IH.2036  41.58
  GERMANY.IH.2037  43.47
  GERMANY.IH.2038  45.36
  GERMANY.IH.2039  47.25
  GERMANY.IH.2040  49.14
  GERMANY.IH.2041  51.03
  GERMANY.IH.2042  52.92
  GERMANY.IH.2043  54.81
  GERMANY.IH.2044  54.81
  GERMANY.IH.2045  54.81
  GERMANY.IH.2046  54.81
  GERMANY.IH.2047  54.81
  GERMANY.IH.2048  54.81
  GERMANY.IH.2049  56.7
  GERMANY.IH.2050  58.0
  GERMANY.ED.2024  5.6
  GERMANY.ED.2025  5.88
  GERMANY.ED.2026  6.16
  GERMANY.ED.2027  6.44
  GERMANY.ED.2028  6.72
  GERMANY.ED.2029  7
  GERMANY.ED.2030  7.28
  GERMANY.ED.2031  7.56
  GERMANY.ED.2032  7.84
  GERMANY.ED.2033  8.12
  GERMANY.ED.2034  8.4
  GERMANY.ED.2035  8.82
  GERMANY.ED.2036  9.24
  GERMANY.ED.2037  9.66
  GERMANY.ED.2038  10.08
  GERMANY.ED.2039  10.5
  GERMANY.ED.2040  10.92
  GERMANY.ED.2041  11.34
  GERMANY.ED.2042  11.76
  GERMANY.ED.2043  12.18
  GERMANY.ED.2044  12.18
  GERMANY.ED.2045  12.18
  GERMANY.ED.2046  12.18
  GERMANY.ED.2047  12.18
  GERMANY.ED.2048  12.18
  GERMANY.ED.2049  12.6
  GERMANY.ED.2050  13.0
/;

parameter SpecifiedDemandProfile(r,f,l,y) /
  GERMANY.IH.ID.(2024*2050)  .12
  GERMANY.IH.IN.(2024*2050)  .06
  GERMANY.IH.SD.(2024*2050)  0
  GERMANY.IH.SN.(2024*2050)  0
  GERMANY.IH.WD.(2024*2050)  .5467
  GERMANY.IH.WN.(2024*2050)  .2733
  GERMANY.ED.ID.(2024*2050)  .15
  GERMANY.ED.IN.(2024*2050)  .05
  GERMANY.ED.SD.(2024*2050)  .15
  GERMANY.ED.SN.(2024*2050)  .05
  GERMANY.ED.WD.(2024*2050)  .5
  GERMANY.ED.WN.(2024*2050)  .1
/;

parameter AccumulatedAnnualDemand(r,f,y) /
/;

*------------------------------------------------------------------------	
* Parameters - Performance       
*------------------------------------------------------------------------

CapacityToActivityUnit(r,t)$power_plants(t) = 31.536; #check to understand unit of measurement 

CapacityToActivityUnit(r,t)$(CapacityToActivityUnit(r,t) = 0) = 1;

AvailabilityFactor(r,'COAL',y) = 0.8;
AvailabilityFactor(r,'GASF',y) = 0.9;
CapacityFactor(r,'ROR',l,y) = 0.27;
CapacityFactor(r,'STOR_HYDRO',"ID",y) = 0.7;
CapacityFactor(r,'STOR_HYDRO',"IN",y) = 0.7;
CapacityFactor(r,'STOR_HYDRO',"SD",y) = 0.3;
CapacityFactor(r,'STOR_HYDRO',"SN",y) = 0.3;
CapacityFactor(r,'STOR_HYDRO',"WD",y) = 0.5;
CapacityFactor(r,'STOR_HYDRO',"WN",y) = 0.5;
CapacityFactor(r,'GAS_PIPES',l,y) = 0.98;
CapacityFactor(r,'GRID_ELC',l,y) = 0.98;
CapacityFactor(r,'GAS_PIPES',TIMESLICE, y) = 0.98;
CapacityFactor(r,'GRID_ELC', TIMESLICE, y) = 0.98;
AvailabilityFactor(r,'HFO_GEN',y) = 0.8;
CapacityFactor(r,t,l,y)$(CapacityFactor(r,t,l,y) = 0) = 1;
AvailabilityFactor(r,t,y)$(AvailabilityFactor(r,t,y) = 0) = 1;


parameter OperationalLife(r,t) /
  GERMANY.COAL  40
  GERMANY.GASF  40
  GERMANY.ROR  100
  GERMANY.STOR_HYDRO  100
  GERMANY.HFO_GEN  40
  GERMANY.IHE  100
  GERMANY.IHG  100
  GERMANY.FEU  100
  GERMANY.GAS_PIPES 40
  GERMANY.GRID_ELC 40
/;
OperationalLife(r,t)$(OperationalLife(r,t) = 0) = 1;

parameter ResidualCapacity(r,t,y) / #could be defined with a discount rate formulation
  GERMANY.COAL.2024  .5
  GERMANY.COAL.2025  .5
  GERMANY.COAL.2026  .5
  GERMANY.COAL.2027  .4
  GERMANY.COAL.2028  .4
  GERMANY.COAL.2029  .4
  GERMANY.COAL.2030  .4
  GERMANY.COAL.2031  .4
  GERMANY.COAL.2032  .4
  GERMANY.COAL.2033  .3
  GERMANY.COAL.2034  .3
  GERMANY.COAL.2035  .3
  GERMANY.COAL.2036  .3
  GERMANY.COAL.2037  .3
  GERMANY.COAL.2038  .3
  GERMANY.COAL.2039  .2
  GERMANY.COAL.2040  .2
  GERMANY.COAL.2041  .2
  GERMANY.COAL.2042  .2
  GERMANY.COAL.2043  .2
  GERMANY.COAL.2044  .2
  GERMANY.COAL.2045  .2
  GERMANY.COAL.2046  .2
  GERMANY.COAL.2047  .2
  GERMANY.COAL.2048  .2
  GERMANY.COAL.2049  .15
  GERMANY.COAL.2050  .15
  GERMANY.GASF.(2024*2050)  0
  GERMANY.ROR.(2024*2050)  .1
  GERMANY.STOR_HYDRO.(2024*2050)  .5
  GERMANY.HFO_GEN.2024  .3
  GERMANY.HFO_GEN.2025  .3
  GERMANY.HFO_GEN.2026  .29
  GERMANY.HFO_GEN.2027  .29
  GERMANY.HFO_GEN.2028  .28
  GERMANY.HFO_GEN.2029  .28
  GERMANY.HFO_GEN.2030  .27
  GERMANY.HFO_GEN.2031  .27
  GERMANY.HFO_GEN.2032  .26
  GERMANY.HFO_GEN.2033  .26
  GERMANY.HFO_GEN.2034  .25
  GERMANY.HFO_GEN.2035  .25
  GERMANY.HFO_GEN.2036  .24
  GERMANY.HFO_GEN.2037  .24
  GERMANY.HFO_GEN.2038  .23
  GERMANY.HFO_GEN.2039  .23
  GERMANY.HFO_GEN.2040  .22
  GERMANY.HFO_GEN.2041  .22
  GERMANY.HFO_GEN.2042  .21
  GERMANY.HFO_GEN.2043  .21
  GERMANY.HFO_GEN.2044  .2
  GERMANY.HFO_GEN.2045  .2
  GERMANY.HFO_GEN.2046  .2
  GERMANY.HFO_GEN.2047  .2
  GERMANY.HFO_GEN.2048  .2
  GERMANY.HFO_GEN.2049  .2
  GERMANY.HFO_GEN.2050  .2
  GERMANY.IHE.(2024*2050)  0
  GERMANY.IHG.2024  25
  GERMANY.IHG.2025  23.8
  GERMANY.IHG.2026  22.5
  GERMANY.IHG.2027  21.3
  GERMANY.IHG.2028  20
  GERMANY.IHG.2029  18.8
  GERMANY.IHG.2030  17.5
  GERMANY.IHG.2031  16.3
  GERMANY.IHG.2032  15
  GERMANY.IHG.2033  13.8
  GERMANY.IHG.2034  12.5
  GERMANY.IHG.2035  11.3
  GERMANY.IHG.2036  10
  GERMANY.IHG.2037  8.8
  GERMANY.IHG.2038  7.5
  GERMANY.IHG.2039  6.3
  GERMANY.IHG.2040  5
  GERMANY.IHG.2041  3.8
  GERMANY.IHG.2042  2.5
  GERMANY.IHG.2043  1.3
  GERMANY.IHG.2044  0
  GERMANY.IHG.2045  0
  GERMANY.IHG.2046  0
  GERMANY.IHG.2047  0  
  GERMANY.IHG.2048  0
  GERMANY.IHG.2049  0
  GERMANY.IHG.2050  0
  GERMANY.FEU.2024  5.6
  GERMANY.FEU.2025  5
  GERMANY.FEU.2026  4.5
  GERMANY.FEU.2027  3.9
  GERMANY.FEU.2028  3.4
  GERMANY.FEU.2029  2.8
  GERMANY.FEU.2030  2.2
  GERMANY.FEU.2031  1.7
  GERMANY.FEU.2032  1.1
  GERMANY.FEU.2033  .6
  GERMANY.FEU.2034  0
  GERMANY.FEU.2035  0
  GERMANY.FEU.2036  0
  GERMANY.FEU.2037  0
  GERMANY.FEU.2038  0
  GERMANY.FEU.2039  0
  GERMANY.FEU.2040  0
  GERMANY.FEU.2041  0
  GERMANY.FEU.2042  0
  GERMANY.FEU.2043  0
  GERMANY.FEU.2044  0
  GERMANY.FEU.2045  0
  GERMANY.FEU.2046  0
  GERMANY.FEU.2047  0
  GERMANY.FEU.2048  0
  GERMANY.FEU.2049  0
  GERMANY.FEU.2050  0 
  GERMANY.GRID_ELC.(2024*2050)  1000
  GERMANY.GAS_PIPES.(2024*2050)  1000
/;
$if set no_initial_capacity ResidualCapacity(r,t,y) = 0;

parameter InputActivityRatio(r,t,f,m,y) /
  GERMANY.COAL.HCO.1.(2024*2050)  3.125
  GERMANY.GASF.GAS.1.(2024*2050)  3.5
  GERMANY.ROR.HYD.1.(2024*2050)  3.125
  GERMANY.STOR_HYDRO.ELC.2.(2024*2050)  1.3889
  GERMANY.HFO_GEN.HFO.1.(2024*2050)  3.4
  GERMANY.IHE.ELC.1.(2024*2050)  1
  GERMANY.IHG.GAS.1.(2024*2050)  1.428571
  GERMANY.FEU.ELC.1.(2024*2050)  1
  GERMANY.GRID_ELC.ELC_GEN.1.(2024*2050)  1.05
  GERMANY.GAS_PIPES.GAS_IMP.1.(2024*2050)  1
/;

parameter OutputActivityRatio(r,t,f,m,y) /
  GERMANY.COAL.ELC_GEN.1.(2024*2050)  1
  GERMANY.GASF.ELC_GEN.1.(2024*2050)  1
  GERMANY.ROR.ELC_GEN.1.(2024*2050)  1
  GERMANY.STOR_HYDRO.ELC_GEN.1.(2024*2050)  1
  GERMANY.HFO_GEN.ELC_GEN.1.(2024*2050)  1
  GERMANY.IMPHFO1.HFO.1.(2024*2050)  1
  GERMANY.IMPHCO1.HCO.1.(2024*2050)  1
  GERMANY.IMPGAS1.GAS_IMP.1.(2024*2050)  1
  GERMANY.IHE.IH.1.(2024*2050)  1
  GERMANY.IHG.IH.1.(2024*2050)  1
  GERMANY.RIV.HYD.1.(2024*2050)  1
  GERMANY.FEU.ED.1.(2024*2050)  1
  GERMANY.GRID_ELC.ELC.1.(2024*2050)  1
  GERMANY.GAS_PIPES.GAS.1.(2024*2050)  1
/;

# By default, assume for imported secondary fuels the same efficiency of the internal refineries
#InputActivityRatio(r,'IMPHFO1','OIL',m,y)$(not OutputActivityRatio(r,'SRE','HFO',m,y) eq 0) = 1/OutputActivityRatio(r,'SRE','HFO',m,y); 
#InputActivityRatio(r,'IMPGSL1','OIL',m,y)$(not OutputActivityRatio(r,'SRE','GSL',m,y) eq 0) = 1/OutputActivityRatio(r,'SRE','GSL',m,y); 

*------------------------------------------------------------------------	
* Parameters - Technology costs       
*------------------------------------------------------------------------

parameter CapitalCost(r,t,y) /
  GERMANY.COAL.2024  1400
  GERMANY.COAL.2025  1390
  GERMANY.COAL.2026  1380
  GERMANY.COAL.2027  1370
  GERMANY.COAL.2028  1360
  GERMANY.COAL.2029  1350
  GERMANY.COAL.2030  1340
  GERMANY.COAL.2031  1330
  GERMANY.COAL.2032  1320
  GERMANY.COAL.2033  1310
  GERMANY.COAL.2034  1300
  GERMANY.COAL.2035  1290
  GERMANY.COAL.2036  1280
  GERMANY.COAL.2037  1270
  GERMANY.COAL.2038  1260
  GERMANY.COAL.2039  1250
  GERMANY.COAL.2040  1240
  GERMANY.COAL.2041  1230
  GERMANY.COAL.2042  1220
  GERMANY.COAL.2043  1210
  GERMANY.COAL.2044  1200
  GERMANY.COAL.2045  1200
  GERMANY.COAL.2046  1200
  GERMANY.COAL.2047  1200
  GERMANY.COAL.2048  1200  
  GERMANY.COAL.2049  1200
  GERMANY.COAL.2050  1200
  GERMANY.GASF.(2024*2050)  5000
  GERMANY.ROR.(2024*2050)  3000
  GERMANY.STOR_HYDRO.(2024*2050)  900
  GERMANY.HFO_GEN.(2024*2050)  1000
  GERMANY.IMPHFO1.(2024*2050)  0
  GERMANY.IMPHCO1.(2024*2050)  0
  GERMANY.IMPGAS1.(2024*2050)  0
  GERMANY.IHE.(2024*2050)  0 #IHE as a pure accounting technology
  GERMANY.IHG.(2024*2050)  0 #IHG as a pure accounting technology
  GERMANY.RIV.(2024*2050)  0 
  GERMANY.FEU.(2024*2050)  0 #FEU as a pure accounting technology
  GERMANY.GRID_ELC.(2024*2050)  0 
  GERMANY.GAS_PIPES.(2024*2050)  0
  /;

parameter VariableCost(r,t,m,y) /
  GERMANY.COAL.1.(2024*2050)  .3
  GERMANY.GASF.1.(2024*2050)  1.5
  GERMANY.HFO_GEN.1.(2024*2050)  .4
  GERMANY.IMPHFO1.1.(2024*2050)  10
  GERMANY.IMPHCO1.1.(2024*2050)  2
  GERMANY.IMPGAS1.1.(2024*2050)  2
  GERMANY.GRID_ELC.1.(2024*2050)  0
  GERMANY.GAS_PIPES.1.(2024*2050)  0
/;
VariableCost(r,t,m,y)$(VariableCost(r,t,m,y) = 0) = 1e-5;

parameter FixedCost /
  GERMANY.COAL.(2024*2050)  40
  GERMANY.GASF.(2024*2050)  500
  GERMANY.ROR.(2024*2050)  75
  GERMANY.STOR_HYDRO.(2024*2050)  30
  GERMANY.HFO_GEN.(2024*2050)  30
  GERMANY.IHG.(2024*2050)  0.00 #IHG as a pure accounting technology
  GERMANY.IHE.(2024*2050)  0.00 #IHE as a pure accounting technology
  GERMANY.FEU.(2024*2050)  0.00 #FEU as a pure accounting technology
  GERMANY.GRID_ELC.(2024*2050)  0.00 
  GERMANY.GAS_PIPES.(2024*2050)  0.00
/;


*------------------------------------------------------------------------	
* Parameters - Storage       
*------------------------------------------------------------------------

parameter TechnologyToStorage(r,m,t,s) /
  GERMANY.2.STOR_HYDRO.DAM  1
/;

parameter TechnologyFromStorage(r,m,t,s) /
  GERMANY.1.STOR_HYDRO.DAM  1
/;

StorageLevelStart(r,s) = 1;

StorageMaxChargeRate(r,s) = 99;

StorageMaxDischargeRate(r,s) = 99;

MinStorageCharge(r,s,y) = 0;

OperationalLifeStorage(r,s) = 99;

CapitalCostStorage(r,s,y) = 0;

ResidualStorageCapacity(r,s,y) = 999;



*------------------------------------------------------------------------	
* Parameters - Capacity and investment constraints       
*------------------------------------------------------------------------

CapacityOfOneTechnologyUnit(r,t,y) = 0;

parameter TotalAnnualMaxCapacity /
  GERMANY.ROR.2024  .1301
  GERMANY.ROR.2025  .1401
  GERMANY.ROR.2026  .1401
  GERMANY.ROR.2027  .1501
  GERMANY.ROR.2028  .1501
  GERMANY.ROR.2029  .1501
  GERMANY.ROR.2030  .1601
  GERMANY.ROR.2031  .1601
  GERMANY.ROR.2032  .1601
  GERMANY.ROR.2033  .1601
  GERMANY.ROR.2034  .1701
  GERMANY.ROR.2035  .201
  GERMANY.ROR.2036  .201
  GERMANY.ROR.2037  .201
  GERMANY.ROR.2038  .201
  GERMANY.ROR.2039  .201
  GERMANY.ROR.2040  .201
  GERMANY.ROR.2041  .201
  GERMANY.ROR.2042  .201
  GERMANY.ROR.2043  .201
  GERMANY.ROR.2044  .201  
  GERMANY.ROR.2045  .201
  GERMANY.ROR.2046  .201
  GERMANY.ROR.2047  .201
  GERMANY.ROR.2048  .201
  GERMANY.ROR.2049  .2101
  GERMANY.ROR.2050  .2101
  GERMANY.STOR_HYDRO.(2024*2050)  3
  GERMANY.IHE.2024  EPS
  GERMANY.IHE.2025  EPS
  GERMANY.IHE.2026  EPS
  GERMANY.IHE.2027  EPS
  GERMANY.IHE.2028  EPS
  GERMANY.IHE.2029  EPS
  GERMANY.IHE.2030  EPS
  GERMANY.IHE.2031  EPS
  GERMANY.IHE.2032  EPS
  GERMANY.IHE.2033  EPS
  GERMANY.IHE.2034  99999
  GERMANY.IHE.2035  99999
  GERMANY.IHE.2036  99999
  GERMANY.IHE.2037  99999
  GERMANY.IHE.2038  99999
  GERMANY.IHE.2039  99999
  GERMANY.IHE.2040  99999
  GERMANY.IHE.2041  99999
  GERMANY.IHE.2042  99999
  GERMANY.IHE.2043  99999
  GERMANY.IHE.2044  99999
  GERMANY.IHE.2045  99999
  GERMANY.IHE.2046  99999
  GERMANY.IHE.2047  99999
  GERMANY.IHE.2048  99999
  GERMANY.IHE.2049  99999
  GERMANY.IHE.2050  99999
/;
TotalAnnualMaxCapacity(r,t,y)$(TotalAnnualMaxCapacity(r,t,y) = 0) = 99999;
TotalAnnualMaxCapacity(r,'IHE','2024') = 0;

parameter TotalAnnualMinCapacity(r,t,y) /
  GERMANY.ROR.2024  .13
  GERMANY.ROR.2025  .14
  GERMANY.ROR.2026  .14
  GERMANY.ROR.2027  .15
  GERMANY.ROR.2028  .15
  GERMANY.ROR.2029  .15
  GERMANY.ROR.2030  .16
  GERMANY.ROR.2031  .16
  GERMANY.ROR.2032  .16
  GERMANY.ROR.2033  .16
  GERMANY.ROR.2034  .17
  GERMANY.ROR.2035  .2
  GERMANY.ROR.2036  .2
  GERMANY.ROR.2037  .2
  GERMANY.ROR.2038  .2
  GERMANY.ROR.2039  .2
  GERMANY.ROR.2040  .2
  GERMANY.ROR.2041  .2
  GERMANY.ROR.2042  .2
  GERMANY.ROR.2043  .2
  GERMANY.ROR.2044  .2
  GERMANY.ROR.2045  .2
  GERMANY.ROR.2046  .2  
  GERMANY.ROR.2047  .2
  GERMANY.ROR.2048  .2
  GERMANY.ROR.2049  .21
  GERMANY.ROR.2050  .21
/;

TotalAnnualMaxCapacityInvestment(r,t,y) = 99999;

TotalAnnualMinCapacityInvestment(r,t,y) = 0;


*------------------------------------------------------------------------	
* Parameters - Activity constraints       
*------------------------------------------------------------------------

TotalTechnologyAnnualActivityUpperLimit(r,t,y) = 99999;

TotalTechnologyAnnualActivityLowerLimit(r,t,y) = 0;

TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 99999;

TotalTechnologyModelPeriodActivityLowerLimit(r,t) = 0;


*------------------------------------------------------------------------	
* Parameters - Reserve margin
*-----------------------------------------------------------------------

parameter ReserveMarginTagTechnology(r,t,y) /
  GERMANY.COAL.(2024*2050)  1
  GERMANY.GASF.(2024*2050)  1
  GERMANY.ROR.(2024*2050)  1
  GERMANY.STOR_HYDRO.(2024*2050)  1
  GERMANY.HFO_GEN.(2024*2050)  1
/;

parameter ReserveMarginTagFuel(r,f,y) /
  GERMANY.ELC_GEN.(2024*2050)  1
/;

parameter ReserveMargin(r,y) /
  GERMANY.(2024*2050)  1.18
/;


*------------------------------------------------------------------------	
* Parameters - RE Generation Target       
*------------------------------------------------------------------------

RETagTechnology(r,t,y) = 0;

RETagFuel(r,f,y) = 0;

REMinProductionTarget(r,y) = 0;


*------------------------------------------------------------------------	
* Parameters - Emissions       
*------------------------------------------------------------------------

parameter EmissionActivityRatio(r,t,e,m,y) /
  GERMANY.IMPHFO1.CO2.1.(2024*2050)  .075
  GERMANY.IMPHCO1.CO2.1.(2024*2050)  .089
  GERMANY.IMPGAS1.CO2.1.(2024*2050)  .056 
/;

EmissionsPenalty(r,e,y) = 0;

AnnualExogenousEmission(r,e,y) = 0;

AnnualEmissionLimit(r,e,y) = 9999;

ModelPeriodExogenousEmission(r,e) = 0;

ModelPeriodEmissionLimit(r,e) = 9999;