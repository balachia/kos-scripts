parameter tgtspeed.

clearscreen.

run funcs.

global Ku is 0.06.
global Tu is 2*1.1.

global kp is 0.08.
global ki is 0.
global kd is 0.

// set kp to 0.6*ku.
// set ki to 2*kp / tu.
// set kp to (kp * tu)/8.

set kp to 0.8*ku.
set kd to (kp*tu)/8.

print "Script start at: " + time:calendar + " " + time:clock.
sas on.
set sasmode to "stabilityassist".
set th to 1.
lock throttle to th. 
lock steering to up + R(0,0,-180).
print "T-1  All systems GO. Ignition!". 
wait 1. 

// event handler for staging
when stage:liquidfuel < 0.001 then { 
    print "No liquidfuel. Attempting to stage.".
    stage. 
    preserve.
}

switch to 0.

// header
global t0 is missiontime.
wait until missiontime > t0.
global p0 is (tgtspeed - ship:airspeed).
global I is 0.
// log "time,alt,speed,mass,thrust,accel,gravity,atms" to ("draglog" + tgtspeed + ".csv").
lock outstr to missiontime + "," + altitude + "," + ship:airspeed + "," + ship:mass + "," + currthrust() + "," + ship:sensors:acc:mag + "," + ship:sensors:grav:mag + "," + (ship:sensors:pres / kerbin:atm:sealevelpressure) + "," + tgtspeed.
lock tunestr to missiontime + "," + Kp + "," + tgtspeed + "," + ship:airspeed.
until altitude > 75000 {
    set dt to missiontime - t0.
    if tgtspeed > 0 {
        set P to (tgtspeed - ship:airspeed).
        set I to I + P*dt.
        set D to ((p-p0)/dt).
        set dth to Kp * P + Ki * I + Kd * d.
        set th to max(0,min(1,th + dth)).

        // update state variables
        set t0 to missiontime.
        set p0 to p.
        print "T+" + round(missiontime) + " th " + th + " dth " + dth + " spd " + ship:airspeed.
    }

    // log outstr to ("draglog" + tgtspeed + ".csv").
    log outstr to "draglog.csv".
    // log tunestr to dragtune.csv.
    wait 0.1.
}.

set th to 0.
unlock throttle.
unlock steering.
set ship:control:pilotmainthrottle to 0.

print "dragtest complete".

