mediaPath = "Interface\\AddOns\\mWarlock\\media\\"

function createShardCountFrame()
    print("Creating shard counter....")
    -- Used for counting warlock shards on the UI
    shardCount = MWarlockMainFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    shardCount:SetSize(140, 80)
    shardCount:SetPoint("CENTER", MWarlockMainFrame, "CENTER", 0, -40)
    shardCount:SetFont("Fonts\\FRIZQT__.TTF", 35, "OUTLINE, MONOCHROME")
    shardCount:SetTextColor(.5, 0, 1)

    local shardTextureFrame = MWarlockMainFrame:CreateTexture()
    shardTextureFrame:SetTexture(string.format("%s\\shards_2.png", mediaPath))
    shardTextureFrame:SetPoint("CENTER", 0, 0)

    MWarlockMainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    MWarlockMainFrame:SetScript("OnEvent", function(self, event, ...)
        local soulShards = UnitPower("player", 7)
        sscount = string.format("%d", soulShards)
        if soulShards == 0 then
            MWarlockMainFrame.tex:SetColorTexture(1, 0, 0, 0.07) -- red, 10% opacity
        else
            MWarlockMainFrame.tex:SetColorTexture(0, 1, 0, 0) -- green, 10% opacity
        end

        if soulShards == 2 then
            handOfGText:SetText("!Dread Only!")
        elseif soulShards > 2 then
            handOfGText:SetText("!Hand or Dread!")
        end

        local isInCombat = UnitAffectingCombat("player")
        if soulShards <= 1 then
            shardCount:SetText(sscount)
            handOfGText:Hide()

        elseif (soulShards == 5) then
            if isInCombat then
                handOfGText:Show()
            end
            shardCount:SetText("*****")
        else
            if isInCombat then
                handOfGText:Show()
            end
            shardCount:SetText(sscount)
        end 
    end)
end
