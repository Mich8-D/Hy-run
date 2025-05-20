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



*--------------------------------
*           POWER SECTOR
*--------------------------------

AnnualEmissionLimit(r,'CO2_PP',y)$(y.val >= 2045)  = 0;
