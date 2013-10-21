module queuingSystem

export random_gaussian, Queuing_System, run_to_end

function random_gaussian(mean::Float64, std_dev::Float64)
    mean + (rand() - 0.5) * std_dev
end

type Queuing_System
    ## These variables are set directly by the creator
    arrival_times::Array{Float64,1}
    service_times::Array{Float64,1}
    warm_up_time::Float64
    run_time::Float64
    servers::Int

    ## Internal variables - Set by constructor
    sim_time::Float64
    warmed_up::Bool
    in_system::Int
    arrival_index::Int
    service_index::Int

    next_to_complete::Int
    open_server::Int
    next_completion::Array{Float64,1} ## by server
    next_arrival::Float64
    next_exit::Float64
    
    # Constructor definition
    function Queuing_System(arrival_times::Array{Float64,1},
                            service_times::Array{Float64,1},
                            warm_up_time::Float64,
                            run_time::Float64,
                            servers::Int)
        sim_time = 0.0
        warmed_up = false
        in_system = 0
        arrival_index = 2
        service_index = 1
        
        next_to_complete = typemax(Int)
        open_server = 1
        
        next_completion = fill(typemax(Int), servers)

        next_arrival = arrival_times[1]
        next_exit = typemax(Int)

        new(arrival_times,
            service_times,
            warm_up_time,
            run_time,
            servers,
            sim_time,
            warmed_up,
            in_system,
            arrival_index,
            service_index,
            next_to_complete,
            open_server,
            next_completion,
            next_arrival,
            next_exit
        )
    end
end

function warm_up(qs::Queuing_System)
    println("Warming up")
    while qs.sim_time < qs.warm_up_time
        next_event(qs)
    end
    qs.warmed_up = true
    println("Warmed up")
end

function run_to_end(qs::Queuing_System)
    if !qs.warmed_up
        warm_up(qs)
    end

    while qs.sim_time < qs.warm_up_time + qs.run_time
        next_event(qs)
    end
end

function next_event(qs::Queuing_System)
    # If we have customers arriving before the next customer exits
    if qs.next_arrival <= qs.next_exit

        # Update the sim time to the time at which the next customer arrives
        qs.sim_time = qs.next_arrival

        # Increment the number of customers in the system
        qs.in_system += 1
        
        # Get the next arrival after this one
        qs.next_arrival = next_arrival(qs)
        
        # If we have fewer customers in the system then servers
        # We can go ahead and process our next customer
        if qs.in_system <= qs.servers
            # When will the available server finish processing its next customer?
            qs.next_completion[qs.open_server] = qs.sim_time + next_service(qs)
            speak(qs, "Customer arrived at server $(qs.open_server) will be done at $(qs.next_completion[qs.open_server])")
        else
            # In the case where we have more customers in the system than servers
            # Customers will have to wait in queue
            speak(qs,"Customer arrived and is waiting in line")
        end
        
    else
        # A customer is exiting before the next arrival

        # Set sim time to the time of the next exit
        qs.sim_time = qs.next_exit

        # Decrement the number of customers in the system
        qs.in_system -= 1

        # Set this to a dummy value for now
        qs.next_completion[qs.next_to_complete] = typemax(Int)        

        speak(qs, "Person exited from server $(qs.next_to_complete)")

        # If we have more customers in the system than servers
        if qs.in_system >= qs.servers
            # When will the next available server finish processing its current customer?
            qs.next_completion[qs.next_to_complete] = qs.sim_time + next_service(qs)
            speak(qs,"Customer exited line to see server $(qs.next_to_complete) will be done at $(qs.next_completion[qs.next_to_complete])")
        end
    end

    qs.next_exit = typemax(Int)
    qs.next_to_complete = -1
    qs.open_server = -1

    # For each server
    for i=1:qs.servers
        # If this server will finish before our current next_exit time
        if qs.next_completion[i] < qs.next_exit
            # Set the next exit time to that of server i
            qs.next_exit = qs.next_completion[i]

            # Designate this server as the next server to complete
            qs.next_to_complete = i
        end
        
        # Set an open server if one is available
        if qs.next_completion[i] == typemax(Int) && qs.open_server == -1
            qs.open_server = i
        end
    end
end

# Gets the next arrival time
function next_arrival(qs::Queuing_System)
    val = qs.arrival_times[qs.arrival_index]
    qs.arrival_index += 1
    val
end

# Gets them next service time
function next_service(qs::Queuing_System)
    val = qs.service_times[qs.service_index]
    qs.service_index += 1
    val
end

# Outputs time and a message
function speak(qs::Queuing_System, words::String)
    if qs.warmed_up
        println("$(qs.sim_time) : $words")
    end
end

end
