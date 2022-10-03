
########################################################
    ###   DEFINE AGENT AND HOUSEHOLD STRUCTURE  ###
########################################################
# dictionary stores agent identifier as key and agent struct with properties
# as value. used to store infection, progression and other details. age is an
# example for sociodemographics atm and is not used in simulations yet. dict
# keys / agents are used for looping over entire populatioon as well. same for
# household
SEX = ["female", "male"]


struct household
    household_id::Int
    member_ids
end

mutable struct agent
    agent_id::Int32
    household_id::Int32
    age::Int8
    sex::String
    state::String
    in_quar::Bool
    time_infected::Int8
    time_recov::Int8
    contacts_hh
    contacts_other
    vaccinated::Bool
end



#############################################################
    ###   CONSTRUCT AGENTS WITH HOUSEHOLD STRUCTURE   ###
#############################################################
# agents are generated randomly in householdsprintln(" ")
println(" ")
println("=.=.=:=.=.=.=.=.=.=.=.=.=.=.=.=")
println("A New Hope")
println("------------")

# import Pkg
# Pkg.add("Setfield")
# Pkg.add("Tables")

using Distributions
using Random
using Setfield
using CSV
using DataFrames
using Tables


function randomchoice(a::Array)
    n = length(a)
    # idx = mod(rand(Uint32),n)+1
    idx =  floor(Int, rand(Uniform(0,n)+1))
    return a[idx]
end

##############################
    ###   PARAMETERS   ###
##############################

#define population and contact parameters
#idle if existing population or contacts are used
POP_SIZE = 10000
HH_SIZE = 5
HH_NUMBER = POP_SIZE/HH_SIZE
MAX_CONTACTS_HH = 5
MAX_CONTACTS_OTHER = 10

#define infection parameters
PROBA_TRANS_HH = 0.3
PROBA_TRANS_OTHER = 0.1
DURATION_INFECTION = 5
BEGIN_ISOLATION = 3


INIT_INF_SHARE = 0.01 # 0.01==100 agentsü
VACC_SHARE = 0.1


SEEDS = 10
ENDITER = 5

DATA_LOCATION = "input_data/"


population_builder = "matsimPopulationBuilder.jl"
contact_builder = "randomContactBuilder.jl"
initial_infections = "randomInitInfections.jl"
infection_model = "inexHouseholdInfectionModel.jl"
initial_vaccinations ="randomInitVaccinations.jl"

update_contacts = false # whether contacts are updatd daily or remain same



include("./runner.jl") # handles one realisation

println(string("HOORAY! FINISHED ALL TASKS!"))
 of X agents each. age and sex
# are assigned s.t. older man and older woman live together with 3 younger
# agents of random sex.


agent_dict = Dict()
household_dict = Dict()

for i in 1:HH_NUMBER

    local hh_agent_list = []
    household_number = floor(Int,i)
    for j in 1:HH_SIZE

        # get some in-hosuehold stuff right (children, mother, father, etc. Not required atm but may be useful later on)
        # todo: write code that constructs nice households
        global agent_number = floor(Int,j+(i-1)*HH_SIZE)

        if j < HH_SIZE-1
            agent_age = floor(Int, rand(Uniform(0,20)))
            agent_sex = randomchoice(SEX)
        end
        if j == HH_SIZE -1
            agent_age = floor(Int, rand(Uniform(20,100)))
            agent_sex = SEX[1]
        end
        if j == HH_SIZE
            agent_age = floor(Int, rand(Uniform(20,100)))
            agent_sex = SEX[2]
        end

        #this line actually creates the agents one by one
        #@eval $(Symbol("agent_$agent_number")) = $agent($agent_number, $i, $agent_age, $agent_sex, "susceptible", false, -1, -1, [], [], false)
        agent_dict[ ("agent_$agent_number") ] = agent(agent_number, i, agent_age, agent_sex, "susceptible", false, -1, -1, [], [], false)

        push!(hh_agent_list, "agent_$agent_number")
    end
    household_dict[ ("household_$household_number") ] = household(household_number, hh_agent_list)
    hh_agent_list = nothing
end
