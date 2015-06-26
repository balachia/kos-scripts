clearscreen.

print "Script start at: " + time:calendar + " " + time:clock.
sas on.
set sasmode to "stabilityassist".
set th to 1.
lock throttle to th. 
lock steering to up.
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
log "time,alt,speed,terminal,thrust,accel,gravity,atms" to draglog.csv.
lock outstr to time:seconds + "," + altitude + "," + ship:airspeed + "," + ship:termvelocity + "," + ship:maxthrust + "," + ship:sensors:acc:mag + "," + ship:sensors:grav:mag + "," + (ship:sensors:pres / kerbin:atm:sealevelpressure).
until altitude > 75000 {
    log outstr to draglog.csv.
}.

set th to 0.
unlock throttle.
unlock steering.
set ship:control:pilotmainthrottle to 0.

print "dragtest complete".

