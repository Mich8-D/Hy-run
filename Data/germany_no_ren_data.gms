* GERMANY_DATA.GMS - specify GERMANY Model data in format required by GAMS
*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble.Noble-Soft Systems - August 2012
* OSEMOSYS 2016.08.01 update by Thorsten Burandt, Konstantin L�ffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
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
        NUCLEAR 'Nuclear power plants'
        ROR 'run-of-river hydroelectric power plants'
        STOR_HYDRO 'Pumped storage'
        DIESEL_GEN 'Diesel power plants'
        IMPDSL1 'Diesel imports'
        IMPGSL1 'Gasoline imports'
        IMPHCO1 'Coal imports'
        IMPOIL1 'Crude oil imports'
        IMPURN1 'Uranium imports'
        RHE 'Residential heaters - electric'
        RHO 'Residential heaters - oil'
        RL1 'Residential light bulbs'
        SRE 'Crude oil refinery'
        TXD 'Personal vehicles - diesel'
        TXE 'Personal vehicles - electric'
        TXG 'Personal vehicles - gasoline'
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
        DSL 'Diesel'
        ELC 'Electricity'
        GSL 'Gasoline'
        HCO 'Coal'
        HYD 'Hydro'
        OIL 'Crude oil'
        URN 'Uranium'
        RH 'Demand for residential heating'
        RL 'Demand for residential lighting'
        TX 'Demand for personal transport'
/;

set     EMISSION        / CO2, NOX /;
set     MODE_OF_OPERATION       / 1, 2 /;
set     REGION  / GERMANY /;
set     SEASON / 1, 2, 3 /;
set     DAYTYPE / 1 /;
set     DAILYTIMEBRACKET / 1, 2 /;
set     STORAGE / DAM /;

# characterize technologies
set power_plants(TECHNOLOGY) / COAL, NUCLEAR, ROR, DIESEL_GEN /;
set storage_plants(TECHNOLOGY) / STOR_HYDRO /;
set fuel_transformation(TECHNOLOGY) / SRE /;
set appliances(TECHNOLOGY) / RHE, RHO, RL1, TXD, TXE, TXG /;
set unmet_demand(TECHNOLOGY) / /;
set transport(TECHNOLOGY) / TXD, TXE, TXG /;
set primary_imports(TECHNOLOGY) / IMPHCO1, IMPOIL1, IMPURN1 /;
set secondary_imports(TECHNOLOGY) / IMPDSL1, IMPGSL1 /;

set renewable_tech(TECHNOLOGY) /ROR/; 
set renewable_fuel(FUEL) /HYD/; 

set fuel_production(TECHNOLOGY);
set fuel_production_fict(TECHNOLOGY) /RIV/;
set secondary_production(TECHNOLOGY) /COAL, NUCLEAR, ROR, STOR_HYDRO, DIESEL_GEN, SRE/;

# Characterize fuels 
set primary_fuel(FUEL) / HCO, OIL, URN, HYD /;
set secondary_carrier(FUEL) / DSL, GSL, ELC /;
set final_demand(FUEL) / RH, RL, TX /;

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
  GERMANY.RH.1990  25.2
  GERMANY.RH.1991  26.46
  GERMANY.RH.1992  27.72
  GERMANY.RH.1993  28.98
  GERMANY.RH.1994  30.24
  GERMANY.RH.1995  31.5
  GERMANY.RH.1996  32.76
  GERMANY.RH.1997  34.02
  GERMANY.RH.1998  35.28
  GERMANY.RH.1999  36.54
  GERMANY.RH.2000  37.8
  GERMANY.RH.2001  39.69
  GERMANY.RH.2002  41.58
  GERMANY.RH.2003  43.47
  GERMANY.RH.2004  45.36
  GERMANY.RH.2005  47.25
  GERMANY.RH.2006  49.14
  GERMANY.RH.2007  51.03
  GERMANY.RH.2008  52.92
  GERMANY.RH.2009  54.81
  GERMANY.RH.2010  56.7
  GERMANY.RL.1990  5.6
  GERMANY.RL.1991  5.88
  GERMANY.RL.1992  6.16
  GERMANY.RL.1993  6.44
  GERMANY.RL.1994  6.72
  GERMANY.RL.1995  7
  GERMANY.RL.1996  7.28
  GERMANY.RL.1997  7.56
  GERMANY.RL.1998  7.84
  GERMANY.RL.1999  8.12
  GERMANY.RL.2000  8.4
  GERMANY.RL.2001  8.82
  GERMANY.RL.2002  9.24
  GERMANY.RL.2003  9.66
  GERMANY.RL.2004  10.08
  GERMANY.RL.2005  10.5
  GERMANY.RL.2006  10.92
  GERMANY.RL.2007  11.34
  GERMANY.RL.2008  11.76
  GERMANY.RL.2009  12.18
  GERMANY.RL.2010  12.6
