run ksplib.
set nd to nextnode.

trace("Node in: " + round(nd:eta) + ", DeltaV: " + round(nd:deltav:mag)).
// trace("Node apoapsis: " + round(nd:apoapsis) + ", periapsis: " + round(nd:periapsis)).

// some kind of double engine bug -- use own func
set max_acc to stagethrust()/ship:mass.
set burn_duration to nd:deltav:mag/max_acc.
trace("Estimated burn duration: " + round(burn_duration) + "s (thr " + round(stagethrust(),2) + ")").

// warp?
// wait until nd:eta <= (burn_duration/2 + 60).

sas off.
rcs on.
set np to lookdirup(nd:deltav, ship:facing:topvector). //points to node, keeping roll the same.
lock steering to np.
wait until abs(np:pitch - facing:pitch) < 0.15 and abs(np:yaw - facing:yaw) < 0.15.
rcs off.
lock steering to nd.

run warp(nd:eta - burn_duration/2 - 10).

//the ship is facing the right direction, let's wait for our burn time
wait until nd:eta <= (burn_duration/2).

set done to False.
set tset to 0.
lock throttle to tset.
set dv0 to nd:deltav.
until done
{
    // 100% throttle until 1 second, accounting for changing thrust
    set max_acc to stagethrust()/ship:mass.
    set tset to min(nd:deltav:mag/max_acc, 1).

    // cut throttle once node direction faces opposite initial direction
    if vdot(dv0, nd:deltav) < 0
    {
        trace("End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1)).
        lock throttle to 0.
        break.
    }
    if nd:deltav:mag < 0.1
    {
        trace("Finalizing burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1)).
        wait until vdot(dv0, nd:deltav) < 0.5.
        lock throttle to 0.
        trace("End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1)).
        set done to True.
    }
}
unlock steering.
unlock throttle.
wait 1.

//we no longer need the maneuver node
remove nd.
sas on.
set ship:control:pilotmainthrottle to 0.
