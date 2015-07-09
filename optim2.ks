run lib_exec2.

function gdoptim {
    parameter fstr.
    parameter f0.

    lock f to 0.
    execute(fstr).

    local maxiter is 250.
    local ep is 1e-6.       // numderiv epsilon (should be limit for centered diff)
    local x0 is f0.
    local y0 is 0.
    set l to x0.            // bound variable for f; throws errors if l is formally declared
    set y0 to f.            // evaluate f(l)
    local x1 is f0.
    local y1 is y0.
    local feval is 0.       // # of f evaluations
    local iter is 1.        // # gd iterations
    local done is false.
    until done {
        local grad is list().
        local i is 0.
        set x0 to x1:copy.
        set y0 to y1.
        until i = x1:length {
            // get gradient
            set l to x0.
            set l[i] to x0[i] - ep.
            set fm to f.
            set l[i] to x0[i] + ep.
            set fp to f.
            grad:add((fp-fm)/(2*ep)).
            set i to i+1.
        }.
        set feval to feval + 2*x1:length.

        // backtrace
        // TODO: maybe remember old a setting?
        // otoh, we have 2m function evaluations per gradient, so this might be cheaper
        local a is 2.
        local m is 0.   // expected change in y
        local xdist is 0.
        local btdone is false.
        until btdone {
            set x1 to list().   // re-using old x1 seems to give reference errors?
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

        print "GD iter " + iter + " feval " + feval + " (" + xdist + ", final a " + a + ")".
        set iter to iter+1.
        set done to (iter > maxiter) or (xdist < 1e-4).
    }.
    print "GD f evaluations: " + feval.
    if (iter > maxiter) {
        print "GD hit max iterations".
    }.
    return x1.
}.