/;

parameter SpecifiedDemandProfile(r,f,l,y) /
  GERMANY.RH.ID.(1990*2010)  .12
  GERMANY.RH.IN.(1990*2010)  .06
  GERMANY.RH.SD.(1990*2010)  0
  GERMANY.RH.SN.(1990*2010)  0
  GERMANY.RH.WD.(1990*2010)  .5467
  GERMANY.RH.WN.(1990*2010)  .2733
  GERMANY.RL.ID.(1990*2010)  .15
  GERMANY.RL.IN.(1990*2010)  .05
  GERMANY.RL.SD.(1990*2010)  .15
  GERMANY.RL.SN.(1990*2010)  .05
  GERMANY.RL.WD.(1990*2010)  .5
  GERMANY.RL.WN.(1990*2010)  .1
/;

parameter AccumulatedAnnualDemand(r,f,y) /
  GERMANY.TX.1990  5.2
  GERMANY.TX.1991  5.46
  GERMANY.TX.1992  5.72
  GERMANY.TX.1993  5.98
  GERMANY.TX.1994  6.24
  GERMANY.TX.1995  6.5
  GERMANY.TX.1996  6.76
  GERMANY.TX.1997  7.02
  GERMANY.TX.1998  7.28
  GERMANY.TX.1999  7.54
  GERMANY.TX.2000  7.8
  GERMANY.TX.2001  8.189
  GERMANY.TX.2002  8.578
  GERMANY.TX.2003  8.967
  GERMANY.TX.2004  9.356
  GERMANY.TX.2005  9.745
  GERMANY.TX.2006  10.134
  GERMANY.TX.2007  10.523
  GERMANY.TX.2008  10.912
  GERMANY.TX.2009  11.301
  GERMANY.TX.2010  11.69
/;

*------------------------------------------------------------------------	
* Parameters - Performance       
*------------------------------------------------------------------------

CapacityToActivityUnit(r,t)$power_plants(t) = 31.536; #check to understand unit of measurement 

CapacityToActivityUnit(r,t)$(CapacityToActivityUnit(r,t) = 0) = 1;

AvailabilityFactor(r,'COAL',y) = 0.8;
AvailabilityFactor(r,'NUCLEAR',y) = 0.9;
CapacityFactor(r,'ROR',l,y) = 0.27;
CapacityFactor(r,'STOR_HYDRO',"ID",y) = 0.7;
CapacityFactor(r,'STOR_HYDRO',"IN",y) = 0.7;
CapacityFactor(r,'STOR_HYDRO',"SD",y) = 0.3;
CapacityFactor(r,'STOR_HYDRO',"SN",y) = 0.3;
CapacityFactor(r,'STOR_HYDRO',"WD",y) = 0.5;
CapacityFactor(r,'STOR_HYDRO',"WN",y) = 0.5;
AvailabilityFactor(r,'DIESEL_GEN',y) = 0.8;
CapacityFactor(r,t,l,y)$(CapacityFactor(r,t,l,y) = 0) = 1;
AvailabilityFactor(r,t,y)$(AvailabilityFactor(r,t,y) = 0) = 1;


