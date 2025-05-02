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

set     YEAR    / 1990*2010 /;
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
        ELC 'Electricity'
        HCO 'Coal'
        HYD 'Hydro'
        GAS 'Gas'
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
  ID.(1990*2010)  .3333
  IN.(1990*2010)  .1667
  SD.(1990*2010)  .1667
  SN.(1990*2010)  .0833
  WD.(1990*2010)  .1667
  WN.(1990*2010)  .0833
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
  GERMANY.IH.1990  25.2
  GERMANY.IH.1991  26.46
  GERMANY.IH.1992  27.72
  GERMANY.IH.1993  28.98
  GERMANY.IH.1994  30.24
  GERMANY.IH.1995  31.5
  GERMANY.IH.1996  32.76
  GERMANY.IH.1997  34.02
  GERMANY.IH.1998  35.28
  GERMANY.IH.1999  36.54
  GERMANY.IH.2000  37.8
  GERMANY.IH.2001  39.69
  GERMANY.IH.2002  41.58
  GERMANY.IH.2003  43.47
  GERMANY.IH.2004  45.36
  GERMANY.IH.2005  47.25
  GERMANY.IH.2006  49.14
  GERMANY.IH.2007  51.03
  GERMANY.IH.2008  52.92
  GERMANY.IH.2009  54.81
  GERMANY.IH.2010  56.7
  GERMANY.ED.1990  5.6
  GERMANY.ED.1991  5.88
  GERMANY.ED.1992  6.16
  GERMANY.ED.1993  6.44
  GERMANY.ED.1994  6.72
  GERMANY.ED.1995  7
  GERMANY.ED.1996  7.28
  GERMANY.ED.1997  7.56
  GERMANY.ED.1998  7.84
  GERMANY.ED.1999  8.12
  GERMANY.ED.2000  8.4
  GERMANY.ED.2001  8.82
  GERMANY.ED.2002  9.24
  GERMANY.ED.2003  9.66
  GERMANY.ED.2004  10.08
  GERMANY.ED.2005  10.5
  GERMANY.ED.2006  10.92
  GERMANY.ED.2007  11.34
  GERMANY.ED.2008  11.76
  GERMANY.ED.2009  12.18
  GERMANY.ED.2010  12.6
/;

parameter SpecifiedDemandProfile(r,f,l,y) /
  GERMANY.IH.ID.(1990*2010)  .12
  GERMANY.IH.IN.(1990*2010)  .06
  GERMANY.IH.SD.(1990*2010)  0
  GERMANY.IH.SN.(1990*2010)  0
  GERMANY.IH.WD.(1990*2010)  .5467
  GERMANY.IH.WN.(1990*2010)  .2733
  GERMANY.ED.ID.(1990*2010)  .15
  GERMANY.ED.IN.(1990*2010)  .05
  GERMANY.ED.SD.(1990*2010)  .15
  GERMANY.ED.SN.(1990*2010)  .05
  GERMANY.ED.WD.(1990*2010)  .5
  GERMANY.ED.WN.(1990*2010)  .1
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
AvailabilityFactor(r,'HFO_GEN',y) = 0.8;
CapacityFactor(r,t,l,y)$(CapacityFactor(r,t,l,y) = 0) = 1;
AvailabilityFactor(r,t,y)$(AvailabilityFactor(r,t,y) = 0) = 1;


parameter OperationalLife(r,t) /
  GERMANY.COAL  40
  GERMANY.GASF  40
  GERMANY.ROR  100
  GERMANY.STOR_HYDRO  100
  GERMANY.HFO_GEN  40
  GERMANY.IHE  30
  GERMANY.IHG  30
  GERMANY.FEU  10
/;
OperationalLife(r,t)$(OperationalLife(r,t) = 0) = 1;

