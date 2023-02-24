MW_ALLFRAMES = {}

function mWarlock:CreateMovableFrame(frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize)
    --Creates a moveable frame to be used by mWarlock:SetMoveFrameScripts
    if template == nil then template = "BackdropTemplate" end
    local sizeX = frameSize[1] or DEFAULT_FRAMESIZE
    local sizeY = frameSize[2] or DEFAULT_FRAMESIZE
    
    local frame = CreateFrame("Frame", frameName, parent, template)
    frame:SetPoint("CENTER", parent, "CENTER", 0, 0)
    frame:RegisterForDrag("LeftButton")
    frame:SetSize(sizeX, sizeY)
    frame:Show()
    frame.isWatcher = false
    
    -- Add to the main frames table.
    MW_ALLFRAMES[frameName] = frame

    -- TEXTURE
    if texturePath ~= nil then
        frame.texture = frame:CreateTexture("texture_" .. frameName)
        frame.texture:SetPoint("CENTER", 0, 0)
        frame.texture:SetTexture(texturePath)
    end
    -- MASK
    if maskPath ~= nil then
        frame.mask = frame:CreateMaskTexture("mask_" .. frameName)
        frame.mask:SetPoint("CENTER", 0, 0)
        frame.mask:SetTexture(maskPath, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        frame.texture:AddMaskTexture(frame.mask)
    end

    -------------------------------------------------
    -- special frame to show when move mode is active
    frame.movetex = frame:CreateTexture(nil, "OVERLAY")
    frame.movetex:SetPoint("CENTER", 0, 0)
    frame.movetex:SetAllPoints(frame)
    frame.movetex:SetColorTexture(0, 0, 0, 0)

    if allPoints ~= nil then
        frame.texture:SetAllPoints(frame)
        if mask ~= nil then
            frame.mask:SetAllPoints(frame.texture)
        end
    else
        if textureSize ~= nil then
            local texSizeX = textureSize[1] or 100
            local texSizeY = textureSize[1] or 100
            frame.texture:SetSize(texSizeX, texSizeY)
        end
        if mask ~= nil and maskSize ~= nil then
            local maskSizeX = textureSize[1] or 100
            local maskSizeY = textureSize[1] or 100
            frame.mask:SetSize(maskSizeX, maskSizeY)
        end
    end

    mWarlock:SetMoveFrameScripts(frame)
    -- Now put it all back to where it was previously set by the user if these exist.
    mWarlock:RestoreFrame(frameName, frame)
    
    return frame
end

function mWarlock:SetMoveFrameScripts(frame)
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
        local frameName = frame:GetName()
        local point, relativeTo, relativePoint, offsetX, offsetY = frame:GetPoint()
        MWarlockSavedVariables.framePositions[frameName] = {}
        MWarlockSavedVariables.framePositions[frameName]["point"] = point
        MWarlockSavedVariables.framePositions[frameName]["relativeTo"] = relativeTo
        MWarlockSavedVariables.framePositions[frameName]["relativePoint"] = relativePoint
        MWarlockSavedVariables.framePositions[frameName]["x"] = offsetX
        MWarlockSavedVariables.framePositions[frameName]["y"] = offsetY
        MWarlockSavedVariables.framePositions[frameName]["sx"] = frame:GetWidth()
        MWarlockSavedVariables.framePositions[frameName]["sy"] = frame:GetHeight()
    end)
end

