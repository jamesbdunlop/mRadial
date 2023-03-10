local mRadial = mRadial

function mRadial:createShardCountFrame()
    -- Sets up the frame used for counting warlock shards on the UI
    -- Actual shard frame changes happen in the events.COMBAT_LOG_EVENT_UNFILTERED
    local size = 200
    local exists, frame = mRadial:GetFrameByName(SHARD_FRAMENAME)
    if not exists then 
        ShardCounterFrame = mRadial:CreateMovableFrame(SHARD_FRAMENAME,
                                            {size, size},
                                            UIParent,
                                            "",
                                            "",
                                            "BACKGROUND",
                                            nil,
                                            true, 
                                            {size, size}, {size, size})
    else
        ShardCounterFrame = frame    
    end
    
    ShardCounterFrame:SetAlpha(.5)
    mRadial:setShardTrackerFramesSize()
    mRadial:SetMountedFrameScripts(ShardCounterFrame)
end

function mRadial:setShardTrackerFramesSize()
    -- For options to use to change the size of the frame.
    local frameSize = MRadialSavedVariables["shardTrackerFrameSize"] or 200
    if ShardCounterFrame ~= nil then
        ShardCounterFrame:SetSize(frameSize, frameSize)
    end
end

function mRadial:setOOSShardFramesSize()
    -- For options to use to change the size of the frame.
    local frameSize = MRadialSavedVariables["shardOutOfFrameSize"] or 200
    MRadialMainFrame:SetSize(frameSize, frameSize)
    MRadialMainFrame.iconFrame:SetSize(frameSize, frameSize)
    MRadialMainFrame.mask:SetSize(frameSize, frameSize)
end

function mRadial:shardtrack()
    if not mRadial:IsWarlock() then
        return
    end

    local soulShards = mRadial:getShardCount()
    -- Change the texture of the frame
    local iconPath = string.format("%s\\shards_%d.blp", MEDIAPATH, soulShards)
    ShardCounterFrame.iconFrame:SetTexture(iconPath)

    -- Change the main frame bg if we're out of shards and not in moving mode..
    if soulShards == 0 and not MAINFRAME_ISMOVING then
        MRadialMainFrame.iconFrame:SetColorTexture(1, 0, 0, .2) -- red, 10% opacity
    elseif not MAINFRAME_ISMOVING then
        MRadialMainFrame.iconFrame:SetColorTexture(1, 0, 0, 0) -- transparent
    end
end