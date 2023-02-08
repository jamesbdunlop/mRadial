mediaPath = "Interface\\AddOns\\mWarlock\\media"

function createShardCountFrame()
    -- Used for counting warlock shards on the UI
    frameName = "mw_shardFrame"
    shardCounterFrame = CreateFrame("Frame", frameName, MWarlockMainFrame, "BackdropTemplate")

    -- shardCounterFrame:SetPoint("CENTER", MWarlockMainFrame, "CENTER", -80, 80)
    shardCounterFrame:SetSize(128, 128)
    shardCounterFrame.shardsTex = shardCounterFrame:CreateTexture(nil, "BACKGROUND")
    shardCounterFrame.shardsTex:SetAllPoints(shardCounterFrame)
    shardCounterFrame:SetAlpha(.8)

    MWarlockMainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    MWarlockMainFrame:SetScript("OnEvent", function(self, event, ...)
        local soulShards = UnitPower("player", 7)
        shardCounterFrame.shardsTex:SetTexture(string.format("%s\\shards_%d.blp", mediaPath, soulShards))
        sscount = string.format("%d", soulShards)
        if soulShards == 0 and not mainFrameIsMoving then
            MWarlockMainFrame.tex:SetColorTexture(1, 0, 0, 0.07) -- red, 10% opacity
        elseif not mainFrameIsMoving then
            MWarlockMainFrame.tex:SetColorTexture(0, 0, 0, 0)
        end

        if soulShards == 2 then
            handOfGText:SetText("!Dread Only!")
        elseif soulShards > 2 then
            handOfGText:SetText("!Hand or Dread!")
        end

        -- TODO move this to the HOG frame!
        local isInCombat = UnitAffectingCombat("player")
        if soulShards <= 1 then
            handOfGText:Hide()

        elseif (soulShards == 5) then
            if isInCombat then
                handOfGText:Show()
            end
        else
            if isInCombat then
                handOfGText:Show()
            end
        end 
    end)

    shardCounterFrame:EnableMouse(true)
    shardCounterFrame:SetMovable(true)
    
    shardCounterFrame:SetScript("OnMouseDown", function(self, button)
        if IsShiftKeyDown() and button == "LeftButton" then
            self:StartMoving()
        end
    end)
    
    shardCounterFrame:SetScript("OnMouseUp", function(self, button)
        self:StopMovingOrSizing()
        local point, relativeTo, relativePoint, offsetX, offsetY = shardCounterFrame:GetPoint()
        if MWarlockSavedVariables.framePositions == nil then
            MWarlockSavedVariables.framePositions = {}
        end
        MWarlockSavedVariables.framePositions[frameName] = {}
        print(offsetX,offsetY)
        MWarlockSavedVariables.framePositions[frameName]["x"] = offsetX
        MWarlockSavedVariables.framePositions[frameName]["y"] = offsetY
    end)

    framePositions = MWarlockSavedVariables.framePositions
    if framePositions ~= nil then
        print("NOT NIL")
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
