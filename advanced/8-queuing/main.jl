# This code and all turorial code can be found on https://github.com/forio/julia-tutorials

using queuingSystem

## USER DECISIONS

warm_up_time = 43.0
run_time = 20160.0

# Standard Deviation = Mean * Coefficient of Variance
coeff_of_variance = 1

# Average Arrival Time
mean_iat = 3.0

# Average length of service
mean_los = 9.0

# Number of servers
num_servers = 4

## END USER DECISIONS

# Standard deviation in length of service
std_dev_los = mean_los * coeff_of_variance

# Standard deviation in arrival time
std_dev_iat = mean_iat * coeff_of_variance

# Initialize some empty vectors to hold our arrival rates
# and service times
arrival_times = Float64[]
service_times = Float64[]

max_arrivals = 15000 # simulate for no more than 15,000 customers
prev_arrival = 0 # first arrival is at time = 0

# Generate some random numbers to represent customer arrivals and service times
for i=1:max_arrivals
    # Generate a random arrival time using the normal distribution
    prev_arrival += random_gaussian(mean_iat,std_dev_iat)

    # Generate a random service time using the normal distribution
    prev_los = random_gaussian(mean_los,std_dev_los)

    # Equivalent to push(arrival_times, prev_arrival)
    # Push our random values into an array
    arrival_times = push!(arrival_times, prev_arrival)
    service_times = push!(service_times, prev_los)
end

# Create our new queuing system
qs = Queuing_System(arrival_times, service_times, warm_up_time, run_time, num_servers)

# Run the simulation
run_to_end(qs)
