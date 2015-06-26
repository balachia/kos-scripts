// much adapted from http://ksp.baldev.de/kos/far2/far2.txt
// // to orbit, from tutorial
// WHEN SHIP:ALTITUDE > 10000 THEN {
//     PRINT "Starting turn.  Aiming to 45 degree pitch.".
//     LOCK STEERING TO HEADING(90,45). // east, 45 degrees pitch.
// }
// WHEN SHIP:ALTITUDE > 40000 THEN {
//     PRINT "Starting flat part.  Aiming to horizon.".
//     LOCK STEERING TO HEADING(90,0). // east, horizontal.
// }

// parameters
parameter tgtalt.       // target altitude

// gravity turn stuff
global GT0 is 1000.
global GT1 is 50000.
global TH1 is 90.
global ATMBUFFER is 500.
global KD is -0.1.              // circularization node adjustment coefficient

// start script
clearscreen. 
print "Script start at: " + time:calendar + " " + time:clock.
sas on.
set sasmode to "stabilityassist".
set th to 1.
lock throttle to th. 
// why rotate to -180?
// lock steering to up + R(0, 0, -180).
global theta is 0.
lock steering to up + R (0, theta, 0).
print "T-1  All systems GO. Ignition!". 
wait 1. 

// event handler for staging
when stage:liquidfuel < 0.001 then { 
    print "No liquidfuel. Attempting to stage.".
    stage. 
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
        lock steering to up + R(0, theta, 0).
        print "theta: " + theta at (0,24).
        print "alt: " + ar at (0,25).
    }
    if ar > GT1 {
        lock steering to up + R(0, theta, -180).
    }

    // control speed
    // calculate target velocity
//     set vl to vt*0.9.
//     set vh to vt*1.1.
//     set vsm to velocity:surface:mag.
//     if vsm < vl { set th to 1. }
//     if vsm > vl and vsm < vh { set th to (vh-vsm)/(vh-vl). }
//     if vsm > vh { set th to 0. }
    print "alt:radar: " + ar at (0,27).
    print "velocity:surface: " + vsm at (0,28).
    print "target velocity: " + vt at (0,29).
    print "throttle: " + th at (0,30).
    wait 1.
}.
set th to 0.
print "T+" + round(missiontime) + " Fuel after atmosphere burn: " + stage:liquidfuel.
print "T+" + round(missiontime) + " Coasting to apoapsis in " + eta:apoapsis.

unlock steering.
unlock throttle.
wait 1.
set ship:control:pilotmainthrottle to 0.



// make a circularization node once we've passed atmosphere
wait until altitude > kerbin:atm:height.
set dv to (sqrt(kerbin:mu/tgtalt) - sqrt(kerbin:mu/obt:semimajoraxis)).
set x to node(time:seconds + eta:apoapsis, 0, 0, dv).
add x.

// iteratively fix the node
// "how many iterations could this possibly take?"
lock diff to x:orbit:semimajoraxis - tgtalt.
until abs(diff) < 1 {
    set x:prograde to x:prograde + KD * diff.
    wait 0.01.
    print " adjusting circularization node by " + KD * diff.
}.

run node.

lights on.