parameter ResidualCapacity(r,t,y) / #could be defined with a discount rate formulation
  GERMANY.COAL.1990  .5
  GERMANY.COAL.1991  .5
  GERMANY.COAL.1992  .5
  GERMANY.COAL.1993  .4
  GERMANY.COAL.1994  .4
  GERMANY.COAL.1995  .4
  GERMANY.COAL.1996  .4
  GERMANY.COAL.1997  .4
  GERMANY.COAL.1998  .4
  GERMANY.COAL.1999  .3
  GERMANY.COAL.2000  .3
  GERMANY.COAL.2001  .3
  GERMANY.COAL.2002  .3
  GERMANY.COAL.2003  .3
  GERMANY.COAL.2004  .3
  GERMANY.COAL.2005  .2
  GERMANY.COAL.2006  .2
  GERMANY.COAL.2007  .2
  GERMANY.COAL.2008  .2
  GERMANY.COAL.2009  .2
  GERMANY.COAL.2010  .15
  GERMANY.GASF.(1990*2010)  0
  GERMANY.ROR.(1990*2010)  .1
  GERMANY.STOR_HYDRO.(1990*2010)  .5
  GERMANY.HFO_GEN.1990  .3
  GERMANY.HFO_GEN.1991  .3
  GERMANY.HFO_GEN.1992  .29
  GERMANY.HFO_GEN.1993  .29
  GERMANY.HFO_GEN.1994  .28
  GERMANY.HFO_GEN.1995  .28
  GERMANY.HFO_GEN.1996  .27
  GERMANY.HFO_GEN.1997  .27
  GERMANY.HFO_GEN.1998  .26
  GERMANY.HFO_GEN.1999  .26
  GERMANY.HFO_GEN.2000  .25
  GERMANY.HFO_GEN.2001  .25
  GERMANY.HFO_GEN.2002  .24
  GERMANY.HFO_GEN.2003  .24
  GERMANY.HFO_GEN.2004  .23
  GERMANY.HFO_GEN.2005  .23
  GERMANY.HFO_GEN.2006  .22
  GERMANY.HFO_GEN.2007  .22
  GERMANY.HFO_GEN.2008  .21
  GERMANY.HFO_GEN.2009  .21
  GERMANY.HFO_GEN.2010  .2
  GERMANY.IHE.(1990*2010)  0
  GERMANY.IHG.1990  25
  GERMANY.IHG.1991  23.8
  GERMANY.IHG.1992  22.5
  GERMANY.IHG.1993  21.3
  GERMANY.IHG.1994  20
  GERMANY.IHG.1995  18.8
  GERMANY.IHG.1996  17.5
  GERMANY.IHG.1997  16.3
  GERMANY.IHG.1998  15
  GERMANY.IHG.1999  13.8
  GERMANY.IHG.2000  12.5
  GERMANY.IHG.2001  11.3
  GERMANY.IHG.2002  10
  GERMANY.IHG.2003  8.8
  GERMANY.IHG.2004  7.5
  GERMANY.IHG.2005  6.3
  GERMANY.IHG.2006  5
  GERMANY.IHG.2007  3.8
  GERMANY.IHG.2008  2.5
  GERMANY.IHG.2009  1.3
  GERMANY.IHG.2010  0
  GERMANY.FEU.1990  5.6
  GERMANY.FEU.1991  5
  GERMANY.FEU.1992  4.5
  GERMANY.FEU.1993  3.9
  GERMANY.FEU.1994  3.4
  GERMANY.FEU.1995  2.8
  GERMANY.FEU.1996  2.2
  GERMANY.FEU.1997  1.7
  GERMANY.FEU.1998  1.1
  GERMANY.FEU.1999  .6
  GERMANY.FEU.2000  0
  GERMANY.FEU.2001  0
  GERMANY.FEU.2002  0
  GERMANY.FEU.2003  0
  GERMANY.FEU.2004  0
  GERMANY.FEU.2005  0
  GERMANY.FEU.2006  0
  GERMANY.FEU.2007  0
  GERMANY.FEU.2008  0
  GERMANY.FEU.2009  0
  GERMANY.FEU.2010  0
/;
$if set no_initial_capacity ResidualCapacity(r,t,y) = 0;

parameter InputActivityRatio(r,t,f,m,y) /
  GERMANY.COAL.HCO.1.(1990*2010)  3.125
  GERMANY.GASF.GAS.1.(1990*2010)  3.5
  GERMANY.ROR.HYD.1.(1990*2010)  3.125
  GERMANY.STOR_HYDRO.ELC.2.(1990*2010)  1.3889
  GERMANY.HFO_GEN.HFO.1.(1990*2010)  3.4
  GERMANY.IHE.ELC.1.(1990*2010)  1
  GERMANY.IHG.HFO.1.(1990*2010)  1.428571
  GERMANY.FEU.ELC.1.(1990*2010)  1
