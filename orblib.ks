// vis visa at current body
function visvisa {
    parameter rad.
    parameter sma.
    return (sqrt(body:mu * (2/rad - 1/sma))).
}.

// delta-v to adjust orbit from semi-major axis 0 to 1, with burn at an apsis with radius rad
function burndv {
    parameter rad.
    parameter sma0.
    parameter sma1.
    return (visvisa(rad,sma1) - visvisa(rad,sma0)).
}.

function invperiod {
    parameter p.
    return (body:mu*(p/(2*constant():pi))^2)^(1/3).
}.


