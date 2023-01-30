local function isCorrectClass()
    local playerClass = UnitClass("player")
    -- Check if the player's class is "Warlock"
    if playerClass == "Warlock" then
        print("~~~~~~~~~~~~~~~~~")
        print("Welcome to MWarlock!")
        print("~~~~~~~~~~~~~~~~~")
        return true
    end
    return false
end

local function isCorrectSpec()
    -- Check if player has selected demonology as their spec
    local spec = GetSpecialization()
    if spec ~= 2 then
        return false
    end
    return true
end

-- Gather only the spells we're interested in! It's bit hard codey but I don't care atm...
dt_specialisationData = {}
dt_specialisationData["implosion"] = false
dt_specialisationData["grimFelguard"] = false
dt_specialisationData["powerSiphon"] = false
dt_specialisationData["demonicTyrant"] = false
dt_specialisationData["handofGuldan"] = false
dt_specialisationData["inquisitorsGaze"] = false
dt_specialisationData["summonSoulkeeper"] = false
dt_specialisationData["felstorm"] = false

rootIconPath ="Interface/ICONS"

local function checkDemonologyTalentTree()   
    powerSiphonSpellName = "Power Siphon" --264130
    demonicCoreSpellName = "Demonic Core"
    local spellName = GetSpellInfo(powerSiphonSpellName)
    if spellName then
        dt_specialisationData[powerSiphonSpellName] = true
    end

    inquisitorsGazeSpellName = "Inquistor's Gaze" --386334
    local spellName = GetSpellInfo(inquisitorsGazeSpellName)
    if spellName then
        dt_specialisationData[inquisitorsGazeSpellName] = true
    end

    summonSoulKeeperSpellName = "Summon Soulkeeper"
    local spellName = GetSpellInfo(summonSoulKeeperSpellName)
    if spellName then
        dt_specialisationData[summonSoulKeeperSpellName] = true
    end

    summonDTSpellName = "Summon Demonic Tyrant" --265187
    demonicPowerSpellName = "Demonic Power"
    local spellName = GetSpellInfo(summonDTSpellName)
    if spellName then
        dt_specialisationData[summonDTSpellName] = true
    end  

    callDreadStealersSpellName = "Call Dreadstalkers" --104316
    local spellName = GetSpellInfo(callDreadStealersSpellName)
    if spellName then
        dt_specialisationData[callDreadStealersSpellName] = true
    end

    netherPortalSpellName = "Nether Portal" --26721
    local spellName = GetSpellInfo(netherPortalSpellName)
    if spellName then
        dt_specialisationData[netherPortalSpellName] = true
    end

    grimFelGuardSpellName = "Grimoire: Felguard" --111898
    local spellName = GetSpellInfo(grimFelGuardSpellName)
    if spellName then
        dt_specialisationData[grimFelGuardSpellName] = true
    end
    
end

if(isCorrectClass())then
    -- -- Main Frame
    BuffBGFrame = CreateFrame("Frame", "MWarlockBGFrame", UIParent, "BackdropTemplate")
    BuffBGFrame:SetWidth(170)
    BuffBGFrame:SetHeight(200)
    BuffBGFrame:SetPoint("CENTER")
    BuffBGFrame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
      })
    BuffBGFrame:SetBackdropColor(0, 0, 0, .5)
    BuffBGFrame:SetBackdropBorderColor(1, 1, 1, 1)

    -- Main Frame artwork
    local BuffBGFrameImp = BuffBGFrame:CreateTexture("impGraphic")
    BuffBGFrameImp:SetTexture("Interface\\AddOns\\mWarlock\\media\\imp")
    BuffBGFrameImp:SetWidth(75)
    BuffBGFrameImp:SetHeight(75)
    BuffBGFrameImp:SetPoint("BOTTOMLEFT", -10, 0)
    
    BuffBGFrame:EnableMouse(true)
    BuffBGFrame:SetMovable(true)
    BuffBGFrame:RegisterForDrag("LeftButton")
    BuffBGFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    BuffBGFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    
    ---------------------------------------------------
    -- SHARD COUNT
    shardCount = BuffBGFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    shardCount:SetSize(150, 100)
    shardCount:SetPoint("TOPLEFT", BuffBGFrame, "TOPLEFT", -40, 10)
    shardCount:SetFont("Fonts\\FRIZQT__.TTF", 55, "OUTLINE, MONOCHROME")
    shardCount:SetTextColor(.5, 0, 1)

    BuffBGFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    BuffBGFrame:SetScript("OnEvent", function(self, event, ...)
        local soulShards = UnitPower("player", 7)
        sscount = string.format("%d", soulShards)
        if soulShards <= 3 then
            shardCount:SetText(sscount)
            handOfGText:Hide()

        elseif (soulShards == 5) then
            handOfGText:Show()
            shardCount:SetText("FULL!")
        else
            shardCount:SetText(sscount)
        end 
    end)
    ---------------------------------------------------
    -- CAST HAND OF G TEXT
    handOfGText = BuffBGFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    handOfGText:SetSize(1000, 50)
    handOfGText:SetPoint("CENTER", UIParent, "CENTER", 0, -60)
    handOfGText:SetFont("Fonts\\FRIZQT__.TTF", 35, "OUTLINE, MONOCHROME")
    handOfGText:SetText("!!HAND OF G!!")
    handOfGText:SetTextColor(.1, 1, .1)
    handOfGText:Hide()
    
    ---------------------------------------------------
    -- FELSTORM FRAME
    FelStormFrame = CreateFrame("Frame", "FelStorm", BuffBGFrame)
    FelStormFrame:SetSize(50, 50)
    FelStormFrame:Show()
    FelStormFrame:SetPoint("BOTTOMLEFT", BuffBGFrame, "BOTTOMLEFT", 10, 80)

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