parameter OperationalLife(r,t) /
  GERMANY.COAL  40
  GERMANY.NUCLEAR  40
  GERMANY.ROR  100
  GERMANY.STOR_HYDRO  100
  GERMANY.DIESEL_GEN  40
  GERMANY.RHE  30
  GERMANY.RHO  30
  GERMANY.RL1  10
  GERMANY.SRE  50
  GERMANY.TXD  15
  GERMANY.TXE  15
  GERMANY.TXG  15
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
  GERMANY.NUCLEAR.(1990*2010)  0
  GERMANY.ROR.(1990*2010)  .1
  GERMANY.STOR_HYDRO.(1990*2010)  .5
  GERMANY.DIESEL_GEN.1990  .3
  GERMANY.DIESEL_GEN.1991  .3
  GERMANY.DIESEL_GEN.1992  .29
  GERMANY.DIESEL_GEN.1993  .29
  GERMANY.DIESEL_GEN.1994  .28
  GERMANY.DIESEL_GEN.1995  .28
  GERMANY.DIESEL_GEN.1996  .27
  GERMANY.DIESEL_GEN.1997  .27
  GERMANY.DIESEL_GEN.1998  .26
  GERMANY.DIESEL_GEN.1999  .26
  GERMANY.DIESEL_GEN.2000  .25
  GERMANY.DIESEL_GEN.2001  .25
  GERMANY.DIESEL_GEN.2002  .24
  GERMANY.DIESEL_GEN.2003  .24
  GERMANY.DIESEL_GEN.2004  .23
  GERMANY.DIESEL_GEN.2005  .23
  GERMANY.DIESEL_GEN.2006  .22
  GERMANY.DIESEL_GEN.2007  .22
  GERMANY.DIESEL_GEN.2008  .21
  GERMANY.DIESEL_GEN.2009  .21
  GERMANY.DIESEL_GEN.2010  .2
  GERMANY.RHE.(1990*2010)  0
  GERMANY.RHO.1990  25
  GERMANY.RHO.1991  23.8
  GERMANY.RHO.1992  22.5
  GERMANY.RHO.1993  21.3
  GERMANY.RHO.1994  20
  GERMANY.RHO.1995  18.8
  GERMANY.RHO.1996  17.5
  GERMANY.RHO.1997  16.3
  GERMANY.RHO.1998  15
  GERMANY.RHO.1999  13.8
  GERMANY.RHO.2000  12.5
  GERMANY.RHO.2001  11.3
  GERMANY.RHO.2002  10
  GERMANY.RHO.2003  8.8
  GERMANY.RHO.2004  7.5
  GERMANY.RHO.2005  6.3
  GERMANY.RHO.2006  5
  GERMANY.RHO.2007  3.8
  GERMANY.RHO.2008  2.5
  GERMANY.RHO.2009  1.3
  GERMANY.RHO.2010  0
  GERMANY.RL1.1990  5.6
  GERMANY.RL1.1991  5
  GERMANY.RL1.1992  4.5
  GERMANY.RL1.1993  3.9
  GERMANY.RL1.1994  3.4
  GERMANY.RL1.1995  2.8
  GERMANY.RL1.1996  2.2
  GERMANY.RL1.1997  1.7
  GERMANY.RL1.1998  1.1
  GERMANY.RL1.1999  .6
  GERMANY.RL1.2000  0
  GERMANY.RL1.2001  0
  GERMANY.RL1.2002  0
  GERMANY.RL1.2003  0
  GERMANY.RL1.2004  0
  GERMANY.RL1.2005  0
  GERMANY.RL1.2006  0
  GERMANY.RL1.2007  0
  GERMANY.RL1.2008  0
  GERMANY.RL1.2009  0
  GERMANY.RL1.2010  0
  GERMANY.TXD.1990  .6
  GERMANY.TXD.1991  .6
  GERMANY.TXD.1992  .5
  GERMANY.TXD.1993  .5
  GERMANY.TXD.1994  .4
  GERMANY.TXD.1995  .4
  GERMANY.TXD.1996  .4
  GERMANY.TXD.1997  .3
  GERMANY.TXD.1998  .3
  GERMANY.TXD.1999  .2
  GERMANY.TXD.2000  .2
  GERMANY.TXD.2001  .2
  GERMANY.TXD.2002  .2
  GERMANY.TXD.2003  .1
  GERMANY.TXD.2004  .1
  GERMANY.TXD.2005  .1
  GERMANY.TXD.2006  .1
  GERMANY.TXD.2007  .1
  GERMANY.TXD.2008  0
  GERMANY.TXD.2009  0
  GERMANY.TXD.2010  0
