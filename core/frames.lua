local playerGUID = UnitGUID("player")

function mWarlock:createMainFrame()
    -- Main Frame
    MWarlockMainFrame = CreateFrame("Frame", mainFrameName, UIParent, "BackdropTemplate")

    MWarlockMainFrame.tex = MWarlockMainFrame:CreateTexture(nil, "ARTWORK")
    MWarlockMainFrame.tex:SetAllPoints(MWarlockMainFrame)
    MWarlockMainFrame.tex:SetTexture("Interface/Tooltips/UI-Tooltip-Background")

    MWarlockMainFrame.mask = MWarlockMainFrame:CreateMaskTexture("testMask")
    MWarlockMainFrame.mask:SetAllPoints(MWarlockMainFrame.tex)
    MWarlockMainFrame.mask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    MWarlockMainFrame.tex:AddMaskTexture(MWarlockMainFrame.mask)
    
    MWarlockMainFrame:RegisterForDrag("LeftButton")  
    mWarlock:moveFrame(MWarlockMainFrame, UIParent, false)
    mWarlock:restoreFrame(mainFrameName, MWarlockMainFrame)
end

---------------------------------------------------------------------------------------------------
-------- DEMONOLOGY SPECIFIC FRAMES
function mWarlock:createHandofGuldanFrame()
    -- CAST HAND OF G TEXT
    handOfGText = MWarlockMainFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    handOfGText:SetSize(1000, 50)
    handOfGText:SetPoint("CENTER", UIParent, "CENTER", 0, udOffset+20)
    handOfGText:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE, MONOCHROME")
    local soulShards = UnitPower("player", 7)
    handOfGText:SetTextColor(.1, 1, .1)
    handOfGText:Hide()
end

felguardFrames = {}
function mWarlock:createFelguardFrames()
    petSpellData = {
        ["DemonicStrength"] = {["spellName"] = "Demonic Strength", 
                               ["spellIcon"] = string.format("%s/Ability_warlock_demonicempowerment.blp", rootIconPath)}, 
        ["FelStorm"] = {["spellName"] = "FelStorm", 
                        ["spellIcon"] = string.format("%s/Ability_warrior_bladestorm.blp", rootIconPath)}, 
        ["SoulStrike"] = {["spellName"] = "Soul Strike", 
                          ["spellIcon"] = string.format("%s/Inv_polearm_2h_fellord_04.blp", rootIconPath)}, 
        ["AxeToss"] = {["spellName"] = "Axe Toss", 
                          ["spellIcon"] = string.format("%s/Ability_warrior_titansgrip.blp", rootIconPath)}
    }

    for frameName, spellData in pairs(petSpellData) do
        local spellName = spellData["spellName"]
        local spellIcon = spellData["spellIcon"]
        if mWarlock:checkHasSpell(spellName) then
            if felguardFrames[frameName] == nil then
                local petSpellFrame = CreateFrame("Frame", frameName, UIParent)
                petSpellFrame:SetPoint("CENTER", MWarlockMainFrame, "CENTER", 0, -140)
                framePositions = MWarlockSavedVariables.framePositions
                if framePositions ~= nil then
                    for sframeName, framePos in pairs(MWarlockSavedVariables.framePositions) do
                        if sframeName == frameName then
                            x = framePos["x"] or 90
                            y = framePos["y"] or 90
                            point = framePosData["point"] or "CENTER"
                            relativeTo = framePosData["relativeTo"] or UIParent
                            relativePoint = framePosData["relativePoint"] or "CENTER"
                            petSpellFrame:SetPoint(point, relativeTo, relativePoint, x, y)
                        end
                    end
                else
                    petSpellFrame:SetPoint("CENTER", UIParent, "CENTER", 20, 200)
                end
                petSpellFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
                
                petSpellFrame.movetex = petSpellFrame:CreateTexture("OVERLAY")
                petSpellFrame.movetex:SetPoint("CENTER", 0, 0)
                petSpellFrame.movetex:SetAllPoints(petSpellFrame)

                petSpellFrame.tex = petSpellFrame:CreateTexture()
                petSpellFrame.tex:SetTexture(spellIcon)
                petSpellFrame.tex:SetPoint("CENTER", 0, 0)
                petSpellFrame.tex:SetAllPoints(petSpellFrame)
            
                local petSpellFrameText = petSpellFrame:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
                petSpellFrameText:SetTextColor(.1, 1, .1)
                petSpellFrameText:SetText("")
                petSpellFrameText:SetAllPoints(petSpellFrame.tex)
                petSpellFrameText:SetFont("Fonts\\FRIZQT__.TTF", 35, "OUTLINE, MONOCHROME")
            
                petSpellFrame:SetScript("OnEvent", function(self, event, ...)
                    if not mWarlock:IsFelguardSummoned() then
                        petSpellFrame:Hide()
                        return
                    else
                        petSpellFrame:Show()
                    end
                    local isActive = false
                    for idx = 1, 30 do
                        local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
                        spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff("pet", idx)
                        if name == spellName then
                            -- Buff is active               
                            local minutes, seconds = mWarlock:GetAuraTimeLeft(expirationTime)
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
                                petSpellFrame.tex:SetAlpha(1)
                                petSpellFrameText:SetText("")
                                petSpellFrameText:SetTextColor(.1, 1, .1)
                            else
                                if minutes >0 then
                                    petSpellFrameText:SetText(string.format("%dm%d", minutes, seconds))
                                else
                                    petSpellFrameText:SetText(string.format("%ds", seconds))
                                end
                                petSpellFrameText:SetTextColor(1, .1, .1)
                                petSpellFrame.tex:SetAlpha(0.5)
                            end
                        end
                    end
                end)
                
                ---- SCRIPTS
                mWarlock:moveFrame(petSpellFrame, UIParent, false)

                -- Add to the frame table for felguard frames
                felguardFrames[frameName] = petSpellFrame
            else
                petSpellFrame = felguardFrames[frameName]
            end
        end
    end
    mWarlock:setFelguardFramePosAndSize()
