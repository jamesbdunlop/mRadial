function mWarlock:createShardCountFrame()
    -- Used for counting warlock shards on the UI
    shardCounterFrame = CreateFrame("Frame", mw_shardFrameName, UIParent, "BackdropTemplate")
    shardCounterFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    shardCounterFrame:SetSize(128, 128)
    shardCounterFrame:SetAlpha(.8)
    shardCounterFrame:RegisterForDrag("LeftButton")  
    shardCounterFrame.tex = shardCounterFrame:CreateTexture(nil, "ARTWORK")
    shardCounterFrame.tex:SetAllPoints(shardCounterFrame)
    
    local soulShards = mWarlock:getShardCount()
    iconPath = string.format("%s\\shards_%d.blp", mediaPath, soulShards)
    shardCounterFrame.tex:SetTexture(iconPath)
    mWarlock:MoveFrame(shardCounterFrame, UIParent, false)

    framePosData = MWarlockSavedVariables.framePositions[mw_shardFrameName]
    if framePosData ~= nil then
        x = framePosData["x"] or 80
        y = framePosData["y"] or 80
        point = framePosData["point"] or "CENTER"
        relativeTo = framePosData["relativeTo"] or UIParent
        relativePoint = framePosData["relativePoint"] or "CENTER"
        shardCounterFrame:SetPoint(point, relativeTo, relativePoint, x, y)
    end
end

function mWarlock:setShardTrackerFramesSize()
    local frameSize = MWarlockSavedVariables["shardTrackerFrameSize"]
    shardCounterFrame:SetSize(frameSize, frameSize)
end