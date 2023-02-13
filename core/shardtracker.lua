function mWarlock:createShardCountFrame()
    -- Used for counting warlock shards on the UI
    shardCounterFrame = CreateFrame("Frame", mw_shardFrameName, UIParent, "BackdropTemplate")
    shardCounterFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    shardCounterFrame:SetSize(128, 128)
    shardCounterFrame:SetAlpha(.8)
    shardCounterFrame:RegisterForDrag("LeftButton")  
    shardCounterFrame.tex = shardCounterFrame:CreateTexture(nil, "ARTWORK")
    shardCounterFrame.tex:SetAllPoints(shardCounterFrame)
    
    shardCounterFrame.movetex = shardCounterFrame:CreateTexture("OVERLAY")
    shardCounterFrame.movetex:SetPoint("CENTER", 0, 0)
    shardCounterFrame.movetex:SetAllPoints(shardCounterFrame)

    mWarlock:MoveFrame(shardCounterFrame, UIParent, false)
    mWarlock:restoreFrame(mw_shardFrameName, shardCounterFrame)
end

function mWarlock:setShardTrackerFramesSize()
    local frameSize = MWarlockSavedVariables["shardTrackerFrameSize"]
    shardCounterFrame:SetSize(frameSize, frameSize)
end