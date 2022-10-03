println(" ")
println(" ")
println("=.=.=.=.=.=.=.=.=.=.=.=.=.=.=.=")
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


INIT_INF_SHARE = 0.01 # 0.01==100 agents
VACC_SHARE = 0.1


SEEDS = 10
ENDITER = 5

DATA_LOCATION = "/home/mk/Desktop/julia_abm_input_data/"


population_builder = "matsimPopulation.jl"
contact_builder = "randomContacts.jl"
initial_infections = "randomInitInfections.jl"
initial_vaccinations ="randomInitVaccinations.jl"
infection_model = "randomAndHouseholdInfectionModel.jl"

update_contacts = false # whether contacts are updatd daily or remain same

include("./runner.jl") # handles one realisation

println(string("HOORAY! FINISHED ALL TASKS!"))
