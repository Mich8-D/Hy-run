$include "Data/utopia_data.gms"
$include "Data/renewables_data.gms"


SET TECHNOLOGY /HEL   "Hydrogen Electrolyzers",
                HFC   "Hydrogen fuel cells" /;

SET STORAGE / HYDROGEN "HYDROGEN"/;


# Characterize ELECTROLIZERS
CapacityFactor(r,'HEL',l,y) = 1;
AvailabilityFactor(r,'HEL',y) = 0.9;
InputActivityRatio(r,'HEL','ELC',"1",y) = 1; #IEA convention
TechnologyToStorage(r,"1",'HEL','HYDROGEN') = 1;

OperationalLife(r,'HEL') = 10;
CapitalCost(r,'HEL',y) = 1;
VariableCost(r,'HEL',m,y) = 0;
FixedCost(r,'HEL',y) = 0;

# Characterize FUEL CELLS
CapacityFactor(r,'HFC',l,y) = 1;
AvailabilityFactor(r,'HFC',y) = 0.9;
OutputActivityRatio(r,'HFC','ELC',"1",y) = 1; #IEA convention
TechnologyFromStorage(r,"1",'HFC','HYDROGEN') = 1;

OperationalLife(r,'HFC') = 10;
CapitalCost(r,'HFC',y) = 1;
VariableCost(r,'HFC',m,y) = 0;
FixedCost(r,'HFC',y) = 0;

CapitalCostStorage(r,'HYDROGEN',y) = 1;
ResidualStorageCapacity(r,'HYDROGEN',y) = 0;
StorageLevelStart(r,'HYDROGEN') = 0;


set storage_plants(TECHNOLOGY) / "HFC", "HEL" /;
