function moon_position(time::Float64)
    moon_angle = MOON_INITIAL_ANGLE + 2.0pi * time / MOON_PERIOD
    x::Float64 = DISTANCE_TO_MOON * cos(moon_angle)
    y::Float64 = DISTANCE_TO_MOON * sin(moon_angle)

    return [x, y]
end

function update(me::Moon, time)
    me.position = moon_position(time)

    me
end