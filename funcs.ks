@LAZYGLOBAL off.

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

// return engine thrusts cause something is bugged right now
function stagethrust {
    local thrust is 0.
    list engines in englist.
    for eng in englist {
        if eng:stage = stage:number {
            set thrust to thrust + eng:maxthrust.
        }
    }.
    return thrust.
}

// return list of integers from start (incl) to end (excl)
function range {
    parameter start.
    parameter end.

    local i is start.
    local l is list().
    until i >= end {
        l:add(i).
        set i to i+1.
    }.

    return l.
}.
