*------------------------------------------------------------------------   
* Parameters - Emissions       
*------------------------------------------------------------------------

EmissionsPenalty(r,e,y) = 0;

AnnualExogenousEmission(r,e,y) = 0;

AnnualEmissionLimit(r,e,y) = 9999;

ModelPeriodExogenousEmission(r,e) = 0;

ModelPeriodEmissionLimit(r,e) = 9999;


*------------------------------------------------------------------------

*------------------------------------------------------------------------   
* Parameters - RE Generation Target       
*------------------------------------------------------------------------


REMinProductionTarget(r,y)$((y.val >= 2030) = 0.8 + 0.04*(y.val - 2030);



