parameter ta.
run genlib.
run orblib.

// defaults
if ta = 0 {set ta to 1e5.}.

// gravity turn
global GT0 is 1000.
global GT1 is 50000.
global TH1 is -90.
global ATMBUFFER is 250.

// velocity PID
global Ku is 0.06.
global Tu is 2*1.1.
global kp is 0.8*ku.
global ki is 0.
global kd is (kp*tu)/8.

// target airspeed fcn: exp(be0+be1*alt)
global be0 is 5.2.
global be1 is 8.2e-5.

clearscreen. 
// reserve lines
for i in range(0,8) {
    print " ".
}.
trace("`orbit` start at: " + time:calendar + " " + time:clock).
sas on.
set sasmode to "stabilityassist".
set th to 1.
lock throttle to th. 
global theta is 0.
lock steering to up + R (0, theta, -180).
print "T-1  All systems GO. Ignition!". 
wait 1. 

// pid shit
global vt is 0.
global t0 is missiontime.
global p0 is (vt - ship:airspeed).

// event handler for staging
global laststage is -1.
when stage:liquidfuel < 0.001 then { 
    if missiontime - laststage > 0.5 {
        trace("No liquidfuel. Attempting to stage.").
        stage.
        set laststage to missiontime.
    }.
    preserve.
}

// gravity turn code
when alt:radar > GT0 then {
    trace("Beginning gravity turn.").
}

// atmosphere burn
wait until missiontime > t0.
until apoapsis > (ta + ATMBUFFER) {
    set ar to alt:radar.
    // control attitude
    // consider different functional turns here
    if ar > GT0 and ar < GT1 {
        set arr to (ar - GT0) / (GT1 - GT0).
        // set pda to sin(arr * 90).
        set pda to sqrt(arr).
        // set pda to arr.
        set theta to TH1 * pda.
        lock steering to up + R(0, theta, -180).
        print "theta: " + round(theta,4) at (0,5).
        print "alt: " + ar at (0,6).
    }
    if ar > GT1 {
        // lock steering to up + R(0, theta, -180).
        lock steering to up + R(0, theta, -180).
    }

    // control speed (via a decently fitting quadratic)
    // set vt to (b0 + b1*altitude + b2 * altitude^2).
    set vt to (constant():e ^ (be0 + be1 * altitude)).
    set dt to missiontime - t0.
    set P to (vt - ship:airspeed).
    set D to ((p-p0)/dt).
    set dth to Kp * P + Kd * d.
    set th to max(0,min(1,th + dth)).

    // update state variables
    set t0 to missiontime.
    set p0 to p.

    print "target altitude: " + ta at (0,0).
    print "alt:radar: " + round(ar,4) at (0,1).
    print "velocity:surface: " + round(ship:airspeed,4) at (0,2).
    print "target velocity: " + round(vt,4) at (0,3).
    print "throttle: " + round(th,4) + " (" + round(dth,4) + ")          " at (0,4).
    print "==============================" at (0,7).
    wait 0.1.
}.
set th to 0.
trace("Fuel after atmosphere burn: " + stage:liquidfuel).
trace("Coasting to apoapsis in " + eta:apoapsis).

unlock steering.
unlock throttle.
set ship:control:pilotmainthrottle to 0.
wait 1.

// make a circularization node once we've passed atmosphere
wait until altitude > kerbin:atm:height.
run reperi(ta).

ag0 on.
//rtantennae().

run node.

//lights on.
