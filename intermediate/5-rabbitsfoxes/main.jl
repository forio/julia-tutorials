# This code and all turorial code can be found on https://github.com/forio/julia-tutorials

#Time parameters
start_time = 0
end_time = 100

#How much time passes between each successive calculation
time_step = 1/4 # years
end_step = int(((end_time-start_time)/time_step))

initial_rabbits = 30000 #The number of rabbits when the simulation is started. (Rabbits)
initial_foxes = 15 #The number of foxes when the simulation is started (Foxes)
rabbits_killed_per_fox_birth = 1000 #The number of rabbits that must be killed for a fox to be born. (Rabbits/Fox)
chance_a_rabbit_will_die_during_a_meeting = 0.50 #The chance a rabbit will die when a rabbit fox cross paths. (dmnl)
chance_of_rabbit_and_fox_meeting = 0.02 #The chance that a rabbit and fox will cross paths. (dmnl)
rabbit_growth_rate = 0.20 # The percent of the rabbit population that will be born this time step. (1/Year)
fox_death_rate = 0.10 #The percent of the fox population that will die this time step from old age. (1/Year)

rabbits_over_time = fill(0.0, end_step+1)
foxes_over_time = fill(0.0, end_step+1)
model_time = fill(0.0, end_step+1)

rabbits = initial_rabbits
foxes = initial_foxes

rabbits_over_time[1] = rabbits
foxes_over_time[1] = foxes

#Run the model
for sim_step = 1:end_step
    # Get the time from the step
    sim_time = start_time + sim_step * time_step
    model_time[sim_step] = sim_time

    #first we must calculate our flows (our rates)    
    rabbit_births = rabbits * rabbit_growth_rate       
    rabbits_eaten = min(rabbits, chance_a_rabbit_will_die_during_a_meeting * chance_of_rabbit_and_fox_meeting * foxes * rabbits)
    
    fox_births = 1/rabbits_killed_per_fox_birth * rabbits_eaten 
    fox_deaths = foxes * fox_death_rate

    #then we update our stocks
    foxes = foxes + fox_births - fox_deaths
    rabbits = rabbits + rabbit_births - rabbits_eaten
    
    #stock values always update in the next time step
    rabbits_over_time[sim_step+1] = rabbits
    foxes_over_time[sim_step+1] = foxes
end

println("Time,Rabbits (Thousands),Foxes")
for i = 1:end_step
    print(model_time[i])
    print(",")
    print(rabbits_over_time[i]/1000)
    print(",")
    println(foxes_over_time[i])
end
