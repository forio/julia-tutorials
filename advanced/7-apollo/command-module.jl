function acceleration(time::Float64, pos::Vector{Float64})
    moon_pos = moon_position(time)
    
    distance_from_earth = pos
    distance_to_moon = pos - moon_pos
    mag_e = magnitude(distance_from_earth)
    mag_m = magnitude(distance_to_moon)
    return -G * (ME * distance_from_earth / mag_e^3 + MM * distance_to_moon / mag_m^3)
end


function update(me::Command_Module, time::Float64, h::Float64)
    acceleration0 = acceleration(time, me.position)
    velocityE = me.velocity + h * acceleration0
    positionE = me.position + h * me.velocity
    velocityH = me.velocity + h * 0.5 * (acceleration0 + acceleration(time + h, positionE))
    positionH = me.position + h * 0.5 * (me.velocity + velocityH)

    me.velocity = velocityH
    me.position = positionH
    
    me.positionH = positionH
    me.velocityH = velocityH
    me.positionE = positionE
    me.velocityE= velocityE

    me
end