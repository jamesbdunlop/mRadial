function mWarlock:COMBAT_LOG_EVENT_UNFILTERED(eventName, ...)
    mWarlock:shardtrack()
end

mWarlock:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
