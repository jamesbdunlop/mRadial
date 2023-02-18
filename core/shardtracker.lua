function mWarlock:createShardCountFrame()
    -- Sets up the frame used for counting warlock shards on the UI
    -- Actual shard frame changes happen in the events.COMBAT_LOG_EVENT_UNFILTERED
    local size = 100
    shardCounterFrame = mWarlock:CreateMovableFrame(SHARD_FRAMENAME,
                                        {100, 100},
                                        UIParent,
                                        "",
                                        "",
                                        "ARTWORK",
                                        nil,
                                        true, 
                                        {size, size}, {size, size})

    shardCounterFrame:SetAlpha(.8)
    mWarlock:setShardTrackerFramesSize()
end

function mWarlock:setShardTrackerFramesSize()
    -- For options to use to change the size of the frame.
    local frameSize = MWarlockSavedVariables["shardTrackerFrameSize"]
    shardCounterFrame:SetSize(frameSize, frameSize)
end