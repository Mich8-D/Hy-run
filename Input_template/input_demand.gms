$set phase %1
**------------------------------------------------------------------------	
$ifthen.ph %phase%=='sets'

set     TECHNOLOGY      /
        FEU 'Final Electricity Usages'
        IHE 'Industrial heating - electric'
        IHG 'Industrial heating - gas'
        IHC 'Industrial heating - coal' /;

set    FUEL            /
        ED 'Demand for electricity'
        IH 'Demand for industrial heating'/;

$elseif.ph %phase%=='data' 
*------------------------------------------------------------------------	
* Parameters - Demands       
*------------------------------------------------------------------------
scalar fel_2024 /1.6776/;  # Converted from 466 TWh to PJ   # Final electricity demand: Industrial, residential
scalar a_fel /-0.023/;
scalar b_fel /0.742/;
scalar c_fel /1.001/;
scalar d_fel /1.920/;

# Demand is in PJ as per unit standardization guide
Loop(y,
    SpecifiedAnnualDemand("GERMANY","ED",y) = fel_2024
        + a_fel * (ord(y) - 1)**3
        + b_fel * (ord(y) - 1)**2
        + c_fel * (ord(y) - 1)
        + d_fel;
);

scalar fith_2024 /1.872/;  # Converted from 520 TWh to PJ   # Industrial thermal demand 
scalar a_fith /0.0088/;
scalar b_fith /-0.1333/;
scalar c_fith /-7.9555/;
scalar d_fith /0.6666/;

Loop(y,
    SpecifiedAnnualDemand("GERMANY","IH",y) = fith_2024
                + a_fith * (ord(y) - 1)**3
                + b_fith * (ord(y) - 1)**2
                + c_fith * (ord(y) - 1)
                + d_fith;
);



parameter SpecifiedDemandProfile(r,f,l,y) /
  GERMANY.ED.ID.(%yearstart%*%yearend% )  .15
  GERMANY.ED.IN.(%yearstart%*%yearend% )  .05
  GERMANY.ED.SD.(%yearstart%*%yearend% )  .15
  GERMANY.ED.SN.(%yearstart%*%yearend% )  .05
  GERMANY.ED.WD.(%yearstart%*%yearend% )  .5
  GERMANY.ED.WN.(%yearstart%*%yearend% )  .1
  GERMANY.IH.ID.(%yearstart%*%yearend% )  .3
  GERMANY.IH.IN.(%yearstart%*%yearend% )  .033
  GERMANY.IH.SD.(%yearstart%*%yearend% )  .3
  GERMANY.IH.SN.(%yearstart%*%yearend% )  .033
  GERMANY.IH.WD.(%yearstart%*%yearend% )  .3
  GERMANY.IH.WN.(%yearstart%*%yearend% )  .034
/;


AccumulatedAnnualDemand(r,f,y) = 0;

*------------------------------------------------------------------------	
* Parameters - technologies       
*------------------------------------------------------------------------

##### END-USE TECHNOLOGIES

* electricity 
CapitalCost(r,"FEU",y) = 1000;
VariableCost(r,"FEU",m,y) = 1e-5;
FixedCost(r,"FEU",y) = 0.1;
OperationalLife(r,"FEU") = 10;

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

** electricity 
InputActivityRatio(r,"FEU","ELC2","1",y) = 1;
OutputActivityRatio(r,"FEU","ED","1",y) = 1;

** industrial heating technologies
InputActivityRatio(r,"IHE","ELC2","1",y) = 1;
InputActivityRatio(r,"IHG","GAS2","1",y) = 1;
InputActivityRatio(r,"IHC","HCO","1",y) = 1;
# demand for industrial heating is thermal
OutputActivityRatio(r,"IHE","IH","1",y) = 1;
OutputActivityRatio(r,"IHG","IH","1",y) = 1;
OutputActivityRatio(r,"IHC","IH","1",y) = 1;

$endif.ph