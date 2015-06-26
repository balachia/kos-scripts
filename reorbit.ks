parameter tgtalt.       // target altitude

clearscreen. 
print "Script start at: " + time:calendar + " " + time:clock.
sas on.
set sasmode to "stabilityassist".

// at periapsis set maneuver node to hit target orbit
// set dv to (sqrt(body:mu * ((2/(body:radius + obt:periapsis)) - (2/(2*body:radius + tgtalt + obt:periapsis)))) - sqrt(body:mu * ((2/(body:radius + obt:periapsis)) - (1/obt:semimajoraxis)))).
set dv to (visvisa(body:radius + obt:periapsis, 0.5*(2*body:radius + tgtalt + obt:periapsis)) - visvisa(body:radius + obt:periapsis, obt:semimajoraxis)).
set x to node(time:seconds + eta:periapsis, 0, 0, dv).
add x.

print "transfer node set".

run node.

print "transfer node done".

// at apoapsis, circularize
// set dv to (sqrt(body:mu * ((2/(body:radius + obt:apoapsis)) - (1/(body:radius + tgtalt)))) - sqrt(body:mu * ((2/(body:radius + obt:apoapsis)) - (1/obt:semimajoraxis)))).
set dv to (visvisa(body:radius + obt:apoapsis, body:radius + tgtalt) - visvisa(body:radius + obt:apoapsis, obt:semimajoraxis)).
set x to node(time:seconds + eta:apoapsis, 0, 0, dv).
add x.

print "circularization node set".

run node.

print "circularization node done".

