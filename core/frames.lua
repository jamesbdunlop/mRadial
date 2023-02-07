function createMainFrame()
    -- Main Frame
    MWarlockMainFrame = CreateFrame("Frame", "MWarlockBGFrame", UIParent, "BackdropTemplate")
    MWarlockMainFrame:SetPoint("CENTER", UIParent, "CENTER")

    MWarlockMainFrame.tex = MWarlockMainFrame:CreateTexture(nil, "ARTWORK")
    MWarlockMainFrame.tex:SetAllPoints(MWarlockMainFrame)
    MWarlockMainFrame.tex:SetTexture("Interface/Tooltips/UI-Tooltip-Background")
    MWarlockMainFrame.tex:SetColorTexture(0, 0, 0, 0.05) -- black, 50% opacity

    MWarlockMainFrame.mask = MWarlockMainFrame:CreateMaskTexture("testMask")
    MWarlockMainFrame.mask:SetAllPoints(MWarlockMainFrame.tex)
    MWarlockMainFrame.mask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    MWarlockMainFrame.tex:AddMaskTexture(MWarlockMainFrame.mask)
    
    MWarlockMainFrame:RegisterForDrag("LeftButton")
end

function createShardCountFrame()
    -- Used for counting warlock shards on the UI
    shardCount = MWarlockMainFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    shardCount:SetSize(140, 80)
    shardCount:SetPoint("CENTER", MWarlockMainFrame, "CENTER", 0, -40)
    shardCount:SetFont("Fonts\\FRIZQT__.TTF", 35, "OUTLINE, MONOCHROME")
    shardCount:SetTextColor(.5, 0, 1)

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

function createHandofGuldanFrame()
    -- CAST HAND OF G TEXT
    handOfGText = MWarlockMainFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    handOfGText:SetSize(1000, 50)
    handOfGText:SetPoint("CENTER", MWarlockMainFrame, "CENTER", 0, udOffset+20)
    handOfGText:SetFont("Fonts\\FRIZQT__.TTF", 35, "OUTLINE, MONOCHROME")
    local soulShards = UnitPower("player", 7)
    handOfGText:SetTextColor(.1, 1, .1)
    handOfGText:Hide()
end

function createFelguardFrames()
    petSpellData = {
        ["DemonicStrength"] = {["spellName"] = "Demonic Strength", 
                               ["spellIcon"] = string.format("%s/Ability_warrior_bladestorm.blp", rootIconPath)}, 
        ["FelStorm"] = {["spellName"] = "FelStorm", 
                        ["spellIcon"] = string.format("%s/Ability_warlock_demonicempowerment.blp", rootIconPath)}, 
        ["SoulStrike"] = {["spellName"] = "Soul Strike", 
                          ["spellIcon"] = string.format("%s/Inv_polearm_2h_fellord_04.blp", rootIconPath)}, 
        ["AxeToss"] = {["spellName"] = "Axe Toss", 
                          ["spellIcon"] = string.format("%s/Ability_warrior_titansgrip.blp", rootIconPath)}
    }

    for frameName, spellData in pairs(petSpellData) do
        local spellName = spellData["spellName"]
        local spellIcon = spellData["spellIcon"]

        local petSpellFrame = CreateFrame("Frame", frameName, MWarlockMainFrame)
        petSpellFrame:SetSize(50, 50)
        petSpellFrame:Show()
        petSpellFrame:SetPoint("CENTER", MWarlockMainFrame, "CENTER", 0, -140)
    
        local petSpellIconFrame = petSpellFrame:CreateTexture()
        petSpellIconFrame:SetTexture(spellIcon)
        petSpellIconFrame:SetPoint("CENTER", 0, 0)
    
        local petSpellFrameText = petSpellFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        petSpellFrameText:SetSize(150, 150)
        petSpellFrameText:SetTextColor(.1, 1, .1)
        petSpellFrameText:SetText("")
        petSpellFrameText:SetPoint("CENTER", petSpellFrame, "CENTER", 0, 0)
        petSpellFrameText:SetFont("Fonts\\FRIZQT__.TTF", 35, "OUTLINE, MONOCHROME")
    
        petSpellFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        petSpellFrame:SetScript("OnEvent", function(self, event, ...)
            local isActive = false
            for idx = 1, 30 do
                local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
                spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff("pet", idx)
                if name == spellName then
                    -- Buff is active               
                    local minutes, seconds = GetAuraTimeLeft(expirationTime)
                    if minutes >0 then
                        petSpellFrameText:SetText(string.format("%dm%d", minutes, seconds))
                    else
                        petSpellFrameText:SetText(string.format("%ds", seconds))
                    end
                    petSpellFrameText:SetTextColor(.1, 1, .1)
                    local isActive = true
                end
            end
            
            if not isActive then
                petSpellFrameText:SetText("")
                local start, duration, enable = GetSpellCooldown(spellName)
                if enable then
                    local remaining = start + duration - GetTime()
                    local minutes = math.floor(remaining / 60)
                    local seconds = math.floor(remaining - minutes * 60)
    
                    if remaining < 0 then
                        petSpellIconFrame   :SetAlpha(1)
                        petSpellFrameText:SetText("")
                        petSpellFrameText:SetTextColor(.1, 1, .1)
                    else
                        if minutes >0 then
                            petSpellFrameText:SetText(string.format("%dm%d", minutes, seconds))
                        else
                            petSpellFrameText:SetText(string.format("%ds", seconds))
                        end
                        petSpellFrameText:SetTextColor(1, .1, .1)
                        petSpellIconFrame:SetAlpha(0.5)
                    end
                end
            end
        end)
        
        petSpellFrame:EnableMouse(true)
        petSpellFrame:SetMovable(true)
        
        petSpellFrame:SetScript("OnMouseDown", function(self, button)
            if IsShiftKeyDown() and button == "LeftButton" then
                self:StartMoving()
            end
        end)
        
        petSpellFrame:SetScript("OnMouseUp", function(self, button)
            self:StopMovingOrSizing()
        end) 
    end
end