-- Create a frame to register events
local f = CreateFrame("Frame")

-- Register the event for when the player logs in
f:RegisterEvent("PLAYER_LOGIN")

-- Set the function to be called when the event fires
    -- ud = UpDown
    -- lr = leftRight
udOffset = 8
f:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- Get the player's class
        if(isCorrectClass())then
            -- Get the player's spec
            if(isCorrectSpec)then
                -- Parse what talents are loaded
                checkDemonologyTalentTree()
                
                local lrOffset = 75
                -- Load Buffs UI
                if(dt_specialisationData[powerSiphonSpellName])then
                    udOffset = udOffset + 32
                    addBuffWatcher(demonicCoreSpellName, 
                                   lrOffset, 
                                   udOffset, 
                                   string.format("%s/Warlock_spelldrain.blp", rootIconPath),  
                                   string.format("%s/Ability_warlock_backdraft.blp", rootIconPath), 
                                   powerSiphonSpellName, 
                                   nil, false)
                end
                
                if(dt_specialisationData[inquisitorsGazeSpellName])then
                    udOffset = udOffset + 32
                    addBuffWatcher(inquisitorsGazeSpellName, 
                                  lrOffset, 
                                  udOffset, 
                                  nil, nil, nil, false)
                end

                if(dt_specialisationData[summonSoulKeeperSpellName])then
                    udOffset = udOffset + 32
                    addBuffWatcher(summonSoulKeeperSpellName, 
                                   lrOffset, 
                                   udOffset, 
                                   string.format("%s/Spell_fel_elementaldevastation.blp", rootIconPath), 
                                   nil, nil, 
                                   nil, true)
                end

                if(dt_specialisationData[callDreadStealersSpellName])then
                    udOffset = udOffset + 32
                    addBuffWatcher(callDreadStealersSpellName, 
                                   lrOffset, 
                                   udOffset, 
                                   string.format("%s/Spell_warlock_calldreadstalkers.blp", rootIconPath), 
                                   string.format("%s/Spell_warlock_calldreadstalkers.blp", rootIconPath), 
                                   callDreadStealersSpellName, 
                                   true, true)
                end

                if(dt_specialisationData[grimFelGuardSpellName])then
                    udOffset = udOffset + 32
                    addBuffWatcher(grimFelGuardSpellName, 
                                   lrOffset, 
                                   udOffset, 
                                   string.format("%s/Spell_shadow_summonfelguard.blp", rootIconPath), 
                                   string.format("%s/Spell_shadow_summonfelguard.blp", rootIconPath), 
                                   grimFelGuardSpellName, 
                                   true, true)
                end

                if(dt_specialisationData[summonDTSpellName])then
                    udOffset = udOffset + 32
                    addBuffWatcher(demonicPowerSpellName, 
                                   lrOffset, 
                                   udOffset, 
                                   string.format("%s/Achievement_boss_argus_maleeredar.blp", rootIconPath), 
                                   string.format("%s/Inv_summondemonictyrant.blp", rootIconPath), 
                                   summonDTSpellName, 
                                   nil, false)
                end
                
                if(dt_specialisationData[felstormSpellName])then
                    udOffset = udOffset + 32
                    addBuffWatcher(felstormSpellName, 
                                   lrOffset, 
                                   udOffset, 
                                   string.format("%s/Ability_warrior_bladestorm.blp", rootIconPath), 
                                   string.format("%s/Ability_warrior_bladestorm.blp", rootIconPath), 
                                   felstormSpellName, 
                                   true, true)
                end

                if(dt_specialisationData[netherPortalSpellName])then
                    udOffset = udOffset + 32
                    addBuffWatcher(netherPortalSpellName, 
                                   lrOffset, 
                                   udOffset, 
                                   string.format("%s/Inv_netherportal.blp", rootIconPath), 
                                   string.format("%s/Inv_netherportal.blp", rootIconPath), 
                                   netherPortalSpellName, 
                                   true, true)
                end

            end
            BuffBGFrame:SetHeight(udOffset+100)
        end
    end
end)     

