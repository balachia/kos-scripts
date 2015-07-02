run lib_exec2.

function gdoptim {
    parameter fstr.
    parameter finit.

    lock f to 0.
    execute(fstr).

    local a is 0.1.
    local ep is 0.000001.   // numderiv epsilon (this should be limit for centered diff).
    local x0 is finit.
    local y0 is 0.
    set l to x0.
    set y0 to f.
    local x1 is finit.
    local y1 is y0.
    local feval is 0.       // # of f evaluations
    local iter is 1.        // # gd iterations
    local done is false.
    until done {
        local grad is list().
        local i is 0.
        set x0 to x1:copy.
        set y0 to y1.
        local xdist to 0.
        until i = x1:length {
            // get gradient
            set l to x0.
            set l[i] to x0[i] - ep.
            set fm to f.
            set l[i] to x0[i] + ep.
            set fp to f.
            grad:add((fp-fm)/(2*ep)).
            set feval to feval + 2.

            // set gradient to movement vector
            // set grad[i] to -a*grad[i].
            // set xdist to xdist + (grad[i])^2.
            // set x1[i] to x1[i] + grad[i].
            set i to i+1.
        }.

        // backtrace
        local a is 8.
        local m is 0.
        local btdone is false.
        until btdone {
            set x1 to list().
            set m to 0.
            set i to 0.
            until i = x0:length {
                x1:add(x0[i] - a*grad[i]).
                set m to m - a*(grad[i])^2.
                set i to i+1.
            }
            set xdist to sqrt(-a*m).
            set l to x1.
            set y1 to f.
            set feval to feval + 1.
            set btdone to (xdist < 1e-4) or (y1 < y0 + 0.5*m).
            if not btdone {
                set a to 0.5*a.
            }.
        }.

        print "GD iter " + iter + " (" + xdist + ", final a " + a + ")".
        set iter to iter+1.
        set done to xdist < 1e-4.
    }.
    print "f evaluations: " + feval.
    return x1.
}.
