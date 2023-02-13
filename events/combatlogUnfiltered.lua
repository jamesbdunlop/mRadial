function mWarlock:COMBAT_LOG_EVENT_UNFILTERED(eventName, ...)
    mWarlock:shardtrack()
    
    soulShards = mWarlock:getShardCount()
    if soulShards == 2 then
        handOfGText:SetText("!Dread Only!")
    elseif soulShards > 2 then
        handOfGText:SetText("!Hand or Dread!")
    end

    -- HAND OF GULDAN FRAME
    local isInCombat = UnitAffectingCombat("player")
    if soulShards <= 1 then
        handOfGText:Hide()

    elseif (soulShards == 5) then
        if isInCombat then
            handOfGText:Show()
        end
    else
        if isInCombat then
            handOfGText:Show()
        end
    end 
end

mWarlock:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