/;
$if set no_initial_capacity ResidualCapacity(r,t,y) = 0;

parameter InputActivityRatio(r,t,f,m,y) /
  GERMANY.COAL.HCO.1.(1990*2010)  3.125
  GERMANY.NUCLEAR.URN.1.(1990*2010)  3.5
  GERMANY.ROR.HYD.1.(1990*2010)  3.125
  GERMANY.STOR_HYDRO.ELC.2.(1990*2010)  1.3889
  GERMANY.DIESEL_GEN.DSL.1.(1990*2010)  3.4
  GERMANY.RHE.ELC.1.(1990*2010)  1
  GERMANY.RHO.DSL.1.(1990*2010)  1.428571
  GERMANY.RL1.ELC.1.(1990*2010)  1
  GERMANY.SRE.OIL.1.(1990*2010)  1
  GERMANY.TXD.DSL.1.(1990*2010)  1
  GERMANY.TXE.ELC.1.(1990*2010)  1
  GERMANY.TXG.GSL.1.(1990*2010)  1
/;

parameter OutputActivityRatio(r,t,f,m,y) /
  GERMANY.COAL.ELC.1.(1990*2010)  1
  GERMANY.NUCLEAR.ELC.1.(1990*2010)  1
  GERMANY.ROR.ELC.1.(1990*2010)  1
  GERMANY.STOR_HYDRO.ELC.1.(1990*2010)  1
  GERMANY.DIESEL_GEN.ELC.1.(1990*2010)  1
  GERMANY.IMPDSL1.DSL.1.(1990*2010)  1
  GERMANY.IMPGSL1.GSL.1.(1990*2010)  1
  GERMANY.IMPHCO1.HCO.1.(1990*2010)  1
  GERMANY.IMPOIL1.OIL.1.(1990*2010)  1
  GERMANY.IMPURN1.URN.1.(1990*2010)  1
  GERMANY.RHE.RH.1.(1990*2010)  1
  GERMANY.RHO.RH.1.(1990*2010)  1
  GERMANY.RIV.HYD.1.(1990*2010)  1
  GERMANY.RL1.RL.1.(1990*2010)  1
  GERMANY.SRE.DSL.1.(1990*2010)  .7
  GERMANY.SRE.GSL.1.(1990*2010)  .3
  GERMANY.TXD.TX.1.(1990*2010)  1
  GERMANY.TXE.TX.1.(1990*2010)  1
  GERMANY.TXG.TX.1.(1990*2010)  1
/;

# By default, assume for imported secondary fuels the same efficiency of the internal refineries
InputActivityRatio(r,'IMPDSL1','OIL',m,y)$(not OutputActivityRatio(r,'SRE','DSL',m,y) eq 0) = 1/OutputActivityRatio(r,'SRE','DSL',m,y); 
InputActivityRatio(r,'IMPGSL1','OIL',m,y)$(not OutputActivityRatio(r,'SRE','GSL',m,y) eq 0) = 1/OutputActivityRatio(r,'SRE','GSL',m,y); 

*------------------------------------------------------------------------	
* Parameters - Technology costs       
*------------------------------------------------------------------------

