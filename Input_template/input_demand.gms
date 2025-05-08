$set phase %1

**------------------------------------------------------------------------	
$ifthen.ph %phase%=='sets'

set     TECHNOLOGY      /
        RHE 'Residential heating - electric'
        RHG 'Residential heating - gas'
        RHD 'Residential heating - diesel'
        RHCC 'Residential heating - waste/cogeneration heat'
        RL1 'Residential lighting'
        RC1 'Residential cooling'
        TXD 'Personal vehicles - diesel'
        TXE 'Personal vehicles - electric'
        TXG 'Personal vehicles - gasoline'
        IHE 'Industrial heating - electric'
        IHG 'Industrial heating - gas'
        IHC 'Industrial heating - coal' /;

set    FUEL            /
        RH 'Demand for residential heating'
        RL 'Demand for residential lighting'
        RC 'Demand for residential cooling'
        IH 'Demand for industrial heating'
        TX 'Demand for personal transport' /;

$elseif.ph %phase%=='data' 
*------------------------------------------------------------------------	
* Parameters - Demands       
*------------------------------------------------------------------------
scalar fen_2025;
fen_2025 = 1400; #TWh

** italy: residential and commercial -> 26% + 12.5% OF FEN.
** assume: 50% heating, 20% cooling, 30% lighting
SpecifiedAnnualDemand(r,"RH",y) = 0.38 * 0.5 * fen_2025;
SpecifiedAnnualDemand(r,"RC",y) = 0.38 * 0.2 * fen_2025;
SpecifiedAnnualDemand(r,"RL",y) = 0.38 * 0.3 * fen_2025;
SpecifiedAnnualDemand(r,"IH",y) = 0.21 * fen_2025;
AccumulatedAnnualDemand(r,"TX",y) = 0.33 * fen_2025;

parameter SpecifiedDemandProfile(r,f,l,y) /
  ITALY.RH.ID.(%yearstart%*%yearend% )  .12
  ITALY.RH.IN.(%yearstart%*%yearend% )  .06
  ITALY.RH.SD.(%yearstart%*%yearend% )  0
  ITALY.RH.SN.(%yearstart%*%yearend% )  0
  ITALY.RH.WD.(%yearstart%*%yearend% )  .5467
  ITALY.RH.WN.(%yearstart%*%yearend% )  .2733
  ITALY.RL.ID.(%yearstart%*%yearend% )  .15
  ITALY.RL.IN.(%yearstart%*%yearend% )  .05
  ITALY.RL.SD.(%yearstart%*%yearend% )  .15
  ITALY.RL.SN.(%yearstart%*%yearend% )  .05
  ITALY.RL.WD.(%yearstart%*%yearend% )  .5
  ITALY.RL.WN.(%yearstart%*%yearend% )  .1
  ITALY.RC.ID.(%yearstart%*%yearend% )  .3
  ITALY.RC.IN.(%yearstart%*%yearend% )  0
  ITALY.RC.SD.(%yearstart%*%yearend% )  .5
  ITALY.RC.SN.(%yearstart%*%yearend% )  .2
  ITALY.RC.WD.(%yearstart%*%yearend% )  0
  ITALY.RC.WN.(%yearstart%*%yearend% )  0
  ITALY.IH.ID.(%yearstart%*%yearend% )  .3
  ITALY.IH.IN.(%yearstart%*%yearend% )  .033
  ITALY.IH.SD.(%yearstart%*%yearend% )  .3
  ITALY.IH.SN.(%yearstart%*%yearend% )  .033
  ITALY.IH.WD.(%yearstart%*%yearend% )  .3
  ITALY.IH.WN.(%yearstart%*%yearend% )  .034
/;


*------------------------------------------------------------------------	
* Parameters - technologies       
*------------------------------------------------------------------------

##### END-USE TECHNOLOGIES
** residential heating technologies
CapitalCost(r,"RHE",y) = 1000;
VariableCost(r,"RHE",m,y) = 1e-5;
FixedCost(r,"RHE",y) = 0.1;
OperationalLife(r,"RHE") = 10;

CapitalCost(r,"RHG",y) = 1000;
VariableCost(r,"RHG",m,y) = 1e-5;
FixedCost(r,"RHG",y) = 0.1;
OperationalLife(r,"RHG") = 10;

CapitalCost(r,"RHD",y) = 1000;
VariableCost(r,"RHD",m,y) = 1e-5;
FixedCost(r,"RHD",y) = 0.1;
OperationalLife(r,"RHD") = 10;

** cogeneration RHCC is a ficticious technology that transforms 1:1 THE fuel in in RH and has no costs
CapitalCost(r,"RHCC",y) = 0;
VariableCost(r,"RHCC",m,y) = 0;
FixedCost(r,"RHCC",y) = 0;
OperationalLife(r,"RHCC") = 999;
ResidualCapacity(r,"RHCC",y) = TotalAnnualMaxCapacity(r,"RHCC",y);

