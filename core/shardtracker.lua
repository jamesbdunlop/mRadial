local mRadial = mRadial

function mRadial:setShardTrackerFramesSize()
    -- For options to use to change the size of the frame.
    local frameSize = MRadialSavedVariables["shardTrackerFrameSize"]
    if frameSize == nil then frameSize = MR_DEFAULT_SHARD_FS end
    if ShardCounterFrame ~= nil and not InCombatLockdown() then
        ShardCounterFrame:SetSize(frameSize, frameSize)
    end
end

function mRadial:setOOSShardFramesSize()
    -- For options to use to change the size of the frame.
    local frameSize = MRadialSavedVariables["shardOutOfFrameSize"]
    if frameSize == nil then frameSize = MR_DEFAULT_OOS_FS end
    if not InCombatLockdown() then
        MRadialMainFrame:SetSize(frameSize, frameSize)
        MRadialMainFrame.iconFrame:SetSize(frameSize, frameSize)
        MRadialMainFrame.mask:SetSize(frameSize, frameSize)
    end
end

function mRadial:shardtrack()
    if not mRadial:IsWarlock() then return end
    
    -- SHARD COUNT
    local hide = MRadialSavedVariables["hideShardFrame"] or false
    local soulShards = mRadial:GetShardCount()
    if not hide then
        -- Change the texture of the frame
        local iconPath = string.format("%s\\shards_%d.blp", MR_MEDIAPATH, soulShards)
        if ShardCounterFrame ~= nil then
            ShardCounterFrame.iconFrame:SetTexture(iconPath)
        end
    end

    -- OUT OF SHARDS
    -- Change the main frame bg if we're out of shards and not in moving mode..
    local hideOOfShardFrame = MRadialSavedVariables["hideOOShardFrame"]
    if hideOOfShardFrame == nil then hideOOfShardFrame = MR_DEFAULT_HIDE_OOSF end
    if soulShards == 0 and not MAINFRAME_ISMOVING and not hideOOfShardFrame then
        MRadialMainFrame.iconFrame:SetColorTexture(1, 0, 0, .3) -- red, 10% opacity
        local mask = MR_DEFAULT_RADIAL_MASK
        MRadialMainFrame.mask:SetTexture(mask, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    elseif soulShards > 0 and not MAINFRAME_ISMOVING then
        MRadialMainFrame.iconFrame:SetColorTexture(1, 0, 0, 0) -- transparent
        MRadialMainFrame.mask:SetTexture("", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    end
end