/;

parameter OutputActivityRatio(r,t,f,m,y) /
  GERMANY.COAL.ELC.1.(1990*2010)  1
  GERMANY.GASF.ELC.1.(1990*2010)  1
  GERMANY.ROR.ELC.1.(1990*2010)  1
  GERMANY.STOR_HYDRO.ELC.1.(1990*2010)  1
  GERMANY.HFO_GEN.ELC.1.(1990*2010)  1
  GERMANY.IMPHFO1.HFO.1.(1990*2010)  1
  GERMANY.IMPHCO1.HCO.1.(1990*2010)  1
  GERMANY.IMPGAS1.GAS.1.(1990*2010)  1
  GERMANY.IHE.IH.1.(1990*2010)  1
  GERMANY.IHG.IH.1.(1990*2010)  1
  GERMANY.RIV.HYD.1.(1990*2010)  1
  GERMANY.FEU.ED.1.(1990*2010)  1
/;
# By default, assume for imported secondary fuels the same efficiency of the internal refineries
#InputActivityRatio(r,'IMPHFO1','OIL',m,y)$(not OutputActivityRatio(r,'SRE','HFO',m,y) eq 0) = 1/OutputActivityRatio(r,'SRE','HFO',m,y); 
#InputActivityRatio(r,'IMPGSL1','OIL',m,y)$(not OutputActivityRatio(r,'SRE','GSL',m,y) eq 0) = 1/OutputActivityRatio(r,'SRE','GSL',m,y); 

*------------------------------------------------------------------------	
* Parameters - Technology costs       
*------------------------------------------------------------------------

parameter CapitalCost(r,t,y) /
  GERMANY.COAL.1990  1400
  GERMANY.COAL.1991  1390
  GERMANY.COAL.1992  1380
  GERMANY.COAL.1993  1370
  GERMANY.COAL.1994  1360
  GERMANY.COAL.1995  1350
  GERMANY.COAL.1996  1340
  GERMANY.COAL.1997  1330
  GERMANY.COAL.1998  1320
  GERMANY.COAL.1999  1310
  GERMANY.COAL.2000  1300
  GERMANY.COAL.2001  1290
  GERMANY.COAL.2002  1280
  GERMANY.COAL.2003  1270
  GERMANY.COAL.2004  1260
  GERMANY.COAL.2005  1250
  GERMANY.COAL.2006  1240
  GERMANY.COAL.2007  1230
  GERMANY.COAL.2008  1220
  GERMANY.COAL.2009  1210
  GERMANY.COAL.2010  1200
  GERMANY.GASF.(1990*2010)  5000
  GERMANY.ROR.(1990*2010)  3000
  GERMANY.STOR_HYDRO.(1990*2010)  900
  GERMANY.HFO_GEN.(1990*2010)  1000
  GERMANY.IMPHFO1.(1990*2010)  0
  GERMANY.IMPHCO1.(1990*2010)  0
  GERMANY.IMPGAS1.(1990*2010)  0
  GERMANY.IHE.(1990*2010)  90
  GERMANY.IHG.(1990*2010)  100
  GERMANY.RIV.(1990*2010)  0
  GERMANY.FEU.(1990*2010)  0
  /;

parameter VariableCost(r,t,m,y) /
  GERMANY.COAL.1.(1990*2010)  .3
  GERMANY.GASF.1.(1990*2010)  1.5
  GERMANY.HFO_GEN.1.(1990*2010)  .4
  GERMANY.IMPHFO1.1.(1990*2010)  10
  GERMANY.IMPHCO1.1.(1990*2010)  2
  GERMANY.IMPGAS1.1.(1990*2010)  2
/;
VariableCost(r,t,m,y)$(VariableCost(r,t,m,y) = 0) = 1e-5;

