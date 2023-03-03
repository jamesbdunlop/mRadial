function mWarlock:COMBAT_LOG_EVENT_UNFILTERED(eventName, ...)
    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
    local iuzenName = "Iuzenashamme"
    if subevent == "UNIT_DIED" or subevent == "UNIT_DESTROYED" or subevent == "UNIT_DISSIPATES" then
        if destName == iuzenName then
            SendChatMessage(destFlags .. "DIED AGAIN!", "PARTY")
        end

        local petGUID = UnitGUID("pet")
        if destGUID == petGUID then
            mWarlock:RemoveAllPetFrames()
            
            -- Loop through all party members and check if the player is in the party
            if UnitInParty(iuzenName) then
                    local message = "My pet died again " .. iuzenName .. "! WTF BRO!"
                    SendChatMessage(message, "PARTY")
            end
        end
    end
end

mWarlock:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")