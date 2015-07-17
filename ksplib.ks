// return engine thrusts cause something is bugged right now
function stagethrust {
    local thrust is 0.
    local englist is list().
    list engines in englist.
    for eng in englist {
        if eng:stage = stage:number {
            set thrust to thrust + eng:maxthrust.
        }
    }.
    return thrust.
}

// return active engine thrusts
function currthrust {
    local thrust is 0.
    local englist is list().
    list engines in englist.
    for eng in englist {
        if eng:stage = stage:number {
            set thrust to thrust + eng:thrust.
        }
    }.
    return thrust.
}

// return effective stage isp
function stageisp {
    local ispsum is 0.
    local flowsum is 0.
    local flow is 0.
    local englist is list().
    list engines in englist.
    for eng in englist {
        if eng:stage = stage:number {
            set flow to (eng:maxthrust / eng:visp).
            // set ispsum to ispsum + (flow * eng:visp).
            set ispsum to ispsum + eng:maxthrust.
            // set flowsum to flowsum + flow.
            set flowsum to flowsum + (eng:maxthrust / eng:visp).
        }
    }.
    if flowsum = 0 {
        return 0.
    } else {
        return (ispsum / flowsum).
    }.
}

function rtantennae {
    local ms is ship:modulesnamed("ModuleRTAntenna").
    for m in ms {
        if m:hasevent("activate") {
            m:doevent("activate").
        }
    }.
}.