parameter FixedCost /
  GERMANY.COAL.(1990*2010)  40
  GERMANY.GASF.(1990*2010)  500
  GERMANY.ROR.(1990*2010)  75
  GERMANY.STOR_HYDRO.(1990*2010)  30
  GERMANY.HFO_GEN.(1990*2010)  30
  GERMANY.IHG.(1990*2010)  1
  GERMANY.FEU.(1990*2010)  9.46
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
  GERMANY.ROR.1990  .1301
  GERMANY.ROR.1991  .1401
  GERMANY.ROR.1992  .1401
  GERMANY.ROR.1993  .1501
  GERMANY.ROR.1994  .1501
  GERMANY.ROR.1995  .1501
  GERMANY.ROR.1996  .1601
  GERMANY.ROR.1997  .1601
  GERMANY.ROR.1998  .1601
  GERMANY.ROR.1999  .1601
  GERMANY.ROR.2000  .1701
  GERMANY.ROR.2001  .201
  GERMANY.ROR.2002  .201
  GERMANY.ROR.2003  .201
  GERMANY.ROR.2004  .201
  GERMANY.ROR.2005  .201
  GERMANY.ROR.2006  .201
  GERMANY.ROR.2007  .201
  GERMANY.ROR.2008  .201
  GERMANY.ROR.2009  .201
  GERMANY.ROR.2010  .2101
  GERMANY.STOR_HYDRO.(1990*2010)  3
  GERMANY.IHE.1990  EPS
  GERMANY.IHE.1991  EPS
  GERMANY.IHE.1992  EPS
  GERMANY.IHE.1993  EPS
  GERMANY.IHE.1994  EPS
  GERMANY.IHE.1995  EPS
  GERMANY.IHE.1996  EPS
  GERMANY.IHE.1997  EPS
  GERMANY.IHE.1998  EPS
  GERMANY.IHE.1999  EPS
  GERMANY.IHE.2000  99999
  GERMANY.IHE.2001  99999
  GERMANY.IHE.2002  99999
  GERMANY.IHE.2003  99999
  GERMANY.IHE.2004  99999
  GERMANY.IHE.2005  99999
  GERMANY.IHE.2006  99999
  GERMANY.IHE.2007  99999
  GERMANY.IHE.2008  99999
  GERMANY.IHE.2009  99999
  GERMANY.IHE.2010  99999
/;
TotalAnnualMaxCapacity(r,t,y)$(TotalAnnualMaxCapacity(r,t,y) = 0) = 99999;
TotalAnnualMaxCapacity(r,'IHE','1990') = 0;

parameter TotalAnnualMinCapacity(r,t,y) /
  GERMANY.ROR.1990  .13
  GERMANY.ROR.1991  .14
  GERMANY.ROR.1992  .14
  GERMANY.ROR.1993  .15
  GERMANY.ROR.1994  .15
  GERMANY.ROR.1995  .15
  GERMANY.ROR.1996  .16
  GERMANY.ROR.1997  .16
  GERMANY.ROR.1998  .16
  GERMANY.ROR.1999  .16
  GERMANY.ROR.2000  .17
  GERMANY.ROR.2001  .2
  GERMANY.ROR.2002  .2
  GERMANY.ROR.2003  .2
  GERMANY.ROR.2004  .2
  GERMANY.ROR.2005  .2
  GERMANY.ROR.2006  .2
  GERMANY.ROR.2007  .2
  GERMANY.ROR.2008  .2
  GERMANY.ROR.2009  .2
  GERMANY.ROR.2010  .21
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
  GERMANY.COAL.(1990*2010)  1
  GERMANY.GASF.(1990*2010)  1
  GERMANY.ROR.(1990*2010)  1
  GERMANY.STOR_HYDRO.(1990*2010)  1
  GERMANY.HFO_GEN.(1990*2010)  1
/;

parameter ReserveMarginTagFuel(r,f,y) /
  GERMANY.ELC.(1990*2010)  1
/;

parameter ReserveMargin(r,y) /
  GERMANY.(1990*2010)  1.18
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
  GERMANY.IMPHFO1.CO2.1.(1990*2010)  .075
  GERMANY.IMPHCO1.CO2.1.(1990*2010)  .089
/;

EmissionsPenalty(r,e,y) = 0;

AnnualExogenousEmission(r,e,y) = 0;

AnnualEmissionLimit(r,e,y) = 9999;

ModelPeriodExogenousEmission(r,e) = 0;

ModelPeriodEmissionLimit(r,e) = 9999;