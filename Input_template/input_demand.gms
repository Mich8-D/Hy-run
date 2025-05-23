$set phase %1
**------------------------------------------------------------------------	
$ifthen.ph %phase%=='sets'

set     TECHNOLOGY      /
        FEU 'Final Electricity Usages' #just accounting for the demand
        IHE 'Industrial heating - electric'
        IHG 'Industrial heating - gas'
        IHC 'Industrial heating - coal' /;

set    FUEL            /
        ED 'Demand for electricity'
        IH 'Demand for industrial heating'/;

set fuel_consumption(TECHNOLOGY) / IHE, IHG, IHC, FEU /;

$elseif.ph %phase%=='data' 
*------------------------------------------------------------------------	
* Parameters - Demands       
*------------------------------------------------------------------------
scalar fel_2024 /1677/;#Converted from 466 TWh to PJ   # Final electricity demand: Industrial, residential 1677
scalar a_fel /-0.083/;
scalar b_fel /2.673/;
scalar c_fel /3.604/;
scalar d_fel /6.914/;        

# Demand is in PJ as per unit standardization guide
Loop(y,
    SpecifiedAnnualDemand("GERMANY","ED",y) = fel_2024
        + a_fel * (ord(y) - 1)**3
        + b_fel * (ord(y) - 1)**2
        + c_fel * (ord(y) - 1)
        + d_fel;
);

scalar fith_2024 /1750/;  # Converted from 520 TWh to PJ   # Industrial thermal demand 
scalar a_fith /0.0160/;
scalar b_fith /-0.4780/;
scalar c_fith /-28.6400/;

Loop(y,
    SpecifiedAnnualDemand("GERMANY","IH",y) = fith_2024
                + a_fith * (ord(y) - 1)**3
                + b_fith * (ord(y) - 1)**2
                + c_fith * (ord(y) - 1);
);



parameter SpecifiedDemandProfile(r,f,l,y) /
  GERMANY.ED.ID.(%yearstart%*%yearend% )  .35
  GERMANY.ED.IN.(%yearstart%*%yearend% )  .14
  GERMANY.ED.SD.(%yearstart%*%yearend% )  .17
  GERMANY.ED.SN.(%yearstart%*%yearend% )  .07
  GERMANY.ED.WD.(%yearstart%*%yearend% )  .19
  GERMANY.ED.WN.(%yearstart%*%yearend% )  .08
  GERMANY.IH.ID.(%yearstart%*%yearend% )  .33
  GERMANY.IH.IN.(%yearstart%*%yearend% )  .17
  GERMANY.IH.SD.(%yearstart%*%yearend% )  .17
  GERMANY.IH.SN.(%yearstart%*%yearend% )  .08
  GERMANY.IH.WD.(%yearstart%*%yearend% )  .17
  GERMANY.IH.WN.(%yearstart%*%yearend% )  .08
/;


AccumulatedAnnualDemand(r,f,y) = 0;

*------------------------------------------------------------------------	
* Parameters - technologies       
*------------------------------------------------------------------------

##### END-USE TECHNOLOGIES

* electricity 
CapitalCost(r,"FEU",y) = 0;
VariableCost(r,"FEU",m,y) = 1e-5;
FixedCost(r,"FEU",y) = 0;
OperationalLife(r,"FEU") = 30;
ResidualCapacity(r,"FEU",y) = 0;  

** industrial heating technologies
CapitalCost(r,"IHE",y) = 0;          # €/kW - Typical CAPEX for industrial electric resistance heaters
VariableCost(r,"IHE",m,y) = 1e-5;     # mln€/PJ - O&M cost (electricity price handled separately)
FixedCost(r,"IHE",y) = 0;            # €/kW/year - Fixed O&M (~1.5% of CAPEX)
OperationalLife(r,"IHE") = 30;         # Years - Longer life due to fewer moving parts
EmissionActivityRatio(r,"IHE","CO2_TH","1",y) = 0.00;
ResidualCapacity(r,"IHE",y) = 0;   # GW - Residual capacity for electric resistance heaters
TotalTechnologyAnnualActivityLowerLimit(r,'IHE',y) = 0;

CapitalCost(r,"IHG",y) = 0;         # €/kW - Investment cost for gas heater
VariableCost(r,"IHG",m,y) = 1e-5;     # mln€/PJ - Variable O&M cost (fuel cost modeled separately)
FixedCost(r,"IHG",y) = 0;            # €/kW/year - Fixed O&M cost
OperationalLife(r,"IHG") = 30;         # Years - Expected lifetime of the equipment
EmissionActivityRatio(r,"IHG","CO2_TH","1",y) = 0.055*1.11;
ResidualCapacity(r,"IHG",y) = 0;   # GW - Residual capacity for gas heater

CapitalCost(r,"IHC",y) = 0;         # €/kW - CAPEX for industrial coal-fired heat systems
VariableCost(r,"IHC",m,y) = 1e-5;     # mln€/PJ - O&M excluding fuel (coal cost modeled separately)
FixedCost(r,"IHC",y) = 0;             # €/kW/year - Fixed O&M (~2.3% of CAPEX)
OperationalLife(r,"IHC") = 30;         # Years - Longer lifetime due to robust industrial build
EmissionActivityRatio(r,"IHC","CO2_TH","1",y) = 0.089*1.25;
ResidualCapacity(r,"IHC",y) = 0;   # GW - Residual capacity for coal-fired heat systems
*------------------------------------------------------------------------
$elseif.ph %phase%=='popol'

#template (efficiencies should be populated correctly)

** electricity 
InputActivityRatio(r,"FEU","ELC","1",y) = 1;
OutputActivityRatio(r,"FEU","ED","1",y) = 1;

** industrial heating technologies
InputActivityRatio(r,"IHE","ELC","1",y) = 1;      # 100% efficiency
InputActivityRatio(r,"IHG","GAS2","1",y) = 1.11;   # ~90% efficiency
InputActivityRatio(r,"IHC","HCO","1",y) = 1.25;    # ~80% efficiency
# demand for industrial heating is thermal
OutputActivityRatio(r,"IHE","IH","1",y) = 1;
OutputActivityRatio(r,"IHG","IH","1",y) = 1;
OutputActivityRatio(r,"IHC","IH","1",y) = 1;

$endif.ph