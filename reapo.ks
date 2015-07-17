parameter ta.
run orblib.ks.
local dv is burndv(body:radius + obt:periapsis, obt:semimajoraxis, 0.5*(2*body:radius + ta + obt:periapsis)).
local x is node(time:seconds + eta:periapsis, 0, 0, dv).
add x.
