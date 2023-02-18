function mWarlock:COMBAT_LOG_EVENT_UNFILTERED(eventName, ...)
    mWarlock:shardtrack()
end

mWarlock:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")





    
    -- soulShards = mWarlock:getShardCount()
    -- if soulShards == 2 then
    --     HandOfGText:SetText("!Dread Only!")
    -- elseif soulShards > 2 then
    --     HandOfGText:SetText("!Hand or Dread!")
    -- end

    -- -- HAND OF GULDAN FRAME
    -- local isInCombat = UnitAffectingCombat("player")
    -- if soulShards <= 1 then
    --     HandOfGText:Hide()

    -- elseif (soulShards == 5) then
    --     if isInCombat then
    --         HandOfGText:Show()
    --     end
    -- else
    --     if isInCombat then
    --         HandOfGText:Show()
    --     end
    -- end 