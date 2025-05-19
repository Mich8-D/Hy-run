$include main.gms  * or the relevant file with sets/parameters

* SSP1 "Green Road" Scenario: Lower CAPEX for renewables and hydrogen, strict emission cap

* Override CAPEX for renewables and hydrogen
capex("wind")     = 700;   * Lowered for SSP1
capex("solar")    = 400;   * Lowered for SSP1
capex("hydrogen") = 800;   * Lowered for SSP1

* Strict emission cap: rapidly declining (MtCO2)
cap_emission("2020") = 200;
cap_emission("2025") = 150;
cap_emission("2030") = 100;
cap_emission("2035") = 60;
cap_emission("2040") = 30;
cap_emission("2045") = 10;
cap_emission("2050") = 0;

* If demand is scenario-specific, override here
demand(t) = 500;

* Solve as usual (assuming model and equations are defined in main.gms)
SOLVE ssp1_green_road USING LP MINIMIZING total_cost;

DISPLAY x.l, total_cost.l;
