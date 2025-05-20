** Account for shares in hydrogen in different sectors
*--------------------------------
*          INDUSTRIAL THERMAL
*--------------------------------
SpecifiedAnnualDemand('GERMANY','IH_ACC_H2','2030') = 25*3;
SpecifiedAnnualDemand('GERMANY','IH_ACC_H2','2035') = 36*3;
SpecifiedAnnualDemand('GERMANY','IH_ACC_H2','2040') = 59*3;
SpecifiedAnnualDemand('GERMANY','IH_ACC_H2','2045') = 85*3;
*
*
parameter SpecifiedDemandProfile(r,f,l,y) /
GERMANY.IH_ACC_H2.ID.(%yearstart%*%yearend% )  .33
GERMANY.IH_ACC_H2.IN.(%yearstart%*%yearend% )  .17
GERMANY.IH_ACC_H2.SD.(%yearstart%*%yearend% )  .17
GERMANY.IH_ACC_H2.SN.(%yearstart%*%yearend% )  .08
GERMANY.IH_ACC_H2.WD.(%yearstart%*%yearend% )  .17
GERMANY.IH_ACC_H2.WN.(%yearstart%*%yearend% )  .08
/;

Scalar
   A /75/,                             
   B /0.0803/;
  
SpecifiedAnnualDemand('GERMANY','IH_ACC_H2',y)$(y.val >= 2030) = A * exp( B * (y.val - 2030) );


* --- aggiungo elettrolisi diretta a H2_TH
set TECHNOLOGY         /
                          HEL_TH_DIRECT   "Electrolyzer → H2_TH (direct)"
                        /;

* la includo tra le tecnologie di elettrolisi
set hydrogen_tech(TECHNOLOGY) / HEL_TH_DIRECT /;


* --- Parametri per HEL_TH_DIRECT
AvailabilityFactor(r,'HEL_TH_DIRECT',y)        = 0.95;
CapacityFactor    (r,'HEL_TH_DIRECT',l,y)      = 1;
OperationalLife   (r,'HEL_TH_DIRECT')           = 10;
CapacityToActivityUnit(r,'HEL_TH_DIRECT')       = 31.536;   
ResidualCapacity  (r,'HEL_TH_DIRECT',y)         = 0;
loop(y,
    CapitalCost    (r,'HEL_TH_DIRECT',y)        = 1200 - 32*(y.val - 2024);
);
FixedCost         (r,'HEL_TH_DIRECT',y)        = 0.03 * CapitalCost(r,'HEL_TH_DIRECT',y);
VariableCost      (r,'HEL_TH_DIRECT',m,y)      = 0.5;

TotalAnnualMaxCapacityInvestment(r,'HEL_TH_DIRECT',y) = 80;

* --- Input/output HEL_TH_DIRECT
InputActivityRatio (r,'HEL_TH_DIRECT','ELC','1',y)  = 1/0.68;
OutputActivityRatio(r,'HEL_TH_DIRECT','H2_TH','1',y) = 1;


*--------------------------------
*           POWER SECTOR
*--------------------------------

