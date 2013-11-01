# This code and all turorial code can be found on https://github.com/forio/julia-tutorials

function is_divisible(dividend, divisor)
    return dividend % divisor == 0
end

function is_prime(n::Int64)
    if n <= 3
        return true
    end

    if n % 2 == 0
        return false
    end
    
    # initialize a counter variable
    i = 3
    
    while i <= sqrt(n)
        if n % i == 0
            return false
        end
        
        i += 2
    end

    return true
end

print(is_prime(10002021))
