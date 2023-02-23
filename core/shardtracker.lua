function mWarlock:createShardCountFrame()
    -- Sets up the frame used for counting warlock shards on the UI
    -- Actual shard frame changes happen in the events.COMBAT_LOG_EVENT_UNFILTERED
    local size = 500
    shardCounterFrame = mWarlock:CreateMovableFrame(SHARD_FRAMENAME,
                                        {100, 100},
                                        UIParent,
                                        "",
                                        "",
                                        "BACKGROUND",
                                        nil,
                                        true, 
                                        {size, size}, {size, size})

    shardCounterFrame:SetAlpha(.5)
    mWarlock:setShardTrackerFramesSize()
end

function mWarlock:setShardTrackerFramesSize()
    -- For options to use to change the size of the frame.
    local frameSize = MWarlockSavedVariables["shardTrackerFrameSize"] or 450
    if shardCounterFrame ~= nil then
        shardCounterFrame:SetSize(frameSize, frameSize)
    end
end

function mWarlock:setOOSShardFramesSize()
    -- For options to use to change the size of the frame.
    local frameSize = MWarlockSavedVariables["shardOutOfFrameSize"] or 450
    MWarlockMainFrame:SetSize(frameSize, frameSize)
    MWarlockMainFrame.texture:SetSize(frameSize, frameSize)
    MWarlockMainFrame.mask:SetSize(frameSize, frameSize)
end

function mWarlock:shardtrack()
    if not mWarlock:IsWarlock() then
        return
    end
    
    local soulShards = mWarlock:getShardCount()
    
    -- Change the texture of the frame
    local iconPath = string.format("%s\\shards_%d.blp", MEDIAPATH, soulShards)
    shardCounterFrame.texture:SetTexture(iconPath)

    -- Change the main frame bg if we're out of shards and not in moving mode..
    if soulShards == 0 and not MAINFRAME_ISMOVING then
        MWarlockMainFrame.texture:SetColorTexture(1, 0, 0, .2) -- red, 10% opacity
    elseif not MAINFRAME_ISMOVING then
        MWarlockMainFrame.texture:SetColorTexture(1, 0, 0, 0) -- transparent
    end
end