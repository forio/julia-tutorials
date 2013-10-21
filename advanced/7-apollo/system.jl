function update(me::EarthMoonSystem, time::Float64, h::Float64)
    me.time = time

    update(me.moon, time)
    update(me.command_module, time, h)

    return me
end