end

function mWarlock:setFelguardFramePosAndSize()
    local frameSize = MWarlockSavedVariables["felguardFrameSize"]
    for frameName, frame in pairs(felguardFrames) do
        frame:SetSize(frameSize, frameSize)
        mWarlock:restoreFrame(frameName, frame)
    end
end
---------------------------------------------------------------------------------------------------
-------- DESTRUCTION SPECIFIC FRAMES
---------------------------------------------------------------------------------------------------
-------- AFFLICTION SPECIFIC FRAMES
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-------- FRAME UTILS
function mWarlock:moveFrame(frame, isMovable)
    if not isMovable then
        frame:EnableMouse(false)
        frame:SetMovable(false)
        return
    end

    frame:EnableMouse(true)
    frame:SetMovable(true)
    
    frame:SetScript("OnMouseDown", function(self, button)
        if not frame:IsMovable() then
            return
        end

        if IsShiftKeyDown() and button == "LeftButton" then
            frame:StartMoving()
        end
    end)
    
    frame:SetScript("OnMouseUp", function(self, button)
        frame:StopMovingOrSizing()
        frameName = frame:GetName()
        local point, relativeTo, relativePoint, offsetX, offsetY = frame:GetPoint()
        MWarlockSavedVariables.framePositions[frameName] = {}
        MWarlockSavedVariables.framePositions[frameName]["point"] = point
        MWarlockSavedVariables.framePositions[frameName]["relativeTo"] = relativeTo
        MWarlockSavedVariables.framePositions[frameName]["relativePoint"] = relativePoint
        MWarlockSavedVariables.framePositions[frameName]["x"] = offsetX
        MWarlockSavedVariables.framePositions[frameName]["y"] = offsetY
    end)
end

function mWarlock:setMovable(isMovable)
    --[[
        Sets frames to be moveable or not. Assigns a blue color to their respective 
        movetex, textures.
    ]]
    mWarlock:moveFrame(shardCounterFrame, isMovable)
    mWarlock:moveFrame(MWarlockMainFrame, isMovable)
    for frameName, frame in pairs(felguardFrames) do
        mWarlock:moveFrame(frame, isMovable)
        if isMovable then
            frame.movetex:SetColorTexture(0, 0, 1, .5)
        else
            frame.movetex:SetColorTexture(0, 0, 0, 0)
        end
    end

    mainFrameIsMoving = isMovable
    if isMovable then
        MWarlockMainFrame.tex:SetColorTexture(0, 0, 1, .5)
        shardCounterFrame.movetex:SetColorTexture(0, 0, 1, .5)
    else
        MWarlockMainFrame.tex:SetColorTexture(0, 0, 0, 0)
        shardCounterFrame.movetex:SetColorTexture(0, 0, 0, 0)
    end
end

function mWarlock:restoreFrame(frameName, frame)
    framePosData = MWarlockSavedVariables.framePositions[frameName]
    x = framePosData["x"] or 0
    y = framePosData["y"] or 190
    point = framePosData["point"] or "CENTER"
    relativeTo = framePosData["relativeTo"] or UIParent
    relativePoint = framePosData["relativePoint"] or "CENTER"
    -- print(x, y)
    -- print(point)
    -- print(relativeTo)
    -- print(relativePoint)
    -- WHY THE FUCK DOES THIS NOT WORK?
    -- frame:SetPoint(tostring(point), relativeTo, tostring(relativePoint), x, y)
    frame:SetPoint(tostring(point),  x, y)
end

