#Time parameters
start_time = 2012
end_time = 2112

#How much time passes between each successive calculation
time_step = 0.25 # years
end_step = ((end_time-start_time)/time_step)

#Parameters relating to the goats
grass_eaten_per_goat = 100 # (lbs/goats)/year
initial_goats = 105 # goats
normal_goat_birth_rate = 0.1 # 1/Year
average_goat_life_span = 10 # Year
time_for_goats_to_die = 1 # Year

function effect_of_grass_per_goat_on_goat_birth_rate_table(x)
    x = min(2,x)
    x = max(0,x)
    -0.4x^3 + 1.2x^2 - 0.3x + 0.5
end

#Parmaters relating to the field
normal_grass_growth_rate = 0.2 # 1/Year
average_grass_life_span = 10 # Years
initial_grass = 100000 #lbs
time_for_grass_to_die = 1 # Years

#Intialization
grass = initial_grass
goats = initial_goats

initial_grass_per_goat = grass / goats

model_time = [start_time]
goats_over_time = [goats]
grass_over_time = [grass]

#Run the model
for i = 1:end_step
    #first we must calculate our flows (our rates)    
    new_grass = normal_grass_growth_rate * grass
    grass_naturally_dead = grass / average_grass_life_span
    grass_eaten_by_goats = goats * grass_eaten_per_goat
    grass_deaths = min(grass/time_for_grass_to_die, grass_naturally_dead + grass_eaten_by_goats) # we can't kill more grass then there is

    grass_per_goat = grass / goats

    effect_of_grass_per_goat_on_goat_birth_rate = effect_of_grass_per_goat_on_goat_birth_rate_table(grass_per_goat / initial_grass_per_goat)
    goat_birth_rate = effect_of_grass_per_goat_on_goat_birth_rate * normal_goat_birth_rate

    new_goats = goat_birth_rate * goats
    goats_naturally_dead = goats / average_goat_life_span
    goats_dead_by_starvation = ( max(0, goats * grass_eaten_per_goat - grass / time_for_grass_to_die ) / grass_eaten_per_goat) / time_for_goats_to_die
    goat_deaths = min(goats / time_for_goats_to_die, goats_naturally_dead + goats_dead_by_starvation) # we can't kill more goats then there are

    #then we update our stocks
    grass = grass + new_grass - grass_deaths
    goats = goats + new_goats - goat_deaths
    
    model_time = [model_time,start_time + i * time_step]
    goats_over_time = [goats_over_time, goats]
    grass_over_time = [grass_over_time, grass]

end

println("Time,Goats,Grass")
for i = 1:length(model_time)
    print(model_time[i])
    print(",")
    print(goats_over_time[i])
    print(",")
    println(grass_over_time[i])
end