function mWarlock:CreateWatcherFrame(frameName)
    local watcher
    local asButtons = MWarlockSavedVariables["asbuttons"] or false
    if asButtons then
        watcher = CreateFrame("Button", "frameName", MWarlockMainFrame, "SecureActionButtonTemplate")  
        watcher:SetEnabled(true)
        watcher:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
        watcher:SetAttribute("type", "spell")

    else
        watcher = CreateFrame("Frame", frameName, MWarlockMainFrame, "BackdropTemplate")        
    end

    watcher.texture = watcher:CreateTexture(nil, "BACKGROUND")
    watcher.texture:SetAllPoints(watcher)
    watcher.texture:SetTexture("Interface/Tooltips/UI-Tooltip-Background")
    watcher.texture:SetColorTexture(0, 0, 0, 1)
    
    -- TEXTURES
    watcher.mask = watcher:CreateMaskTexture()
    watcher.mask:SetPoint("CENTER", watcher, "CENTER") -- allows scaling.
    watcher.mask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    
    watcher.texture:AddMaskTexture(watcher.mask)
    
    watcher.iconFrame = watcher:CreateTexture(nil, "BACKGROUND")
    watcher.iconFrame:SetPoint("CENTER", watcher, "CENTER") -- allows scaling.
    watcher.iconFrame:AddMaskTexture(watcher.mask)
    
    watcher.borderFrame = watcher:CreateTexture(nil, "ARTWORK")
    watcher.borderFrame:SetPoint("CENTER", watcher, "CENTER") -- allows scaling.
    watcher.borderFrame:SetTexture("Interface/ARTIFACTS/Artifacts-PerkRing-Final-Mask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    watcher.borderFrame:SetAlpha(.5)
    -- TEXTS
    watcher.countText = watcher:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    watcher.countText:SetTextColor(0, 1, 1)
    watcher.countText:SetPoint("CENTER", watcher.iconFrame, "TOP", 00, -15)

    watcher.buffTimerTextBG = watcher:CreateTexture(nil, "BACKGROUND")
    watcher.buffTimerTextBG:SetColorTexture(0, .25, 0, 1)

    watcher.buffTimerText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    watcher.buffTimerText:SetTextColor(.1, 1, .1)

    watcher.cooldownText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    watcher.cooldownText:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, -20)

    watcher.readyText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    watcher.readyText:SetPoint("CENTER", watcher, "CENTER", 0, 0)
    watcher.readyText:SetTextColor(.1, 1, .1)
    watcher.readyText:SetText(READYSTR)

    -- SPECIAL MOVE FRAME TEXTURE
    watcher.movetex = watcher:CreateTexture(nil, "ARTWORK")
    watcher.movetex:SetPoint("CENTER", 0, 0)
    watcher.movetex:SetAllPoints(watcher)
    watcher.movetex:SetColorTexture(0, 0, 0, 0)
    watcher.movetex:AddMaskTexture(watcher.mask)

    watcher.isWatcher = true

    MW_WatcherFrames[#MW_WatcherFrames+1] = watcher
    MW_ALLFRAMES[frameName] = watcher
    return watcher
end

function mWarlock:SetUIMovable(isMovable)
    --Sets frames to be moveable or not. Assigns a blue color to their respective movetex, textures.
    if isMovable == nil then
        isMovable=MWarlockSavedVariables["moveable"] or false
    end
    MAINFRAME_ISMOVING = isMovable

    for _, frame in pairs(MW_ALLFRAMES) do
        if isMovable and not frame.isWatcher then
            frame:EnableMouse(isMovable)
            frame:SetMovable(isMovable)
            frame.movetex:Show()
            frame.movetex:SetColorTexture(0, 0, 1, .5)
            MWarlockMainFrame.texture:SetColorTexture(1, 0, 0, .5)
            MWarlockMainFrame.crosshair:Show()
        elseif not frame.isWatcher then
            frame:EnableMouse(isMovable)
            frame:SetMovable(isMovable)
            frame.movetex:SetColorTexture(0, 0, 0, 0)
            frame.movetex:Hide()
            MWarlockMainFrame.texture:SetColorTexture(1, 0, 0, 0)
            MWarlockMainFrame.crosshair:Hide()
        elseif frame.isWatcher then
            if isMovable then
                frame.texture:Show()
                frame.readyText:Show()
                frame.iconFrame:Show()
                frame.countText:Show()
                frame.cooldownText:Show()
                frame.buffTimerText:Show()
                frame.buffTimerTextBG:Show()
                frame.buffTimerTextBG:SetColorTexture(0, .25, 0, 1)
                frame.movetex:SetColorTexture(1, 0, 0, 1)
                frame.buffTimerText:SetText("00")
                frame.countText:SetText("00")
                frame.cooldownText:SetText("00")
            else
                frame.texture:Hide()
                frame.readyText:Hide()
                frame.iconFrame:Hide()
                frame.countText:Hide()
                frame.cooldownText:Hide()
                frame.buffTimerText:Hide()
                frame.buffTimerTextBG:Hide()
                frame.buffTimerText:SetText("")
                frame.countText:SetText("")
                frame.cooldownText:SetText("")
                frame.movetex:SetColorTexture(1, 0, 0, 0)
            end
            local asButtons = MWarlockSavedVariables["asbuttons"] or false
            if asButtons then
                frame:EnableMouse(true)
                frame:SetEnabled(true)
                frame:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
            end
        end
    end

end

function mWarlock:RestoreFrame(frameName, frame)
    local framePosData = MWarlockSavedVariables.framePositions[frameName]
    if framePosData == nil then
        framePosData = {}
        framePosData["x"] = 0
        framePosData["y"] = 0
        framePosData["point"] = "CENTER"
        framePosData["relativeTo"] = UIParent
        framePosData["relativePoint"] = "CENTER"
        framePosData["size"] = {50, 50}
    end

    local x = framePosData["x"] or 0
    local y = framePosData["y"] or 0
    local point = framePosData["point"] or "CENTER"
    -- local relativeTo = framePosData["relativeTo"] or UIParent
    local relativePoint = framePosData["relativePoint"] or "CENTER"
    frame:SetPoint(tostring(point), UIParent, relativePoint, x, y)
    
    local framesize = framePosData["size"]
    if framesize == nil then
        framePosData["size"] = {50, 50}
    end

    local sx = framePosData["size"][1] or 50
    local sy = framePosData["size"][2] or 50
    frame:SetSize(sx, sy)
    -- WHY THE FUCK DOES THIS NOT WORK ANYMORE!!!!!??????
    -- frame:SetPoint(tostring(point), relativeTo, tostring(relativePoint), x, y)
end

---------------------------------------------------------------------------------------------------
function mWarlock:CreateMainFrame()
    local radius = MWarlockSavedVariables.radius or DEFAULT_RADIUS
    local ooShardsMult = MWarlockSavedVariables.shardOutOfFrameSize or 150
    local size = radius*ooShardsMult
    -- Main Frame
    MWarlockMainFrame = mWarlock:CreateMovableFrame(MAINBG_FRAMENAME,
                                                    {size, size},
                                                    UIParent,
                                                    "BackdropTemplate",
                                                    "Interface/Tooltips/UI-Tooltip-Background",
                                                    "ARTWORK",
                                                    "Interface/Artifacts/Artifacts-PerkRing-Final-Mask",
                                                    false, {size, size}, {size, size})

    -- Out of shards masks and textures are set on this base frame, so we scale this for the red out of shards indicator
    mWarlock:setOOSShardFramesSize()
    -- Create an invisible crosshair indicator for when we are moving the UI
    MWarlockMainFrame.crosshair = MWarlockMainFrame:CreateTexture("crossHair")
    MWarlockMainFrame.crosshair:SetPoint("CENTER", 0, 0)
    local crossHairPath = MEDIAPATH .."\\crosshair.blp"
    MWarlockMainFrame.crosshair:SetTexture(crossHairPath)
    MWarlockMainFrame.crosshair:SetSize(25, 25)
    MWarlockMainFrame.crosshair:Hide()
end
---------------------------------------------------------------------------------------------------
-- PET FRAMES
PetFrames = {}
local last = 0
function mWarlock:createPetFrames()
    for frameName, frame in pairs(PetFrames) do
        frame:Hide()
        frame:SetParent(nil)
    end
    PetFrames = {}
    local hasSummonedPet, summonedPet = mWarlock:hasPetSummoned()
    local petSpellData = {}
    if mWarlock:IsFelguardSummoned() then 
        petSpellData = {
            ["DemonicStrength"] = {["spellName"] = "Demonic Strength",
                                ["spellIcon"] = string.format("%s/Ability_warlock_demonicempowerment.blp", ROOTICONPATH)},
            ["FelStorm"] = {["spellName"] = "FelStorm",
                            ["spellIcon"] = string.format("%s/Ability_warrior_bladestorm.blp", ROOTICONPATH)},
            ["AxeToss"] = {["spellName"] = "Axe Toss",
                                ["spellIcon"] = string.format("%s/Ability_warrior_titansgrip.blp", ROOTICONPATH)},
            ["SoulStrike"] = {["spellName"] = "Soul Strike",
                            ["spellIcon"] = string.format("%s/Inv_polearm_2h_fellord_04.blp", ROOTICONPATH)}
        }
    elseif mWarlock:IsSuccubusSummoned() then 
        petSpellData = {
            ["Seduction"] = {["spellName"] = "Seduction",
                             ["spellIcon"] = string.format("%s/Spell_shadow_seduction.blp", ROOTICONPATH)},
                             ["Whiplash"] = {["spellName"] = "Whiplash",
                             ["spellIcon"] = string.format("%s/Ability_warlock_whiplash.blp", ROOTICONPATH)},        
                            }
    elseif mWarlock:IsFelhunterSummoned() then 
        petSpellData = {
            ["SpelLock"] = {["spellName"] = "Spell Lock",
                            ["spellIcon"] = string.format("%s/Spell_shadow_mindrot.blp", ROOTICONPATH)},
            ["DevourMagic"] = {["spellName"] = "Devour Magic",
                               ["spellIcon"] = string.format("%s/Spell_nature_purge.blp", ROOTICONPATH)},
                            }

    elseif mWarlock:IsVoidWalkerSummoned() then 
        petSpellData = {
            ["ShadowBulwark"] = {["spellName"] = "Shadow Bulwark",
                            ["spellIcon"] = string.format("%s/Spell_shadow_antishadow.blp", ROOTICONPATH)},
            ["Suffering"] = {["spellName"] = "Suffering",
                                ["spellIcon"] = string.format("%s/Spell_shadow_blackplague.blp", ROOTICONPATH)},
                            }
    elseif mWarlock:IsFelImpSummoned() then 
        petSpellData = {
            ["SingeMagic"] = {["spellName"] = "Singe Magic",
                            ["spellIcon"] = string.format("%s/Spell_fire_elementaldevastation.blp", ROOTICONPATH)},
            ["Flee"] = {["spellName"] = "Flee",
                                ["spellIcon"] = string.format("%s/Ability_heroicleap.blp", ROOTICONPATH)},
                            }
    end

    for frameName, spellData in pairs(petSpellData) do
        
        local spellName = spellData["spellName"]
        local spellIcon = spellData["spellIcon"]
        if PetFrames[frameName] == nil then
            -- print("Creating new pet  frame: %s", frameName)
            local size = 100
            local petSpellFrame = mWarlock:CreateMovableFrame(frameName,
                                                {100, 100},
                                                UIParent,
                                                "",
                                                spellIcon,
                                                "ARTWORK",
                                                nil,
                                                true, 
                                                {size, size}, {size, size})
          
            mWarlock:SetMoveFrameScripts(petSpellFrame)
            mWarlock:RestoreFrame(frameName, petSpellFrame)

            petSpellFrame.text = petSpellFrame:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
            -- local petSpellFrameText = petSpellFrame:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
            petSpellFrame.text:SetTextColor(.1, 1, .1)
            petSpellFrame.text:SetText("")
            petSpellFrame.text:SetAllPoints(petSpellFrame.texture)
            petSpellFrame.text:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE, MONOCHROME")
            
            petSpellFrame:SetScript("OnUpdate", function(self, elapsed)
                last = last + elapsed
                if last <= .5 then
                    return
                end

                petSpellFrame.text:SetText("")
                local start, duration, enable = GetSpellCooldown(spellName)
                if enable then
                    local remaining = start + duration - GetTime()
                    local minutes = math.floor(remaining / 60)
                    local seconds = math.floor(remaining - minutes * 60)

                    if remaining < GCD then
                        petSpellFrame.texture:SetAlpha(1)
                        petSpellFrame.text:SetText("")
                        petSpellFrame.text:SetTextColor(.1, 1, .1)
                    else
                        if minutes > 0 then
                            petSpellFrame.text:SetText(string.format("%dm%d", minutes, seconds))
                        else
                            petSpellFrame.text:SetText(string.format("%ds", seconds))
                        end
                        petSpellFrame.text:SetTextColor(1, .1, .1)
                        petSpellFrame.texture:SetAlpha(0.5)
                    end
                    return
                end

                for idx = 1, 30 do
                    local name, _, _, _, _, expirationTime, _, _, _,
                    _, _, _, _, _, _ = UnitBuff("pet", idx)
                    if name == spellName then
                        -- Buff is active               
                        local minutes, seconds = mWarlock:GetAuraTimeLeft(expirationTime)
                        if minutes >0 then
                            petSpellFrame.text:SetText(string.format("%dm%d", minutes, seconds))
                        else
                            petSpellFrame.text:SetText(string.format("%ds", seconds))
                        end
                        petSpellFrame.text:SetTextColor(.1, 1, .1)
                    end
                end
            end)

            -- Add to the frame table for felguard frames
            PetFrames[frameName] = petSpellFrame
        end
    end
    mWarlock:sePetFramePosAndSize()
end

function mWarlock:sePetFramePosAndSize()
    local frameSize = MWarlockSavedVariables["PetFramesSize"] or 45
    for frameName, frame in pairs(PetFrames) do
        mWarlock:RestoreFrame(frameName, frame)
        frame:SetSize(frameSize, frameSize)
    end
end

function mWarlock:HidePetFrames()
    local hidePetFrame = MWarlockSavedVariables["hidePetFrame"] or false
    for _, frame in pairs(PetFrames) do
        if hidePetFrame then
            frame:Hide()
        else
            frame:Show()
        end
    end
end

---------------------------------------------------------------------------------------------------
-- Watcher radial layout.

function mWarlock:radialButtonLayout()
    -- print("Performing radial layout now.")
    --- Handles adding the frames around a unit circle cause I like it better this way....
    local cfontName = "Accidental Presidency.ttf"
    local customFontPath = "Interface\\Addons\\mWarlock\\fonts\\" .. cfontName
    
    local radius = MWarlockSavedVariables.radius or 100
    local offset = MWarlockSavedVariables.offset or 0
    local spread = MWarlockSavedVariables.watcherFrameSpread or 0
    local countFontSize = MWarlockSavedVariables.countFontSize or 22
    local readyFontSize = MWarlockSavedVariables.readyFontSize or 22
    local coolDownFontSize = MWarlockSavedVariables.coolDownFontSize or 22
    local timerFontSize = MWarlockSavedVariables.timerFontSize or 22

    local radialUDOffset = MWarlockSavedVariables.radialUDOffset or 0
    local radialLROffset = MWarlockSavedVariables.radialLROffset or -10

    local cdUDOffset = MWarlockSavedVariables.cdUDOffset or 0
    local cdLROffset = MWarlockSavedVariables.cdLROffset or -10

    local countUDOffset = MWarlockSavedVariables.countUDOffset or 0
    local countLROffset = MWarlockSavedVariables.countLROffset or -10

    local watcherFrameSize = MWarlockSavedVariables.watcherFrameSize or 145

    local angleStep = math.pi / #MW_WatcherFrames + spread
    for x = 1, #MW_WatcherFrames do
        local angle = (x-1)*angleStep + offset*math.pi
        local sinAng = math.sin(angle)
        local cosAng = math.cos(angle)
        local w = cosAng*radius
        local h = sinAng*radius
        local watcher = MW_WatcherFrames[x]
        
        watcher:SetSize(watcherFrameSize, watcherFrameSize)
        watcher.iconFrame:SetSize(watcherFrameSize*1.2, watcherFrameSize*1.2)
        watcher.mask:SetSize(watcherFrameSize, watcherFrameSize)
        watcher.borderFrame:SetSize(watcherFrameSize*1.5, watcherFrameSize*1.5)
        
        watcher.buffTimerTextBG:SetSize(watcherFrameSize/1.5, watcherFrameSize/1.5)
        
        -- TEXT
        watcher.buffTimerText:SetSize(watcherFrameSize*1.25, watcherFrameSize)
        watcher.cooldownText:SetPoint("CENTER", watcher.iconFrame, "CENTER", cdLROffset, cdUDOffset)
        watcher.readyText:SetPoint("CENTER", watcher.iconFrame, "CENTER", cdLROffset, cdUDOffset)
        watcher.countText:SetPoint("CENTER", watcher.iconFrame, "CENTER", countLROffset, countUDOffset)
        
        -- SET FONT
        watcher.buffTimerText:SetFont(customFontPath, timerFontSize, "OUTLINE, MONOCHROME")
        watcher.countText:SetFont(customFontPath, countFontSize, "THICKOUTLINE")
        watcher.cooldownText:SetFont(customFontPath, coolDownFontSize, "THICKOUTLINE")
        watcher.readyText:SetFont(customFontPath, readyFontSize, "THICKOUTLINE")
        
        -- Move the watcher around the center of the frame
        watcher:Show()
        watcher:SetPoint("CENTER", MWarlockMainFrame, "CENTER", w, h)
        
        -- We don't do ANY SHOW HIDE HERE!!
        watcher.buffTimerText:SetPoint("CENTER", watcher.buffTimerTextBG, "CENTER", 0, 0)
        if cosAng <= 0 then
            watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "LEFT", radialLROffset, radialUDOffset)
        elseif cosAng == 0 then
            -- Bottom of the circle, we want to keep the text UNDER the icon here
            watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, radialUDOffset)
        else
            watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "RIGHT", radialLROffset*-1, radialUDOffset)
        end
    end
end
---------------------------------------------------------------------------------------------------