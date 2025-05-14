** configuration options
$setglobal storage 1
$setglobal yearstart 2024
$setglobal yearend 2050

*------------------------------------------------------------------------	
* Sets       
*------------------------------------------------------------------------
set     YEAR    / %yearstart%*%yearend% /;
set     EMISSION        / CO2, CO2_PP, CO2_TH /;
set     MODE_OF_OPERATION       / 1, 2 /;
set     REGION  / GERMANY /;
set     TIMESLICE  / ID, IN, SD, SN, WD, WN /;
set     SEASON / 1, 2, 3 /;
set     DAYTYPE / 1 /;
set     DAILYTIMEBRACKET / 1, 2 /;

scalar yfirst / 2024 /;

# characterize technologies 
set power_plants(TECHNOLOGY);
set storage_plants(TECHNOLOGY);
set fuel_transformation(TECHNOLOGY);
set appliances(TECHNOLOGY);
set unmet_demand(TECHNOLOGY);
set transport(TECHNOLOGY);
set primary_imports(TECHNOLOGY);
set secondary_imports(TECHNOLOGY);

set renewable_tech(TECHNOLOGY); 
set renewable_fuel(FUEL); 

set fuel_production(TECHNOLOGY);
set fuel_production_fict(TECHNOLOGY);
set secondary_production(TECHNOLOGY);

#Characterize fuels 
set primary_fuel(FUEL);
set secondary_carrier(FUEL);
set final_demand(FUEL);

*$include "Model/osemosys_init.gms"

$batinclude "Input_%data%/input_primary.gms" "sets"
$batinclude "Input_%data%/input_secondary.gms" "sets"
$batinclude "Input_%data%/input_storage.gms" "sets"
$batinclude "Input_%data%/input_demand.gms" "sets"
#$batinclude "Input_%data%/input_hydrogen.gms" "sets"

$batinclude "Input_%data%/init.gms" "pre"

$batinclude "Input_%data%/input_primary.gms" "data"
$batinclude "Input_%data%/input_secondary.gms" "data"
$batinclude "Input_%data%/input_storage.gms" "data"
$batinclude "Input_%data%/input_demand.gms" "data"
#$batinclude "Input_%data%/input_hydrogen.gms" "data"

$batinclude "Input_%data%/input_primary.gms" "popol"
$batinclude "Input_%data%/input_secondary.gms" "popol"
$batinclude "Input_%data%/input_storage.gms" "popol"
$batinclude "Input_%data%/input_demand.gms" "popol"
#$batinclude "Input_%data%/input_hydrogen.gms" "popol"

$batinclude "Input_%data%/init.gms" "post"
