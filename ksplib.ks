@LAZYGLOBAL off.

// general tools

// make function at runtime
function makef {
    parameter body.
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

// orbit tools

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

// change apo from peri
function reapo {
    parameter ta.
    local dv is burndv(body:radius + obt:periapsis, obt:semimajoraxis, 0.5*(2*body:radius + ta + obt:periapsis)).
    local x is node(time:seconds + eta:periapsis, 0, 0, dv).
    add x.
}.

// change peri from apo
function reperi {
    parameter ta.
    local dv is burndv(body:radius + obt:apoapsis, obt:semimajoraxis, body:radius + ta).
    local x is node(time:seconds + eta:apoapsis, 0, 0, dv).
    add x.
}.

// part fixes

// return engine thrusts cause something is bugged right now
function stagethrust {
    local thrust is 0.
    local englist is list().
    list engines in englist.
    for eng in englist {
        if eng:stage = stage:number {
            set thrust to thrust + eng:maxthrust.
        }
    }.
    return thrust.
}

// return active engine thrusts
function currthrust {
    local thrust is 0.
    local englist is list().
    list engines in englist.
    for eng in englist {
        if eng:stage = stage:number {
            set thrust to thrust + eng:thrust.
        }
    }.
    return thrust.
}

// return effective stage isp
function stageisp {
    local ispsum is 0.
    local flowsum is 0.
    local flow is 0.
    local englist is list().
    list engines in englist.
    for eng in englist {
        if eng:stage = stage:number {
            set flow to (eng:maxthrust / eng:visp).
            // set ispsum to ispsum + (flow * eng:visp).
            set ispsum to ispsum + eng:maxthrust.
            // set flowsum to flowsum + flow.
            set flowsum to flowsum + (eng:maxthrust / eng:visp).
        }
    }.
    if flowsum = 0 {
        return 0.
    } else {
        return (ispsum / flowsum).
    }.
}

function rtantennae {
    local ms is ship:modulesnamed("ModuleRTAntenna").
    for m in ms {
        if m:hasevent("activate") {
            m:doevent("activate").
        }
    }.
}.

