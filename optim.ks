run lib_exec2.

// let's try to implement nelder-mead?
// assuming minimizing a function f that takes a list of arguments and returns the objective
function nmoptim {
    parameter fstr.
    parameter f0.

    lock f to 0.
    execute(fstr).

    local maxiter is 300.
    local ys is list().
    local ord is list().
    local xs is f0.
    // initial points
    for x in xs {
        print x.
        // ys:add(f(x)).
        set l to x.
        ys:add(f).
    }.
    local feval is ys:length.
    print ys.
    local imax is ys:length-1.
    // 1 order
    set ord to sort(ys).
    set xs to order(xs,ord).
    set ys to order(ys,ord).

    // not sure if this is the best criterion
    local continue is false.
    local iter is 0.
    local done is false.
    until done {
        print "NM " + iter + " (min " + ys[0] + ", max " + ys[imax] + ")".
        set continue to false.

        // 2 centroid
        set xo to centroid(xs).

        // 3 reflect (go to 1 if not best)
        set xr to transform(xs[imax],xo,1).
        //set yr to f(xr).
        set l to xr.
        set yr to f.
        set feval to feval + 1.
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
                // set ye to f(xe).
                set l to xe.
                set ye to f.
                set feval to feval + 1.
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
            // set yc to f(xc).
            set l to xc.
            set yc to f.
            set feval to feval + 1.
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
                // set ys[i] to f(xs[i]).
                set l to xs[i].
                set ys[i] to f.
                set feval to feval + 1.
                set i to i+1.
            }
        }

        // 1 order
        set ord to sort(ys).
        set xs to order(xs,ord).
        set ys to order(ys,ord).
        set iter to iter + 1.
        set done to (iter > maxiter) or (ys[imax] - ys[0] < 0.000001).
    }.
    print "f evaluations: " + feval.
    if (iter > maxiter) {
        print "hit max iterations, probably did not converge".
    }.
    return xs[0].
}

function nmoptim0 {
    parameter fstr.
    parameter x0.
    local f0 is list(x0).
    local i is 0.
    until i = x0:length {
        local fi is x0:copy.
        set fi[i] to fi[i] + 1.
        f0:add(fi).
        set i to i+1.
    }
    return nmoptim(fstr,f0).
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
    local ord is list(0).
    local i is 1.
    until i = l:length {
        ord:add(0).
        local x is l[i].
        local j is i.
        until j = 0 or l[j-1] <= x {
            set ord[j] to ord[j-1].
            set j to j-1.
        }.
        set ord[j] to i.
        set i to i+1.
    }.
    return ord.
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
