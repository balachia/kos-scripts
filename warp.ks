parameter dt.
run genlib.ks.
// warp (0:1) (1:5) (2:10) (3:50) (4:100) (5:1000)
set dt to round(dt).
set t0 to round(time:seconds).
set t1 to t0 + dt.
set warpmode to "RAILS".
trace("Warp for " + dt + "s").
if dt > 3000 {
    trace("Warp 5.").
    set warp to 5.
}
if dt > 3000 {
    when time:seconds > t1 - 3000 then {
        trace("Warp 4.").
        set warp to 4.
    }
}
if dt > 300 and dt <= 3000 {
    trace("Warp 4.").
    set warp to 4.
}
if dt > 300 {
    when time:seconds > t1 - 300 then {
        trace("Warp 3.").
        set warp to 3.
    }
}
if dt > 10 and dt < 300 {
    trace("Warp 3.").
    set warp to 3.
}
if dt > 60 {
    when time:seconds > t1 - 60 then {
        trace("Warp 2.").
        set warp to 2.
    }
}
if dt > 30 {
    when time:seconds > t1 - 30 then {
        trace("Warp 1.").
        set warp to 1.
    }
}
if dt > 10 {
    when time:seconds > t1 - 10 then {
        trace("Realtime, " + round(t1-time:seconds) + "s remaining.").
        set warp to 0.
    }
}
wait until time:seconds > t1.
trace("Warp complete " + time:calendar + " " + time:clock).
