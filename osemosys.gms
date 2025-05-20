*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
* OSEMOSYS 2017.11.08 update by Thorsten Burandt, Konstantin L�ffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
* OSEMOSYS 2024.26.03 update by Pietro Andreoni, CMCC
*
* Files required are:
* osemosys.gms (this file)
* osemosys_dec.gms
* utopia_data.txt
* osemosys_equ.gms
*
* To run this GAMS version of OSeMOSYS on your PC:
* 1. YOU MUST HAVE GAMS VERSION 22.7 OR HIGHER INSTALLED.
* This is because OSeMOSYS has some parameter, variable and equation names
* that exceed 31 characters in length, and GAMS versions prior to 22.7 have
* a limit of 31 characters on the length of such names.
* 2. Ensure that your PATH contains the GAMS Home Folder.
* 3. Place all 4 of the above files in a convenient folder,
* open a Command Prompt window in this folder, and enter:
* gams osemosys.gms
* 4. You should find that you get an optimal value of 29446.861.
* 5. Some results are created in file SelResults.CSV that you can view in Excel.
* OPTIONS
* --storage=1 to enable storage constraints
* --mip=1 to solve the problem as a mixed integer linear program. To be paired with appropriate definition of parameter CapacityOfOneTechnologyUnit
* --scen={base,ren_target,ctax,emicap,nocoal,cost_res} to run the model with different constraints
* --data={baseenergysystem,utopia,renewables} to run the model with different data
$eolcom #
$onmulti
$onrecurse
$setglobal mip
$if not set scen $setglobal scen base
$if not set cost $setglobal cost real
$if not set data $setglobal data template
$if not set value $setglobal value ""
$include "Model/osemosys_dec.gms"
* specify Model data
#$include "Data/%data%_data.gms"

$include "Input_template/template_data.gms"
* we use the

* perform data computations when needed
$include "Model/compute_data.gms"
* define model equations
$include "Model/osemosys_equ.gms"



* some model options
model osemosys /all/;
option limrow=0, limcol=0, solprint=on;
option mip = copt;
option lp = conopt;

** first, solve the model without any constraints
*$ifthen.solvermode set mip
*solve osemosys minimizing z using mip; 
*$else.solvermode
*solve osemosys minimizing z using lp;
*$endif.solvermode
*
**$include "Model/osemosys_res.gms"
**$include "Model/report.gms"
*$if not set storage execute_unload 'Results/results_SCENbase_DATA%data%_STORno.gdx';
*$if set storage execute_unload 'Results/results_SCENbase_DATA%data%_STORyes.gdx';

$ifthen.scen %scen%=="ctax" 
$include "Climate_Scenarios/carb_tax.gms"
$elseif.scen %scen%=="emicap" 
$include "Climate_Scenarios/emi_cap_pledges.gms"
$elseif.scen %scen%=="forecastH2" 
$include "Climate_Scenarios/hydrogen_forecast.gms"
$elseif.scen %scen%=="nocoal" 
TotalAnnualMaxCapacity(r,'COAL',y) = .5;
$elseif.scen %scen%=="parametrised_py"
$include "Input_template/parametrised_py.gms"
$elseif.scen %scen%=="ssp1"
$include "ssp1.gms"
$elseif.scen %scen%=="ssp2"
$include "ssp2.gms"
$elseif.scen %scen%=="ssp3"
$include "ssp3.gms"
$elseif.scen %scen%=="ssp4"
$include "ssp4.gms"
$elseif.scen %scen%=="ssp5"
$include "ssp5.gms"
$endif.scen

$ifthen.cost %cost%=="cheapres"
CapitalCost(r,t,y)$renewable_tech(t) = %value%/100 * CapitalCost(r,t,y);
$elseif.cost %cost%=="cheapH2store"
CapitalCostStorage(r,s,y)$hydrogen_storages(s) = %value%/100 * CapitalCostStorage(r,s,y);
$elseif.cost %cost%=="cheapH2prod"
CapitalCost(r,t,y)$hydrogen_tech(t) = %value%/100 * CapitalCost(r,t,y);
$elseif.cost %cost%=="cheapbees"
CapitalCostStorage(r,'BATTERIES',y) = %value%/100 * CapitalCostStorage(r,'BATTERIES',y);
$endif.cost

$ONTEXT
option limrow = 50;     #Mostra fino a 50 equazioni più violate
option solprint = on;   #Stampa i livelli delle variabili
option decimals = 6;    #Mostra più cifre decimali nei report
$offText

* solve the model with the constraints
$ifthen.notbase not %scen%=="base" 

$ifthen.solvermode set mip
solve osemosys minimizing z using mip;
$else.solvermode
solve osemosys minimizing z using nlp;
$endif.solvermode



* create results in file SelResults.CSV
$include "Model/osemosys_res.gms"
*$include "Model/report.gms"
$if not set storage execute_unload 'Results/results_SCEN%scen%%value%_DATA%data%_COST%cost%_STORno.gdx';
$if set storage execute_unload 'Results/results_SCEN%scen%%value%_DATA%data%_COST%cost%_STORyes.gdx';

$endif.notbase

$ONTEXT
* Mostra equazioni sospette (modifica se ne hai altre sospette)
display
  RE4_EnergyConstraint.l, RE4_EnergyConstraint.m,
  EBa11_EnergyBalanceEachTS5.l, EBa11_EnergyBalanceEachTS5.m,
  EBb4_EnergyBalanceEachYear4.l, EBb4_EnergyBalanceEachYear4.m,
  SI1_StorageUpperLimit.l, SI1_StorageUpperLimit.m,
  RM3_ReserveMargin_Constraint.l, RM3_ReserveMargin_Constraint.m;
$offText