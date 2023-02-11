mediaPath = "Interface\\AddOns\\mWarlock\\media"

function createShardCountFrame()
    -- Used for counting warlock shards on the UI
    shardCounterFrame = CreateFrame("Frame", mw_shardFrameName, MWarlockMainFrame, "BackdropTemplate")
    shardCounterFrame:SetSize(128, 128)
    shardCounterFrame.shardsTex = shardCounterFrame:CreateTexture(nil, "BACKGROUND")
    shardCounterFrame.shardsTex:SetAllPoints(shardCounterFrame)
    shardCounterFrame:SetAlpha(.8)
    shardCounterFrame:SetMovable(true)

    framePos = MWarlockSavedVariables.framePositions[mw_shardFrameName]
    if framePos == nil then
        shardCounterFrame:SetPoint("CENTER", MWarlockMainFrame, "CENTER", -80, 80)
    else
        x = framePos["x"]
        y = framePos["y"]
        shardCounterFrame:SetPoint("CENTER", MWarlockMainFrame, "CENTER", x, y)
    end
end
