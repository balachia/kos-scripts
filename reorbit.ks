parameter ta.
run ksplib.
trace("`reorbit` start at: " + time:calendar + " " + time:clock).

// at periapsis set maneuver node to hit target orbit
reapo(ta).
// set dv to burndv(body:radius + obt:periapsis, obt:semimajoraxis, 0.5*(2*body:radius + ta + obt:periapsis)).
// set x to node(time:seconds + eta:periapsis, 0, 0, dv).
// add x.

trace("transfer node set").
run node.
trace("transfer node done").

// at apoapsis, circularize
reperi(ta).
// set dv to burndv(body:radius + obt:apoapsis, obt:semimajoraxis, body:radius + ta).
// set x to node(time:seconds + eta:apoapsis, 0, 0, dv).
// add x.

trace("circularization node set").
run node.
trace("circularization node done").
