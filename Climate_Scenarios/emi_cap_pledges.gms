*------------------------------------------------------------------------   
* Parameters - RE Generation Target    <==>    Pledges on Power Sector   
*------------------------------------------------------------------------


REMinProductionTarget(r,y)$(y.val >= 2030) = 0.8 + 0.04*(y.val - 2030);

REMinProductionTarget(r,y)$(y.val >= 2035) = 1.0;


*------------------------------------------------------------------------   
* Parameters - Emissions       <==>    from 2045 Germany committed to be net zero
*------------------------------------------------------------------------


AnnualEmissionLimit(r,e,y)$(y.val >= 2045) = 0;

