// make function at runtime
function makef {
    parameter body.
    log "" to temp.ks. delete temp.ks.
    log body to temp.ks.
    run temp.ks.
}.

function trace {
    parameter a.
    print "T+" + round(missiontime) + " " + a.
}.

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


