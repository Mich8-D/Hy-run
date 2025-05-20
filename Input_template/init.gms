$set phase %1

**------------------------------------------------------------------------	
$ifthen.ph %phase%=='pre'

*------------------------------------------------------------------------	
* Parameters - Global
*------------------------------------------------------------------------

parameter YearSplit(l,y) /
  ID.(%yearstart%*%yearend%)  .3333
  IN.(%yearstart%*%yearend%)  .1666
  SD.(%yearstart%*%yearend%)  .1666
  SN.(%yearstart%*%yearend%)  .0833
  WD.(%yearstart%*%yearend%)  .1666
  WN.(%yearstart%*%yearend%)  .0833
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

DaysInDayType(y,ls,ld) = 7;

TradeRoute(r,rr,f,y) = 0;

DepreciationMethod(r) = 1;

*------------------------------------------------------------------------	
* Parameters - Storage       
*------------------------------------------------------------------------

StorageLevelStart(r,s) = 1;

StorageMaxChargeRate(r,s) = 200;

StorageMaxDischargeRate(r,s) = 200;

MinStorageCharge(r,s,y) = 0;

OperationalLifeStorage(r,s) = 99;

CapitalCostStorage(r,s,y) = 0;

ResidualStorageCapacity(r,s,y) = 0;

TotalAnnualMaxStorageCapacity(r,s,y) = 99999;

TotalAnnualMaxStorageCapacityInvestment(r,s,y) = 99999;

TotalAnnualMinStorageCapacityInvestment(r,s,y) = 0;

TotalAnnualMinStorageCapacity(r,s,y) = 0;

*------------------------------------------------------------------------	
* Parameters - Capacity and investment constraints       
*------------------------------------------------------------------------

CapacityOfOneTechnologyUnit(r,t,y) = 0;

TotalAnnualMaxCapacity(r,t,y) = 99999;

TotalAnnualMaxCapacityInvestment(r,t,y) = 50;

TotalAnnualMinCapacityInvestment(r,t,y) = 0;

TotalAnnualMinCapacity(r,t,y) = 0;

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

ReserveMargin(r,y) = 1.18;

*------------------------------------------------------------------------	
* Parameters - RE Generation Target       
*------------------------------------------------------------------------

RETagTechnology(r,t,y) = 0;

RETagFuel(r,f,y) = 0;

REMinProductionTarget(r,y) = 0;


*------------------------------------------------------------------------	
* Parameters - Emissions       
*------------------------------------------------------------------------

EmissionsPenalty(r,e,y) = 0;

AnnualExogenousEmission(r,e,y) = 0;

AnnualEmissionLimit(r,e,y) = 9999;

ModelPeriodExogenousEmission(r,e) = 0;

ModelPeriodEmissionLimit(r,e) = 9999;

*------------------------------------------------------------------------

Scalar PowerToEnergyConversion / 0.0036 /;  # PJ per GW-hour


****** POST-DATA POPULATION 

$elseif.ph %phase%=='post'

VariableCost(r,t,m,y)$(VariableCost(r,t,m,y) = 0) = 1e-5;

ContinousDepreciation(r,t)$(OperationalLife(r,t) <> 0) = 1 - exp( 1 / ( - OperationalLife(r,t) + (0.01/2) * OperationalLife(r,t)**2) ); 

ContinousDepreciation(r,t)$(OperationalLife(r,t) = 0) = 1; 

ContinousDepreciation(r,t)$(ContinousDepreciation(r,t) < 0) = 0; 

ContinousDepreciation(r,t)$(ContinousDepreciation(r,t) > 1) = 1; 

ContinousDepreciation(r,t) = 0;

*** define the renewable technology and fuel tags

RETagTechnology(r,t,y)$(storage_plants(t)) = 1;

RETagTechnology(r,t,y)$renewable_tech(t) = 1;

RETagFuel(r,'ELC',y) = 1;


ReserveMarginTagTechnology(r,t,y)$(not renewable_tech(t)) = 1;
ReserveMarginTagTechnology(r,'BIO',y) = 1;
ReserveMarginTagTechnology(r,'GEO',y) = 1;
ReserveMarginTagTechnology(r,'FC_UHS',y) = 1;
ReserveMarginTagTechnology(r,'FC_TANKS',y) = 1;
ReserveMarginTagTechnology(r,'STOR_HYDRO',y) = 1;
ReserveMarginTagTechnology(r,'BEES',y) = 1;



*------------------------------------------------------------------------	
* COST SCALING      
*------------------------------------------------------------------------

scalar cost_scaling /1000/;

CapitalCost(r,t,y)          = CapitalCost(r,t,y) / cost_scaling;
CapitalCostStorage(r,s,y)   = CapitalCostStorage(r,s,y) / cost_scaling;
FixedCost(r,t,y)            = FixedCost(r,t,y) / cost_scaling;
VariableCost(r,t,m,y)       = VariableCost(r,t,m,y) / cost_scaling;

*------------------------------------------------------------------------
*No investments in year 0
*------------------------------------------------------------------------

TotalAnnualMaxCapacityInvestment(r,'WPP_ON','2024') = 0;
TotalAnnualMaxCapacityInvestment(r,'WPP_OFF','2024') = 0; 
TotalAnnualMaxCapacityInvestment(r,'BIO','2024') = 0;
TotalAnnualMaxCapacityInvestment(r,'GEO','2024') = 0;
TotalAnnualMaxCapacityInvestment(r,'ROR','2024') = 0;
TotalAnnualMaxCapacityInvestment(r,'GFPP','2024') = 0;
TotalAnnualMaxCapacityInvestment(r,'OIL_GEN','2024') = 0;

*------------------------------------------------------------------------	
* Parameters - Performance       
*------------------------------------------------------------------------

$if set no_initial_capacity ResidualCapacity(r,t,y) = 0;

CapacityToActivityUnit(r,t)$power_plants(t) = 31.536;

CapacityToActivityUnit(r,t)$(fuel_transmission(t)) = 31.536;

CapacityToActivityUnit(r,t)$(storage_plants(t)) = 31.536;

CapacityToActivityUnit(r,t)$hydrogen_tech(t) = 31.536;

CapacityToActivityUnit(r,t)$(CapacityToActivityUnit(r,t) = 0) = 1;

OperationalLife(r,t)$(OperationalLife(r,t) = 0) = 1;

*------------------------------------------------------------------------	
* Parameters - Capacity factors       
*------------------------------------------------------------------------

CapacityFactor(r,t,l,y)$((not renewable_tech(t)) and (CapacityFactor(r,t,l,y) eq 0)) = 1;

AvailabilityFactor(r,t,y)$(AvailabilityFactor(r,t,y) = 0) = 1;

ReserveMarginTagFuel(r,"ELC",y) = 1;  #electricity

*------------------------------------------------------------------------
* Parameters - Storage
*------------------------------------------------------------------------

StorageUnitSize(r, s, y)$(not modular_storages(s)) = eps;


$endif.ph