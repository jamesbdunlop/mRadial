function mWarlock:UNIT_POWER_UPDATE(eventName, arg1, arg2)
    -- print("eventName: %s", eventName)
    -- print("arg1: %s", arg1)
    -- print("arg2: %s", arg2)
    if arg1 == "player" and arg2 == "SOUL_SHARDS" then
        mWarlock:shardtrack()
    end
end

mWarlock:RegisterEvent("UNIT_POWER_UPDATE")
