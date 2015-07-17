parameter ta.
run genlib.
trace("`reorbit` start at: " + time:calendar + " " + time:clock).

// at periapsis set maneuver node to hit target orbit
run reapo(ta).

trace("transfer node set").
run node.
trace("transfer node done").

// at apoapsis, circularize
run reperi(ta).

trace("circularization node set").
run node.
trace("circularization node done").
