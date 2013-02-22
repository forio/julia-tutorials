function is_divisible(dividend, divisor)
	return dividend % divisor == 0
end

function is_prime(n::Int64)
	if is_divisible(n, 2)
		return false
	end

	i = 3	

	while i <= sqrt(n)
		if is_divisible(n, i)
			return false
		end	

		i += 2
	end

	return true
end

print(is_prime(10002021))
