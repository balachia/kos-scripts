run optim.ks.

//========================================
// sphere at (1,1,1)
function f {
    parameter l.
    local ret is 0.
    for x in l {
        set ret to ret + (x-1)^2.
    }.
    return ret.
}

set sphereinit to list().
sphereinit:add(0,0,0).
sphereinit:add(-1,0,0).
sphereinit:add(0,-1,0).
sphereinit:add(0,0,-1).

print "==============================".
print "test sphere (nmoptim)".
set res to nmoptim(sphereinit).
print "expect x=(1,1,1), y=0".
print res.

print "test sphere (nmoptim0)".
set res to nmoptim0(sphereinit[0]).
print "expect x=(1,1,1), y=0".
print res.

//========================================
// booth's function
function f {
    parameter l.
    local ret is (l[0]+2*l[1]-7)^2 + (2*l[0]+l[1]-5)^2. 
    return ret.
}

set boothinit to list().
boothinit:add(0,0).
boothinit:add(-1,0.
boothinit:add(0,-1).

print "==============================".
print "test booth (nmoptim)".
set res to nmoptim(boothinit).
print "expect x=(1,3), y=0".
print res.

print "test booth (nmoptim0)".
set res to nmoptim0(boothinit[0]).
print "expect x=(1,3), y=0".
print res.

//========================================
//rosenbrock banana function
function f {
    parameter l.
    local ret is (1-l[0])^2 + 100*(l[1]-(l[0])^2)^2.
    return ret.
}

set bananainit to list().
bananainit:add(0,0).
bananainit:add(-1,0).
bananainit:add(0,-1).

print "==============================".
print "test banana (nmoptim)".
set res to nmoptim(bananainit).
print "expect x=(1,1), y=0".
print res.

print "test banana (nmoptim0)".
set res to nmoptim0(bananainit[0]).
print "expect x=(1,1), y=0".
print res.


