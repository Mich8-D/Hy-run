* Account for shares in hydrogen in different sectors
*--------------------------------
*          INDUSTRIAL THERMAL
*--------------------------------
*SpecifiedAnnualDemand('GERMANY','IH_ACC_H2','2030') = 25*3.6/10;
*SpecifiedAnnualDemand('GERMANY','IH_ACC_H2','2035') = 36*3.6/10;
*SpecifiedAnnualDemand('GERMANY','IH_ACC_H2','2040') = 59*3.6/10;
*SpecifiedAnnualDemand('GERMANY','IH_ACC_H2','2045') = 85*3.6/10;
*
*
*parameter SpecifiedDemandProfile(r,f,l,y) /
*  GERMANY.IH_ACC_H2.ID.(%yearstart%*%yearend% )  .33
*  GERMANY.IH_ACC_H2.IN.(%yearstart%*%yearend% )  .17
*  GERMANY.IH_ACC_H2.SD.(%yearstart%*%yearend% )  .17
*  GERMANY.IH_ACC_H2.SN.(%yearstart%*%yearend% )  .08
*  GERMANY.IH_ACC_H2.WD.(%yearstart%*%yearend% )  .17
*  GERMANY.IH_ACC_H2.WN.(%yearstart%*%yearend% )  .08
*/;
*--------------------------------
*           POWER SECTOR
*--------------------------------
SpecifiedAnnualDemand("GERMANY","ELC_ACC_H2","2030") = 1*3.6/10;
SpecifiedAnnualDemand("GERMANY","ELC_ACC_H2","2035") = 4*3.6/10;
SpecifiedAnnualDemand("GERMANY","ELC_ACC_H2","2040") = 21*3.6/10;
SpecifiedAnnualDemand("GERMANY","ELC_ACC_H2","2045") = 71*3.6/10;


parameter SpecifiedDemandProfile(r,f,l,y) /
  GERMANY.ELC_ACC_H2.ID.(%yearstart%*%yearend% )  .35
  GERMANY.ELC_ACC_H2.IN.(%yearstart%*%yearend% )  .14
  GERMANY.ELC_ACC_H2.SD.(%yearstart%*%yearend% )  .17
  GERMANY.ELC_ACC_H2.SN.(%yearstart%*%yearend% )  .07
  GERMANY.ELC_ACC_H2.WD.(%yearstart%*%yearend% )  .19
  GERMANY.ELC_ACC_H2.WN.(%yearstart%*%yearend% )  .08
/;

*------------------------------------------------------------------------   
* Parameters - RE Generation Target    <==>    Pledges on Power Sector   
*------------------------------------------------------------------------


*REMinProductionTarget(r,y)$(y.val >= 2030) = 0.8 + 0.04*(y.val - 2030);
*
*REMinProductionTarget(r,y)$(y.val >= 2035) = 1.0;


*------------------------------------------------------------------------   
* Parameters - Emissions       <==>    from 2045 Germany committed to be net zero
*------------------------------------------------------------------------


*AnnualEmissionLimit(r,'CO2_TH',y)$(y.val >= 2045) = 0;
