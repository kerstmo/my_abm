
# runner iterates epidemic days for k random seeds, as long as infected agents
# left. additional exit conditions may be defined fulfilled. Population is
# created once


###############################
    ###    MAIN LOOP    ###
###############################

SEEDS = collect(1:SEEDS)

include(string("./population_builder/", population_builder)) # population remains same over all runs. create once

for seed in SEEDS # triggers n realisations with same seed
    Random.seed!(seed)
    global this_seed = seed
    global ITERATION = 0

    ################################################
        ###   CLEAR OR CREATE STATETISTICS   ###
    ################################################
    # statetistics dict is updated along all infection/progression/etc events
    # TODO: output to csv file on daily basis
    # TODO: create further outputs (i.e. infector vs infected)

    global STATETISTICS = nothing
    global STATETISTICS = Dict([("susceptible", POP_SIZE),
                        ("infected", 0),
                        ("recovered", 0),
                        ("cumInf", 0),
                        ("hh_isolation", 0),
                        ("vaccinated", 0)])

    include(string("./vaccination_model/",initial_vaccinations))
    include(string("./infection_model/", initial_infections))
    include(string("./contact_builder/", contact_builder))


##############################################
    ###  LOOP of ONE REALISATION/SEED  ###
##############################################

    global ITERATION = 1

    while STATETISTICS["infected"] != 0 && ENDITER > ITERATION

        include("./quarantineModel.jl")
        include(string("./infection_model/", infection_model))
        include("./progressionModel.jl")
        include("./report.jl")

        if update_contacts == true
            include(string("./contact_builder/", contact_builder))
        end

        global ITERATION += 1

    end

    include("./clearAgents.jl") # reset agents,statetistics etc to default for next run

end
