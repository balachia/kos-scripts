parameter dt.
run ksplib.ks.

set p0 to ship:obt:period.
set p1 to p0 + dt.
set apo1 to (2*invperiod(p1) - 2*body:radius - periapsis).

run reapo(apo1).
