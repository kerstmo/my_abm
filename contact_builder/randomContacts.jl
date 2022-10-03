
##############################################
    ###   CONSTRUCT CONTACT PATTERNS   ###
##############################################

# nur die infected werden durchgeloopt. jeder agent hat jeden tag 10 zufällige
# neue kontakte.
# zusätzlich haben alle fünf haushaltsmitglieder kontakt.
# die nicht-household kontakte sind so gestaltet, dass jeder externe agent
# Kontakt wiederum maximal 10 kontakte mit infektiösen agenten haben kann. So
# muss keine kontaktmatrix für alle agenten gebildet werden.



for i in infected_agents
    global hh_contacts = []
    global other_contacts = []
    local this_household_id = agent_dict["$i"].household_id
    hh_contacts =  copy(household_dict[this_household_id].member_ids)
    deleteat!(hh_contacts, findall(x->x== i,hh_contacts)) # i has not contact with herselves
    if agent_dict["$i"].in_quar == false
        while length(other_contacts) < MAX_CONTACTS_OTHER
            new_contact = string("agent_", floor(Int, rand(Uniform(1,POP_SIZE))))

            if new_contact ∉ other_contacts &&
                new_contact != i &&
                agent_dict["$new_contact"].in_quar == false &&
                length(agent_dict["$new_contact"].contacts_other) < MAX_CONTACTS_OTHER

                push!(other_contacts, new_contact)
            end

        end
    end

    agent_dict["$i"].contacts_other = other_contacts
    agent_dict["$i"].contacts_hh = hh_contacts
    other_contacts = nothing
end
