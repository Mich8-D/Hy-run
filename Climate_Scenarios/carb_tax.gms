*-------------------------------
*           CARBON TAX
*-------------------------------

SCALAR
    a_tax /0.42/
    b_tax /0.32/
    c_tax /75/;

EmissionsPenalty(r,'CO2',y) = a_tax * exp(b_tax * (y.val - 2024)) + c_tax;