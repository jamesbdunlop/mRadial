PetDiedMsg ={}
PetDiedMsg[1] = "Please lament the loss of yet another demon who was working hard to help kill stuff...."
PetDiedMsg[2] = "Whoops, Pet down! Do you not like my pets helping out?!"
PetDiedMsg[3] = "Demon down! Demon down! Macka is now freaking out.."
PetDiedMsg[4] = "Several warlock pets died in the making of this dungeon run..."

function mRadial:COMBAT_LOG_EVENT_UNFILTERED(eventName, ...)
end

mRadial:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")