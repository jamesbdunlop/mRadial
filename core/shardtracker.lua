local mRadial = mRadial

function mRadial:createShardCountFrame()
    -- Sets up the frame used for counting warlock shards on the UI
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
    
    local alpha = MRadialSavedVariables["shardFrameTransparency"] or 1
    local hide =  MRadialSavedVariables["hideShardFrame"] or false
    ShardCounterFrame:SetAlpha(alpha)
    ShardCounterFrame:GetParent():SetAlpha(1)
    if hide then
        ShardCounterFrame:SetAlpha(0)
        ShardCounterFrame:GetParent():SetAlpha(0)
        return
    end
    mRadial:setShardTrackerFramesSize()
    mRadial:SetMountedFrameScripts(ShardCounterFrame, alpha)
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
    local hide =  MRadialSavedVariables["hideShardFrame"] or false
    if hide then
        return
    end

    local soulShards = mRadial:GetShardCount()
    -- Change the texture of the frame
    local iconPath = string.format("%s\\shards_%d.blp", MEDIAPATH, soulShards)
    ShardCounterFrame.iconFrame:SetTexture(iconPath)

    -- Change the main frame bg if we're out of shards and not in moving mode..
    local hideOOfShardFrame = MRadialSavedVariables["hideOOShardFrame"] or false
    if soulShards == 0 and not MAINFRAME_ISMOVING and not hideOOfShardFrame then
        MRadialMainFrame.iconFrame:SetColorTexture(1, 0, 0, .2) -- red, 10% opacity
    elseif soulShards > 0 and not MAINFRAME_ISMOVING or hideOOfShardFrame then
        MRadialMainFrame.iconFrame:SetColorTexture(1, 0, 0, 0) -- transparent
    end
end