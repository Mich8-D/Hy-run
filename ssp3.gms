SpecifiedAnnualDemand('GERMANY','H2_TH','2030') = 25*3;
SpecifiedAnnualDemand('GERMANY','H2_TH','2035') = 36*3;
SpecifiedAnnualDemand('GERMANY','H2_TH','2040') = 59*3;
SpecifiedAnnualDemand('GERMANY','H2_TH','2045') = 85*3;
*
*
parameter SpecifiedDemandProfile(r,f,l,y) /
GERMANY.H2_TH.ID.(%yearstart%*%yearend% )  .33
GERMANY.H2_TH.IN.(%yearstart%*%yearend% )  .17
GERMANY.H2_TH.SD.(%yearstart%*%yearend% )  .17
GERMANY.H2_TH.SN.(%yearstart%*%yearend% )  .08
GERMANY.H2_TH.WD.(%yearstart%*%yearend% )  .17
GERMANY.H2_TH.WN.(%yearstart%*%yearend% )  .08
/;

*--------------------------------
*           POWER SECTOR
*--------------------------------

AnnualEmissionLimit(r,'CO2_PP',y)$(y.val >= 2035)  = 0;

SpecifiedAnnualDemand("GERMANY","ELC_ACC_H2","2030") = 1*2.5;
SpecifiedAnnualDemand("GERMANY","ELC_ACC_H2","2035") = 4*2.5;
SpecifiedAnnualDemand("GERMANY","ELC_ACC_H2","2040") = 21*2.5;
SpecifiedAnnualDemand("GERMANY","ELC_ACC_H2","2045") = 71*2.5;


parameter SpecifiedDemandProfile(r,f,l,y) /
  GERMANY.ELC_ACC_H2.ID.(%yearstart%*%yearend% )  .35
  GERMANY.ELC_ACC_H2.IN.(%yearstart%*%yearend% )  .14
  GERMANY.ELC_ACC_H2.SD.(%yearstart%*%yearend% )  .17
  GERMANY.ELC_ACC_H2.SN.(%yearstart%*%yearend% )  .07
  GERMANY.ELC_ACC_H2.WD.(%yearstart%*%yearend% )  .19
  GERMANY.ELC_ACC_H2.WN.(%yearstart%*%yearend% )  .08
/;