** residential lighting and cooling
CapitalCost(r,"RL1",y) = 1000;
VariableCost(r,"RL1",m,y) = 1e-5;
FixedCost(r,"RL1",y) = 0.1;
OperationalLife(r,"RL1") = 10;

CapitalCost(r,"RC1",y) = 1000;
VariableCost(r,"RC1",m,y) = 1e-5;
FixedCost(r,"RC1",y) = 0.1;
OperationalLife(r,"RC1") = 10;

** personal transport
* assuming 25k for a diesel car, 22k for a gasoline car, and 35k for an electric car
* fixed costs (insurance, taxes, etc.) are 2k for diesel and gasoline, and 1.5k for electric
CapitalCost(r,"TXD",y) = 25e-6;
VariableCost(r,"TXD",m,y) = 0;
FixedCost(r,"TXD",y) = 2e-6;
OperationalLife(r,"TXD") = 12;

CapitalCost(r,"TXE",y) = 35e-6;
VariableCost(r,"TXE",m,y) = 0;
FixedCost(r,"TXE",y) = 1.5e-6;
OperationalLife(r,"TXE") = 12;

CapitalCost(r,"TXG",y) = 22e-6;
VariableCost(r,"TXG",m,y) = 0;
FixedCost(r,"TXG",y) = 2e-6;
OperationalLife(r,"TXG") = 12;

** industrial heating technologies
CapitalCost(r,"IHE",y) = 1000;
VariableCost(r,"IHE",m,y) = 1e-5;
FixedCost(r,"IHE",y) = 0.1;
OperationalLife(r,"IHE") = 10;

CapitalCost(r,"IHG",y) = 1000;
VariableCost(r,"IHG",m,y) = 1e-5;
FixedCost(r,"IHG",y) = 0.1;
OperationalLife(r,"IHG") = 10;

CapitalCost(r,"IHC",y) = 1000;
VariableCost(r,"IHC",m,y) = 1e-5;
FixedCost(r,"IHC",y) = 0.1;
OperationalLife(r,"IHC") = 10;

*------------------------------------------------------------------------
$elseif.ph %phase%=='popol'

#template (efficiencies should be populated correctly)

** residential heating technologies
InputActivityRatio(r,"RHE","ELC","1",y) = 1;
InputActivityRatio(r,"RHG","GAS","1",y) = 1;
InputActivityRatio(r,"RHD","DSL","1",y) = 1;
InputActivityRatio(r,"RHCC","THE","1",y) = 1;
OutputActivityRatio(r,"RHE","RH","1",y) = 1;
OutputActivityRatio(r,"RHG","RH","1",y) = 1;
OutputActivityRatio(r,"RHD","RH","1",y) = 1;
OutputActivityRatio(r,"RHCC","RH","1",y) = 1;

** residential lighting and cooling
InputActivityRatio(r,"RL1","ELC","1",y) = 1;
InputActivityRatio(r,"RC1","ELC","1",y) = 1;
OutputActivityRatio(r,"RHCC","RH","1",y) = 1;
OutputActivityRatio(r,"RL1","RL","1",y) = 1;
OutputActivityRatio(r,"RC1","RC","1",y) = 1;

** personal transport
# here you want to the energy expenditure of one car in one year travelling 10000 kms
# 1 car consumes 10000km * l/km * TWh/l 
* DIESEL:  diesel 10 Kwh/l * 1e-9 TWh/kWh * 10000 km/(car*yr)  / 18 km/l 
InputActivityRatio(r,"TXD","DSL","1",y) = 5.5555e-6; 
* ELECTRIC: 10000 km/yr * 0.135 kWh/km * 1e-9 TWh/kWh 
InputActivityRatio(r,"TXE","ELC","1",y) = 1.35e-6;
* GASOLINE: 8.89 Kwh/l gasoline * 10000 * 1e-9 TWh/kWh / 16 km/l
InputActivityRatio(r,"TXG","GSL","1",y) = 5.5562e-6;

# switch from number of cars to thousands of chilometers travelled
OutputActivityRatio(r,"TXD","TX","1",y) = 10; # average thousands km travelled per year: 10
OutputActivityRatio(r,"TXE","TX","1",y) = 10;
OutputActivityRatio(r,"TXG","TX","1",y) = 10;

** industrial heating technologies
InputActivityRatio(r,"IHE","ELC","1",y) = 1;
InputActivityRatio(r,"IHG","GAS","1",y) = 1;
InputActivityRatio(r,"IHC","HCO","1",y) = 1;
# demand for industrial heating is thermal
OutputActivityRatio(r,"IHE","IH","1",y) = 1;
OutputActivityRatio(r,"IHG","IH","1",y) = 1;
OutputActivityRatio(r,"IHC","IH","1",y) = 1;

$endif.ph