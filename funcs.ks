// vis visa at current body
function visvisa {
    parameter rad.
    parameter sma.

    return (sqrt(body:mu * (2/rad - 1/sma))).
}.

print "loaded functions".
