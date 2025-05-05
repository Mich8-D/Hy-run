$batinclude "Data/germany_no_ren_data.gms"
$batinclude "Data/renewables_data"

set TECHNOLOGIES /
# "traditional" storage technologies
 STOR_HYDRO 'Pumped storage'
 BATTERIES 'Batteries'
/;

set STORAGE /DAM, BEES/;

