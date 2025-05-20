*------------------------------------------------------------------------   
* Parameters - RE Generation Target    <==>    Pledges on Power Sector   
*------------------------------------------------------------------------

*
REMinProductionTarget(r,y)$(y.val >= 2030) = 0.8 + 0.04*(y.val - 2030);
*
REMinProductionTarget(r,y)$(y.val >= 2035) = 1.0;

AnnualEmissionLimit(r, 'CO2_PP', y)$(y.val >= 2035) = 0;

*------------------------------------------------------------------------   
* Parameters - Emissions       <==>    from 2045 Germany committed to be net zero
*------------------------------------------------------------------------

AnnualEmissionLimit(r,'CO2_TH',y)$(y.val >= 2045) = 0;


*-------------------------------
*           CARBON TAX
*-------------------------------

*
*SCALAR
*    a_tax /0.42/
*    b_tax /0.32/
*    c_tax /75/;
*
*EmissionsPenalty(r,'CO2',y) = a_tax * exp(b_tax * (y.val - 2024)) + c_tax;

*-----------------------------------------
*        ALLOWING A LOT OF RENEWABLES
*-----------------------------------------

TotalAnnualMaxCapacity(r,t,y)$renewable_tech(t) = 900;
TotalAnnualMaxCapacity(r,'SPV',y) = 500;
TotalAnnualMaxCapacity(r,'WPP_OFF',y) = 160;
TotalAnnualMaxCapacity(r,'WPP_ON',y) = 300;


