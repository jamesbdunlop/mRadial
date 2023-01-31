function createMainFrame()
    -- -- Main Frame
    MWarlockMainFrame = CreateFrame("Frame", "MWarlockBGFrame", UIParent, "BackdropTemplate")
    MWarlockMainFrame:SetWidth(170)
    MWarlockMainFrame:SetPoint("CENTER")
    MWarlockMainFrame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
        })
    MWarlockMainFrame:SetBackdropColor(0, 0, 0, .5)
    MWarlockMainFrame:SetBackdropBorderColor(1, 1, 1, 1)

    -- Main Frame artwork
    local MWarlockMainFrameImp = MWarlockMainFrame:CreateTexture("impGraphic")
    MWarlockMainFrameImp:SetTexture("Interface\\AddOns\\mWarlock\\media\\imp")
    MWarlockMainFrameImp:SetWidth(75)
    MWarlockMainFrameImp:SetHeight(75)
    MWarlockMainFrameImp:SetPoint("BOTTOMLEFT", -50, 0)
    
    MWarlockMainFrame:EnableMouse(true)
    MWarlockMainFrame:SetMovable(true)
    MWarlockMainFrame:RegisterForDrag("LeftButton")
    MWarlockMainFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    MWarlockMainFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
end

function createShardCountFrame()
    -- Used for counting warlock shards on the UI
    shardCount = MWarlockMainFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    shardCount:SetSize(150, 100)
    shardCount:SetPoint("TOPLEFT", MWarlockMainFrame, "TOPLEFT", 10, 70)
    shardCount:SetFont("Fonts\\FRIZQT__.TTF", 55, "OUTLINE, MONOCHROME")
    shardCount:SetTextColor(.5, 0, 1)

    MWarlockMainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    MWarlockMainFrame:SetScript("OnEvent", function(self, event, ...)
        local soulShards = UnitPower("player", 7)
        sscount = string.format("%d", soulShards)
        if soulShards <= 3 then
            shardCount:SetText(sscount)
            handOfGText:Hide()

        elseif (soulShards >``= 4) then
            handOfGText:Show()
            shardCount:SetText("FULL!")
        else
            shardCount:SetText(sscount)
        end 
    end)
end

function createHandofGuldanFrame()
    -- CAST HAND OF G TEXT
    handOfGText = MWarlockMainFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    handOfGText:SetSize(1000, 50)
    handOfGText:SetPoint("CENTER", UIParent, "CENTER", 0, -60)
    handOfGText:SetFont("Fonts\\FRIZQT__.TTF", 35, "OUTLINE, MONOCHROME")
    handOfGText:SetText("!!HAND OF G!!")
    handOfGText:SetTextColor(.1, 1, .1)
    handOfGText:Hide()
end

function createFelstormFrame()
    -- FELSTORM FRAME
    FelStormFrame = CreateFrame("Frame", "FelStorm", MWarlockMainFrame)
    FelStormFrame:SetSize(50, 50)
    FelStormFrame:Show()
    FelStormFrame:SetPoint("BOTTOMLEFT", MWarlockMainFrame, "BOTTOMLEFT", 10, 80)

    FelstormIconFrame = FelStormFrame:CreateTexture()
    FelstormIconFrame:SetTexture(string.format("%s/Ability_warrior_bladestorm.blp", rootIconPath))
    FelstormIconFrame:SetPoint("CENTER", 0, 0)

    FelstormFrameText = FelStormFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    FelstormFrameText:SetSize(150, 150)
    FelstormFrameText:SetTextColor(.1, 1, .1)
    FelstormFrameText:SetText("")
    FelstormFrameText:SetPoint("CENTER", FelStormFrame, "CENTER", 0, 0)
    FelstormFrameText:SetFont("Fonts\\FRIZQT__.TTF", 35, "OUTLINE, MONOCHROME")

    FelStormFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    FelStormFrame:SetScript("OnEvent", function(self, event, ...)
        felstormActive = false
        for idx = 1, 30 do
            local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
            spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff("pet", idx)
            if name == "Felstorm" then
                -- Buff is active               
                local minutes, seconds = GetAuraTimeLeft(expirationTime)
                if minutes >0 then
                    FelstormFrameText:SetText(string.format("%dm%d", minutes, seconds))
                else
                    FelstormFrameText:SetText(string.format("%ds", seconds))
                end
                FelstormFrameText:SetTextColor(.1, 1, .1)
                felstormActive = true
            end
        end
        
        if not felstormActive then
            FelstormFrameText:SetText("")
            local start, duration, enable = GetSpellCooldown("Felstorm")
            if enable then
                local remaining = start + duration - GetTime()
                local minutes = math.floor(remaining / 60)
                local seconds = math.floor(remaining - minutes * 60)

                if remaining < 0 then
                    FelstormIconFrame   :SetAlpha(1)
                    FelstormFrameText:SetText("")
                    FelstormFrameText:SetTextColor(.1, 1, .1)
                else
                    if minutes >0 then
                        FelstormFrameText:SetText(string.format("%dm%d", minutes, seconds))
                    else
                        FelstormFrameText:SetText(string.format("%ds", seconds))
                    end
                    FelstormFrameText:SetTextColor(1, .1, .1)
                    FelstormIconFrame:SetAlpha(0.5)
                end
            end
        end
    end)
end