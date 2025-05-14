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

set fuel_cosumption(TECHNOLOGY) / IHE, IHG, IHC /;

$elseif.ph %phase%=='data' 
*------------------------------------------------------------------------	
* Parameters - Demands       
*------------------------------------------------------------------------
scalar fel_2024 /1677.6/;  # Converted from 466 TWh to PJ   # Final electricity demand: Industrial, residential
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

scalar fith_2024 /1872/;  # Converted from 520 TWh to PJ   # Industrial thermal demand 
scalar a_fith /0.0320/;
scalar b_fith /-0.4780/;
scalar c_fith /-28.6400/;
scalar d_fith /2.3999/;

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
CapitalCost(r,"FEU",y) = 0;
VariableCost(r,"FEU",m,y) = 1e-5;
FixedCost(r,"FEU",y) = 0.1;
OperationalLife(r,"FEU") = 10;
ResidualCapacity(r,"FEU",y) = 76;  

** industrial heating technologies
CapitalCost(r,"IHE",y) = 900;          # €/kW - Typical CAPEX for industrial electric resistance heaters
VariableCost(r,"IHE",m,y) = 0.002;     # €/kWh - O&M cost (electricity price handled separately)
FixedCost(r,"IHE",y) = 15;             # €/kW/year - Fixed O&M (~1.5% of CAPEX)
OperationalLife(r,"IHE") = 15;         # Years - Longer life due to fewer moving parts

CapitalCost(r,"IHG",y) = 1015;         # €/kW - Investment cost for gas heater
VariableCost(r,"IHG",m,y) = 0.001;     # €/kWh - Variable O&M cost (fuel cost modeled separately)
FixedCost(r,"IHG",y) = 20;             # €/kW/year - Fixed O&M cost
OperationalLife(r,"IHG") = 10;         # Years - Expected lifetime of the equipment

CapitalCost(r,"IHC",y) = 1100;         # €/kW - CAPEX for industrial coal-fired heat systems
VariableCost(r,"IHC",m,y) = 0.005;     # €/kWh - O&M excluding fuel (coal cost modeled separately)
FixedCost(r,"IHC",y) = 25;             # €/kW/year - Fixed O&M (~2.3% of CAPEX)
OperationalLife(r,"IHC") = 20;         # Years - Longer lifetime due to robust industrial build

*------------------------------------------------------------------------
$elseif.ph %phase%=='popol'

#template (efficiencies should be populated correctly)

** electricity 
InputActivityRatio(r,"FEU","ELC2","1",y) = 1;
OutputActivityRatio(r,"FEU","ED","1",y) = 1;

** industrial heating technologies
InputActivityRatio(r,"IHE","ELC2","1",y) = 1;      # 100% efficiency
InputActivityRatio(r,"IHG","GAS2","1",y) = 1.11;   # ~90% efficiency
InputActivityRatio(r,"IHC","HCO","1",y) = 1.25;    # ~80% efficiency
# demand for industrial heating is thermal
OutputActivityRatio(r,"IHE","IH","1",y) = 1;
OutputActivityRatio(r,"IHG","IH","1",y) = 1;
OutputActivityRatio(r,"IHC","IH","1",y) = 1;

$endif.ph