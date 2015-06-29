// much adapted from http://ksp.baldev.de/kos/far2/far2.txt
// parameters
parameter tgtalt.       // target altitude

run funcs.

// gravity turn stuff
global GT0 is 1000.
global GT1 is 50000.
global TH1 is -90.
global ATMBUFFER is 250.
global KD is -0.1.              // circularization node adjustment coefficient
global LWAIT is 0.1.

// start script
clearscreen. 

for i in range(0,8) {
    print " ".
}.

print "Script start at: " + time:calendar + " " + time:clock.
sas on.
set sasmode to "stabilityassist".
set th to 1.
lock throttle to th. 
// why rotate to -180? because that's how it starts, dummy
// lock steering to up + R(0, 0, -180).
global theta is 0.
lock steering to up + R (0, theta, -180).
print "T-1  All systems GO. Ignition!". 
wait 1. 

// event handler for staging
global laststage is -1.
when stage:liquidfuel < 0.001 then { 
    if missiontime - laststage > 0.5 {
        print "T+" + round(missiontime) + " No liquidfuel. Attempting to stage.".
        stage.
        set laststage to missiontime.
    }.
    preserve.
}

// gravity turn code
when alt:radar > GT0 then {
    print "T+" + round(missiontime) + " Beginning gravity turn.". 
}

// atmosphere burn
// control speed and attitude
set vt to 200.
when alt:radar > 13000 then { set vt to 2500. }
until apoapsis > (tgtalt + ATMBUFFER) {
    set ar to alt:radar.
    // control attitude
    // consider different functional turns here
    if ar > GT0 and ar < GT1 {
        set arr to (ar - GT0) / (GT1 - GT0).
        // goes from (2 -> 0)/2 as arr goes from 0 -> 1
        // weird bend
        // set pda to (cos(arr * 180) + 1) / 2.
        set pda to sin(arr * 90).
        // goes from 0 -> -1?, i.e. a yaw of 0 to -90
        // set theta to TH1 * ( pda - 1 ).
        set theta to TH1 * pda.
        // lock steering to up + R(0, theta, -180).
        lock steering to up + R(0, theta, -180).
        print "theta: " + theta at (0,5).
        print "alt: " + ar at (0,6).
    }
    if ar > GT1 {
        // lock steering to up + R(0, theta, -180).
        lock steering to up + R(0, theta, -180).
    }

    // control speed
    // calculate target velocity
//     set vl to vt*0.9.
//     set vh to vt*1.1.
    set vsm to velocity:surface:mag.
//     if vsm < vl { set th to 1. }
//     if vsm > vl and vsm < vh { set th to (vh-vsm)/(vh-vl). }
//     if vsm > vh { set th to 0. }
    print "target altitude: " + tgtalt at (0,0).
    print "alt:radar: " + ar at (0,1).
    print "velocity:surface: " + vsm at (0,2).
    print "target velocity: " + vt at (0,3).
    print "throttle: " + th at (0,4).
    print "==============================" at (0,7).
    wait LWAIT.
}.
set th to 0.
print "T+" + round(missiontime) + " Fuel after atmosphere burn: " + stage:liquidfuel.
print "T+" + round(missiontime) + " Coasting to apoapsis in " + eta:apoapsis.

unlock steering.
unlock throttle.
set ship:control:pilotmainthrottle to 0.
wait 1.



// make a circularization node once we've passed atmosphere
wait until altitude > kerbin:atm:height.
// difference in vis-visa
// set dv to (sqrt(kerbin:mu * ((2/(kerbin:radius + obt:apoapsis)) - (1/(kerbin:radius + tgtalt)))) - sqrt(kerbin:mu * ((2/(kerbin:radius + obt:apoapsis)) - (1/obt:semimajoraxis))))
// set dv to (visvisa(kerbin:radius + obt:apoapsis, kerbin:radius + tgtalt) - visvisa(kerbin:radius + obt:apoapsis, obt:semimajoraxis)).
set dv to burndv(kerbin:radius + obt:apoapsis, obt:semimajoraxis, kerbin:radius + tgtalt).
// set dv to (sqrt(kerbin:mu/(kerbin:radius + tgtalt)) - sqrt(kerbin:mu/obt:semimajoraxis)).
set x to node(time:seconds + eta:apoapsis, 0, 0, dv).
add x.

// iteratively fix the node
// "how many iterations could this possibly take?"
lock diff to (x:orbit:semimajoraxis - (kerbin:radius + tgtalt)).
until abs(diff) < 1 {
    set x:prograde to x:prograde + KD * diff.
    wait 0.01.
    print " adjusting circularization node by " + KD * diff.
}.

run node.

lights on.
