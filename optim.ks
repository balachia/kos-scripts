// let's try to implement nelder-mead?
// assuming minimizing a function f that takes a list of arguments and returns the objective
function nmoptim {
    parameter finit.
    local ys is list().
    local ord is list().
    local xs is list().
    // initial points
    for x in xs {
        ys:add(f(x)).
    }.
    local imax is ys:length-1.
    // 1 order
    set ord to sort(ys).
    set xs to order(xs,ord).
    set ys to order(ys,ord).

    // not sure if this is the best criterion
    local continue is false.
    local count is 0.
    until ys[imax] - ys[0] < 1e-5 {
        print "NM " + count + " (" + ys[0] + ", " + ys[imax] ")".
        set continue to false.

        // 2 centroid
        set xo to centroid(xs).

        // 3 reflect (go to 1 if not best)
        set xr to transform(xs[imax],xo,1).
        set yr to f(xr).
        if yr >= ys[0] and yr < ys[imax - 1] {
            set ys[ys:length-1] to yr.
            set xs[xs:length-1] to xr.
        } else {
            set continue to true.
        }

        // 4 expand (go to 1 or 5)
        if continue {
            if yr < ys[0] {
                set xe to transform(xs[imax],xo,2).
                set ye to f(xe).
                if ye < yr {
                    set ys[imax] to ye.
                    set xs[imax] to xe.
                } else {
                    set ys[imax] to yr.
                    set xs[imax] to xr.
                }
                set continue to false.
            }.
        }.

        // 5 contract (go to 6 or 5)
        if continue {
            set xc to transform(xs[imax],xo,-0.5).
            set yc to f(xc).
            if yc < ys[imax] {
                set ys[imax] to yc.
                set xs[imax] to xc.
                set continue to false.
            }
        }

        // 6 reduce
        if continue {
            local i is 1.
            until i = xs:length {
                set xs[i] to transform(xs[i],xs[0],0.5).
                set ys[i] to f(xs[i]).
                set i to i+1.
            }
        }

        // 1 order
        set ord to sort(ys).
        set xs to order(xs,ord).
        set ys to order(ys,ord).
        set count to count + 1.
    }.
    return xs[0].
}

function nmoptim0 {
    parameter x0.
    local finit is list(x0).
    local i is 0.
    until i = x0:length {
        local fi is x0:copy.
        set fi[i] to fi[i] + 1.
        finit:add(fi).
        set i to i+1.
    }
    return nmoptim(finit).
}

function centroid {
    parameter xs.
    local cent is list().
    for xi in xs[0] { cent:add(0). }.
    for x in xs {
        local i is 0.
        until i = x:length {
            set cent[i] to cent[i] + x[i].
            set i to i + 1.
        }
    }.

    // take average
    local i is 0.
    until i = cent:length {
        set cent[i] to cent[i] / xs:length.
        set i to i+1.
    }.
    return cent.
}

// x' = xo + a(xo-x)
function transform {
    parameter x.
    parameter xo.
    parameter a.
    local ret is list().
    local i is 0.
    until i = x:length {
        ret:add((1+a)*xo[i] - a*x[i]).
        set i to i+1.
    }.
    return ret.
}.

// insertion sort, returns order
function sort {
    parameter l.
    local order is list(0).
    local i is 1.
    until i = l:length {
        local x is l[i].
        local j is i.
        until j = 0 or l[j-1] <= x {
            set order[j] to j-1.
            set j to j-1.
        }.
        set order[j] to i.
    }.
    return order.
}

function order {
    parameter l.
    parameter ord.
    local ret is list().
    for i in ord {
        ret:add(l[i]).
    }
    return ret.
}.
