parameter ta.
run orblib.ks.
local dv is burndv(body:radius + obt:apoapsis, obt:semimajoraxis, 0.5*(2*body:radius + ta + obt:apoapsis)).
local x is node(time:seconds + eta:apoapsis, 0, 0, dv).
add x.
