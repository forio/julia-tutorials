function derivative(fn)
    return x ->begin
		h = x == 0 ? sqrt(eps(Float64)) : sqrt(eps(Float64)) * x
		xph = x + h
        dx = xph - x

		return (fn(xph) - fn(x)) / dx
	end
end
