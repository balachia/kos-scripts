// based on http://ksp.baldev.de/kos/far2/far2.txt
// take "Orbiter 2" to orbit
clearscreen. 
// constants.
set e to 2.71828182846.
// warp (0:1) (1:5) (2:10) (3:50) (4:100) (5:1000)
// gravity turn parameters.
set gt0 to 1000.
set up0 to 0.
set gt1 to 50000.
set th1 to 90.

print "Script start at: " + time:calendar + " " + time:clock.
set th to 1.
lock throttle to th. 
lock steering to up + R(0, 0, -180).
print "T-1  All systems GO. Ignition!". 
wait 1. 
stage. 
print "T+" + round(missiontime) + "  Liftoff.".

// event handler for staging
// when stage:liquidfuel < 2880 then { print "T+" + round(missiontime) + " Booster separation.". stage. }

// event handler for staging
when stage:liquidfuel = 0 then { 
    print "T+" + round(missiontime) + " Stage separation.". 
    stage. 
    wait 1. 
    print "T+" + round(missiontime) + " Stage ignition.". 
    stage. 
}

when alt:radar > gt0 then {
    print "T+" + round(missiontime) + " Beginning gravity turn.". 
}

// control speed and attitude
set vt to 200.
when alt:radar > 13000 then { set vt to 2500. }
until apoapsis > 100500 {
    set ar to alt:radar.
    // control attitude
    if ar > gt0 and ar < gt1 {
        set arr to (ar - gt0) / (gt1 - gt0).
        set pda to (cos(arr * 180) + 1) / 2.
        set theta to th1 * ( pda - 1 ).
        lock steering to up + R(0, theta, -180).
        print "theta: " + theta at (0,24).
        print "alt: " + ar at (0,25).
    }
    if ar > gt1 {
        lock steering to up + R(0, theta, -180).
    }
    // control speed
    // calculate target velocity
    set vl to vt*0.9.
    set vh to vt*1.1.
    set vsm to velocity:surface:mag.
    if vsm < vl { set th to 1. }
    if vsm > vl and vsm < vh { set th to (vh-vsm)/(vh-vl). }
    if vsm > vh { set th to 0. }
    print "alt:radar: " + ar at (0,27).
    print "velocity:surface: " + vsm at (0,28).
    print "target velocity: " + vt at (0,29).
    print "throttle: " + th at (0,30).
    wait 1.
}.
lock throttle to 0. 
print "T+" + round(missiontime) + " Fuel after atmosphere burn: " + stage:liquidfuel.
print "T+" + round(missiontime) + " Coasting to apoapsis @ 100km.".

// maneuver node for circularisation
// calculate orbital velocity
set G to 6.6738*10^-11.
set mk to 5.2915*10^22.     // mass of Kerbin
set rk to 600000.           // radius of Kerbin
set r to rk + apoapsis.
set ov to (G * mk / r)^0.5. // orbital velocity for circular orbit
print "T+" + round(missiontime) + " Orbital speed: " + ov.

// calculate maneuver properties

// Errors in calculation: a) velocity points upward, b) traveling to apoapsis
// causes horizont to turn "down". Calculation is correct only at apoapsis.
// Thus burn parameters are adjusted while travelling to apoapsis.

set maxda to maxthrust/mass.
print "T+" + round(missiontime) + " Max DeltaA for engine: " + maxda.
set vom to velocity:orbit:mag.
set dv to (ov - vom).
set tfb to dv/maxda.
print "T+" + round(missiontime) + " DeltaV for final burn: " + dv.
print "T+" + round(missiontime) + " Duration of final burn: " + tfb.

set x to node(time:seconds + eta:apoapsis, 0, 0, dv).
add x.
// warp only 
when alt:radar > 50000 then { set warp to 2. }
when eta:apoapsis < tfb/2 + 30 then { set warp to 0. }
lock steering to x.
// iteratively correct burn parameters
until eta:apoapsis < tfb/2 {
    set vom to velocity:orbit:mag.
    set dv to ov - vom.
    set tfb to dv/maxda.
    set x:prograde to dv.
    print "DeltaV for final burn: " + dv at (0,29).
    print "Duration of final burn: " + tfb at (0,30).
    wait 1.
}
print "T+" + round(missiontime) + " DeltaV for final burn: " + dv.
print "T+" + round(missiontime) + " Duration of final burn: " + tfb.
// lock steering to node:prograde which wanders off at small deltav
when x:deltav:mag < 2 * maxda then { 
    print "T+" + round(missiontime) + " Reducing throttle, fuel:" + stage:liquidfuel.
    // continue to accelerate x:prograde
    unlock steering.
    sas on.
}
print "T+" + round(missiontime) + " Orbital burn start " + round(eta:apoapsis) + " s before apoapsis.".
set th to 1.
lock throttle to th.
until velocity:orbit:mag > ov {
    set thrust to maxthrust * throttle.
    set da to thrust/mass.
    set newth to x:deltav:mag * mass / maxthrust.
    if x:deltav:mag < 2 * da and newth > 0.2 {
        set th to newth.
    }
    print "Thrust: " + thrust at (0,28).
    print "DeltaA: " + da at (0,29).
    print "Node DeltaV: " + x:deltav:mag at (0,30).
}
lock throttle to 0.
remove x.
print "T+" + round(missiontime) + " Orbit complete, apoapsis: " + apoapsis + ", periapsis: " + periapsis.
print "T+" + round(missiontime) + " Fuel in orbit: " + stage:liquidfuel.
print "T+" + round(missiontime) + " Turning to expose solar panels...".
sas off.
lock steering to prograde+R(-90,0,0).
if 0 {
    wait until abs(steering:pitch - facing:pitch) < 1.
    unlock steering.
}
print "T+" + round(missiontime) + " Configuring for orbit...".
lights on.
ag2 on.
