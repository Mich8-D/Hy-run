$include main.gms  * or the relevant file with sets/parameters

* SSP1 "Green Road" Scenario: Lower CAPEX for renewables and hydrogen, strict emission cap

# Lower CAPEX for renewables and hydrogen
loop(YEAR,
    CapitalCost("GERMANY", "SPV", YEAR)     = 0.8 * CapitalCost("GERMANY", "SPV", YEAR);
    CapitalCost("GERMANY", "WPP_ON", YEAR)    = 0.8 * CapitalCost("GERMANY", "WPP_ON", YEAR);
    CapitalCost("GERMANY", "WPP_OFF", YEAR) = 0.8 * CapitalCost("GERMANY", "WPP_OFF", YEAR);
    CapitalCost("GERMANY", "BMPP", YEAR) = 0.8 * CapitalCost("GERMANY", "BMPP", YEAR);
    CapitalCost("GERMANY", "ROR", YEAR) = 0.8 * CapitalCost("GERMANY", "ROR", YEAR);
    CapitalCost("GERMANY", "GEOTH", YEAR) = 0.8 * CapitalCost("GERMANY", "GEOTH", YEAR);
    
    CapitalCost("GERMANY", "FC", YEAR) = 0.8 * CapitalCost("GERMANY", "FC", YEAR);
    CapitalCost("GERMANY", "GRID_H2", YEAR) = 0.8 * CapitalCost("GERMANY", "GRID_H2", YEAR);
    CapitalCost("GERMANY", "UHS_CHARGE", YEAR) = 0.8 * CapitalCost("GERMANY", "UHS_CHARGE", YEAR);
    CapitalCost("GERMANY", "TANKS_CHARGE", YEAR) = 0.8 * CapitalCost("GERMANY", "TANKS_CHARGE", YEAR);
    CapitalCost("GERMANY", "UHS", YEAR) = 0.8 * CapitalCost("GERMANY", "UHS", YEAR);
    CapitalCost("GERMANY", "TANKS", YEAR) = 0.8 * CapitalCost("GERMANY", "TANKS", YEAR);
    CapitalCost("GERMANY", "SSMR_CCS", YEAR) = 0.8 * CapitalCost("GERMANY", "SSMR_CCS", YEAR);
    CapitalCost("GERMANY", "HEL", YEAR) = 0.8 * CapitalCost("GERMANY", "HEL", YEAR);
);


#Strict emission cap
AnnualEmissionLimit("GERMANY", "CO2", "2020") = 200;
AnnualEmissionLimit("GERMANY", "CO2", "2025") = 150;
AnnualEmissionLimit("GERMANY", "CO2", "2030") = 100;
AnnualEmissionLimit("GERMANY", "CO2", "2035") = 60;
AnnualEmissionLimit("GERMANY", "CO2", "2040") = 30;
AnnualEmissionLimit("GERMANY", "CO2", "2045") = 10;
AnnualEmissionLimit("GERMANY", "CO2", "2050") = 0;