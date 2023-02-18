function mWarlock:COMBAT_LOG_EVENT_UNFILTERED(eventName, ...)
    mWarlock:shardtrack()
end

mWarlock:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")



function mWarlock:PLAYER_SPECIALIZATION_CHANGED(eventName, ...)
    print("Player changed spec!")
end
mWarlock:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    