parameter CapitalCost /
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
  GERMANY.NUCLEAR.(1990*2010)  5000
  GERMANY.ROR.(1990*2010)  3000
  GERMANY.STOR_HYDRO.(1990*2010)  900
  GERMANY.DIESEL_GEN.(1990*2010)  1000
  GERMANY.IMPDSL1.(1990*2010)  0
  GERMANY.IMPGSL1.(1990*2010)  0
  GERMANY.IMPHCO1.(1990*2010)  0
  GERMANY.IMPOIL1.(1990*2010)  0
  GERMANY.IMPURN1.(1990*2010)  0
  GERMANY.RHE.(1990*2010)  90
  GERMANY.RHO.(1990*2010)  100
  GERMANY.RIV.(1990*2010)  0
  GERMANY.RL1.(1990*2010)  0
  GERMANY.SRE.(1990*2010)  100
  GERMANY.TXD.(1990*2010)  1044
  GERMANY.TXE.1990  2000
  GERMANY.TXE.1991  1975
  GERMANY.TXE.1992  1950
  GERMANY.TXE.1993  1925
  GERMANY.TXE.1994  1900
  GERMANY.TXE.1995  1875
  GERMANY.TXE.1996  1850
  GERMANY.TXE.1997  1825
  GERMANY.TXE.1998  1800
  GERMANY.TXE.1999  1775
  GERMANY.TXE.2000  1750
  GERMANY.TXE.2001  1725
  GERMANY.TXE.2002  1700
  GERMANY.TXE.2003  1675
  GERMANY.TXE.2004  1650
  GERMANY.TXE.2005  1625
  GERMANY.TXE.2006  1600
  GERMANY.TXE.2007  1575
  GERMANY.TXE.2008  1550
  GERMANY.TXE.2009  1525
  GERMANY.TXE.2010  1500
  GERMANY.TXG.(1990*2010)  1044
/;

parameter VariableCost(r,t,m,y) /
  GERMANY.COAL.1.(1990*2010)  .3
  GERMANY.NUCLEAR.1.(1990*2010)  1.5
  GERMANY.DIESEL_GEN.1.(1990*2010)  .4
  GERMANY.IMPDSL1.1.(1990*2010)  10
  GERMANY.IMPGSL1.1.(1990*2010)  15
  GERMANY.IMPHCO1.1.(1990*2010)  2
  GERMANY.IMPOIL1.1.(1990*2010)  8
  GERMANY.IMPURN1.1.(1990*2010)  2
  GERMANY.SRE.1.(1990*2010)  10
/;
VariableCost(r,t,m,y)$(VariableCost(r,t,m,y) = 0) = 1e-5;

