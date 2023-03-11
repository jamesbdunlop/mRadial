function mRadial:COMBAT_LOG_EVENT_UNFILTERED(eventName, ...)
    local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
    local iuzenName = "Iuzenashamme"
    local playerName = UnitName("player")
    local myName = "Macka"
    if subevent == "UNIT_DIED" or subevent == "UNIT_DESTROYED" or subevent == "UNIT_DISSIPATES" then
        if playerName ~= myName then
            return
        end
        if destName == iuzenName and UnitInParty(iuzenName) then
            SendChatMessage(iuzenName .. " is dead on the ground again!!!!", "PARTY")
        end

        local petGUID = UnitGUID("pet")
        if destGUID == petGUID then
            mRadial:InitUI()
            -- Loop through all party members and check if the player is in the party
            if UnitInParty(iuzenName) then
                    local message = "My pet died again " .. iuzenName .. "! WTF BRO!"
                    SendChatMessage(message, "PARTY")
            end
        end
    end
end

mRadial:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")