$batinclude "Data/germany_no_ren_data.gms"
$batinclude "Data/renewables_data"

set TECHNOLOGIES /
  STOR_HYDRO 'Pumped storage',
  BATTERIES 'Batteries'
/;

set STORAGE /DAM, BEES/;

* ---------------------------
* Parameters for Storage
* ---------------------------

* Link technologies to storage types
parameter TechnologyToStorage(r,m,t,s) /
  GERMANY.2.STOR_HYDRO.DAM  1,
  GERMANY.2.BATTERIES.BEES  1
/;

parameter TechnologyFromStorage(r,m,t,s) /
  GERMANY.1.STOR_HYDRO.DAM  1,
  GERMANY.1.BATTERIES.BEES  1
/;

* Storage capacities and costs
StorageLevelStart(r,s) = 0;

StorageMaxChargeRate(r,s) = 
  0.25$(s EQ 'DAM') +
  1.00$(s EQ 'BEES');

StorageMaxDischargeRate(r,s) = 
  0.25$(s EQ 'DAM') +
  1.00$(s EQ 'BEES');

MinStorageCharge(r,s,y) = 0;

OperationalLifeStorage(r,s) = 
  30$(s EQ 'DAM') +
  15$(s EQ 'BEES');

* CapitalCostStorage in €/kW (DAM) and €/kWh (BEES)
CapitalCostStorage(r,s,y) = 
  1500$(s EQ 'DAM') +
  350$(s EQ 'BEES');

ResidualStorageCapacity(r,s,y) = 
  6400$(s EQ 'DAM' AND y EQ 2024) +
  6500$(s EQ 'BEES' AND y EQ 2024);

StorageDecay(r,s) = 0;

* Emissions (none for either storage tech)
EmissionActivityRatio(r,s,'CO2',m,y) = 0;
