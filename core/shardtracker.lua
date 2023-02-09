mediaPath = "Interface\\AddOns\\mWarlock\\media"

function createShardCountFrame()
    -- Used for counting warlock shards on the UI
    shardCounterFrame = CreateFrame("Frame", mw_shardFrameName, MWarlockMainFrame, "BackdropTemplate")
    shardCounterFrame:SetSize(128, 128)
    shardCounterFrame.shardsTex = shardCounterFrame:CreateTexture(nil, "BACKGROUND")
    shardCounterFrame.shardsTex:SetAllPoints(shardCounterFrame)
    shardCounterFrame:SetAlpha(.8)
    shardCounterFrame:SetMovable(true)

    framePositions = MWarlockSavedVariables.framePositions
    if framePositions ~= nil then
        found = false
        for sframeName, framePos in pairs(MWarlockSavedVariables.framePositions) do
            if sframeName == frameName then
                x = framePos["x"]
                y = framePos["y"]
                shardCounterFrame:SetPoint("CENTER", MWarlockMainFrame, "CENTER", x, y)
                found = true
            end
        end
        if not found then
            shardCounterFrame:SetPoint("CENTER", MWarlockMainFrame, "CENTER", -80, 80)
        end
    else
        shardCounterFrame:SetPoint("CENTER", MWarlockMainFrame, "CENTER", -80, 80)
    end
end