parameter FixedCost /
  GERMANY.COAL.(1990*2010)  40
  GERMANY.NUCLEAR.(1990*2010)  500
  GERMANY.ROR.(1990*2010)  75
  GERMANY.STOR_HYDRO.(1990*2010)  30
  GERMANY.DIESEL_GEN.(1990*2010)  30
  GERMANY.RHO.(1990*2010)  1
  GERMANY.RL1.(1990*2010)  9.46
  GERMANY.TXD.(1990*2010)  52
  GERMANY.TXE.(1990*2010)  100
  GERMANY.TXG.(1990*2010)  48
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
  GERMANY.RHE.1990  EPS
  GERMANY.RHE.1991  EPS
  GERMANY.RHE.1992  EPS
  GERMANY.RHE.1993  EPS
  GERMANY.RHE.1994  EPS
  GERMANY.RHE.1995  EPS
  GERMANY.RHE.1996  EPS
  GERMANY.RHE.1997  EPS
  GERMANY.RHE.1998  EPS
  GERMANY.RHE.1999  EPS
  GERMANY.RHE.2000  99999
  GERMANY.RHE.2001  99999
  GERMANY.RHE.2002  99999
  GERMANY.RHE.2003  99999
  GERMANY.RHE.2004  99999
  GERMANY.RHE.2005  99999
  GERMANY.RHE.2006  99999
  GERMANY.RHE.2007  99999
  GERMANY.RHE.2008  99999
  GERMANY.RHE.2009  99999
  GERMANY.RHE.2010  99999
  GERMANY.SRE.1990  .1001
  GERMANY.SRE.1991  .1001
  GERMANY.SRE.1992  .1001
  GERMANY.SRE.1993  .1001
  GERMANY.SRE.1994  .1001
  GERMANY.SRE.1995  .1001
  GERMANY.SRE.1996  .1001
  GERMANY.SRE.1997  .1001
  GERMANY.SRE.1998  .1001
  GERMANY.SRE.1999  .1001
  GERMANY.SRE.2000  99999
  GERMANY.SRE.2001  99999
  GERMANY.SRE.2002  99999
  GERMANY.SRE.2003  99999
  GERMANY.SRE.2004  99999
  GERMANY.SRE.2005  99999
  GERMANY.SRE.2006  99999
  GERMANY.SRE.2007  99999
  GERMANY.SRE.2008  99999
  GERMANY.SRE.2009  99999
  GERMANY.SRE.2010  99999
  GERMANY.TXE.1990  EPS
  GERMANY.TXE.1991  .4
  GERMANY.TXE.1992  .8
  GERMANY.TXE.1993  1.2
  GERMANY.TXE.1994  1.6
  GERMANY.TXE.1995  2
  GERMANY.TXE.1996  2.4
  GERMANY.TXE.1997  2.8
  GERMANY.TXE.1998  3.2
  GERMANY.TXE.1999  3.6
  GERMANY.TXE.2000  4
  GERMANY.TXE.2001  4.6
  GERMANY.TXE.2002  5.2
  GERMANY.TXE.2003  5.8
  GERMANY.TXE.2004  6.4
  GERMANY.TXE.2005  7
  GERMANY.TXE.2006  7.6
  GERMANY.TXE.2007  8.2
  GERMANY.TXE.2008  8.8
  GERMANY.TXE.2009  9.4
  GERMANY.TXE.2010  10
/;
TotalAnnualMaxCapacity(r,t,y)$(TotalAnnualMaxCapacity(r,t,y) = 0) = 99999;
TotalAnnualMaxCapacity(r,'TXE','1990') = 0;
TotalAnnualMaxCapacity(r,'RHE','1990') = 0;

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
  GERMANY.SRE.1990  .1
  GERMANY.SRE.1991  .1
  GERMANY.SRE.1992  .1
  GERMANY.SRE.1993  .1
  GERMANY.SRE.1994  .1
  GERMANY.SRE.1995  .1
  GERMANY.SRE.1996  .1
  GERMANY.SRE.1997  .1
  GERMANY.SRE.1998  .1
  GERMANY.SRE.1999  .1
  GERMANY.SRE.2000  0
  GERMANY.SRE.2001  0
  GERMANY.SRE.2002  0
  GERMANY.SRE.2003  0
  GERMANY.SRE.2004  0
  GERMANY.SRE.2005  0
  GERMANY.SRE.2006  0
  GERMANY.SRE.2007  0
  GERMANY.SRE.2008  0
  GERMANY.SRE.2009  0
  GERMANY.SRE.2010  0
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
  GERMANY.NUCLEAR.(1990*2010)  1
  GERMANY.ROR.(1990*2010)  1
  GERMANY.STOR_HYDRO.(1990*2010)  1
  GERMANY.DIESEL_GEN.(1990*2010)  1
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
  GERMANY.IMPDSL1.CO2.1.(1990*2010)  .075
  GERMANY.IMPGSL1.CO2.1.(1990*2010)  .075
  GERMANY.IMPHCO1.CO2.1.(1990*2010)  .089
  GERMANY.IMPOIL1.CO2.1.(1990*2010)  .075
  GERMANY.TXD.NOX.1.(1990*2010)  1
  GERMANY.TXG.NOX.1.(1990*2010)  1
/;

EmissionsPenalty(r,e,y) = 0;

AnnualExogenousEmission(r,e,y) = 0;

AnnualEmissionLimit(r,e,y) = 9999;

ModelPeriodExogenousEmission(r,e) = 0;

ModelPeriodEmissionLimit(r,e) = 9999;