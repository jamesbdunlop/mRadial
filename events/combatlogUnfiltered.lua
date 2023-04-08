PetDiedMsg ={}
PetDiedMsg[1] = "Please lament the loss of yet another demon who was working hard to help kill stuff...."
PetDiedMsg[2] = "Whoops, Pet down! Do you not like my pets helping out?!"
PetDiedMsg[3] = "Demon down! Demon down! Macka is now freaking out.."
PetDiedMsg[4] = "Several warlock pets died in the making of this dungeon run..."

function mRadial:COMBAT_LOG_EVENT_UNFILTERED(eventName, ...)
    local _, subevent, _, _, sourceName, _, _, destGUID, destName, _, _ = CombatLogGetCurrentEventInfo()
    local iuzenName = "Iuzenashamme"
    local playerName = UnitName("player")
    local myName = "Macka"
    if subevent == "UNIT_DIED" or subevent == "UNIT_DESTROYED" or subevent == "UNIT_DISSIPATES" then
        if playerName ~= myName then
            return
        end

        if destName == iuzenName and UnitInParty(iuzenName) then
            SendChatMessage("Healer down! healer down! " .. iuzenName .. " went splat to: " .. sourceName, "PARTY")
        end

        local petGUID = UnitGUID("pet")
        if destGUID == petGUID then
            mRadial:InitUI()
            -- Loop through all party members and check if the player is in the party
            if UnitInParty(iuzenName) then
                SendChatMessage(PetDiedMsg[math.random(1, #PetDiedMsg)], "WHISPER", nil, iuzenName)
            end
        end
    end
end

mRadial:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")