run optim.ks.
run optim2.ks.

set res to 0.

//========================================
// sphere at (1,1,1)
set fstr to "function f {
    parameter l.
    local ret is 0.
    for x in l {
        set ret to ret + (x-1)^2.
    }.
    return ret.
}".
set fstr to "lock f to (l[0]-1)^2+(l[1]-1)^2+(l[2]-1)^2.".

set sphereinit to list().
sphereinit:add(list(0,0,0)).
sphereinit:add(list(-1,0,0)).
sphereinit:add(list(0,-1,0)).
sphereinit:add(list(0,0,-1)).

print "==============================".
print "test sphere (nmoptim)".
// set res to nmoptim(fstr,sphereinit).
print "expect x=(1,1,1), y=0".
print res.

print "test sphere (nmoptim0)".
// set res to nmoptim0(fstr,sphereinit[0]).
print "expect x=(1,1,1), y=0".
print res.

print "test sphere (gdoptim)".
set res to gdoptim(fstr,sphereinit[0]).
print "expect x=(1,1,1), y=0".
print res.

//========================================
// booth's function
set fstr to "function f {
    parameter l.
    local ret is (l[0]+2*l[1]-7)^2 + (2*l[0]+l[1]-5)^2. 
    return ret.
}".
set fstr to "lock f to (l[0]+2*l[1]-7)^2 + (2*l[0]+l[1]-5)^2.".


set boothinit to list().
boothinit:add(list(0,0)).
boothinit:add(list(-1,0)).
boothinit:add(list(0,-1)).

print "==============================".
print "test booth (nmoptim)".
// set res to nmoptim(fstr,boothinit).
print "expect x=(1,3), y=0".
print res.

print "test booth (nmoptim0)".
// set res to nmoptim0(fstr,boothinit[0]).
print "expect x=(1,3), y=0".
print res.

print "test booth (gdoptim)".
set res to gdoptim(fstr,boothinit[0]).
print "expect x=(1,3), y=0".
print res.

//========================================
//rosenbrock banana function
set fstr to "function f {
    parameter l.
    local ret is (1-l[0])^2 + 100*(l[1]-(l[0])^2)^2.
    return ret.
}".
set fstr to "lock f to (1-l[0])^2 + 100*(l[1]-(l[0])^2)^2.".

set bananainit to list().
bananainit:add(list(0,0)).
bananainit:add(list(-1,0)).
bananainit:add(list(0,-1)).

print "==============================".
print "test banana (nmoptim)".
// set res to nmoptim(fstr,bananainit).
print "expect x=(1,1), y=0".
print res.

print "test banana (nmoptim0)".
// set res to nmoptim0(fstr,bananainit[0]).
print "expect x=(1,1), y=0".
print res.

print "test banana (gdoptim)".
set res to gdoptim(fstr,bananainit[0]).
print "expect x=(1,1), y=0".
print res.



