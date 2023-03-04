function mRadial:CreateIconFrame(frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize, asbutton)
    if template == nil then template = "BackdropTemplate" end
    local sizeX = frameSize[1] or DEFAULT_FRAMESIZE
    local sizeY = frameSize[2] or DEFAULT_FRAMESIZE
    -- If we don't explicity set as buttons use the global saved variable.
    if asbutton == nil then
        asbutton = MRadialSavedVariables["asbuttons"]
    end
    local parentName = frameName .."_parent"
    local parentFrame = CreateFrame("Frame", parentName, parent, "BackdropTemplate")  
    -- parentFrame:SetParentKey(parentName)

    local frame
    if asbutton then
        frame = CreateFrame("Button", frameName, parentFrame, "SecureActionButtonTemplate")  
        frame:SetEnabled(true)
        frame:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
        frame:SetAttribute("type", "spell")
        frame:SetParent(parentFrame)
    else
        frame = CreateFrame("Frame", frameName, parentFrame, template)        
        frame:SetParent(parentFrame)
    end

    -- local frame = CreateFrame("Frame", frameName, parent, template)
    frame:SetPoint("CENTER", parent, "CENTER", 0, 0)
    frame:RegisterForDrag("LeftButton")
    frame:SetSize(sizeX, sizeY)
    
    -- TEXTURE
    frame.iconFrame = frame:CreateTexture("texture_" .. frameName)
    frame.iconFrame:SetPoint("CENTER", 0, 0)
    if texturePath ~= nil then
        frame.iconFrame:SetTexture(texturePath)
    end
    -- MASK
    frame.mask = frame:CreateMaskTexture("mask_" .. frameName)
    if maskPath ~= nil then
        frame.mask:SetPoint("CENTER", 0, 0)
        frame.mask:SetTexture(maskPath, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        frame.iconFrame:AddMaskTexture(frame.mask)
    end

    -------------------------------------------------
    -- special frame to show when move mode is active
    frame.movetex = frame:CreateTexture(nil, "OVERLAY")
    frame.movetex:SetPoint("CENTER", 0, 0)
    frame.movetex:SetAllPoints(frame)
    frame.movetex:SetColorTexture(0, 0, 0, 0)

    if allPoints ~= nil then
        frame.iconFrame:SetAllPoints(frame)
        if frame.mask ~= nil then
            frame.mask:SetAllPoints(frame.iconFrame)
        end
    else
        if textureSize ~= nil then
            local texSizeX = textureSize[1] or 100
            local texSizeY = textureSize[1] or 100
            frame.iconFrame:SetSize(texSizeX, texSizeY)
        end
        if frame.mask ~= nil and maskSize ~= nil then
            local maskSizeX = textureSize[1] or 100
            local maskSizeY = textureSize[1] or 100
            frame.mask:SetSize(maskSizeX, maskSizeY)
        end
    end

    frame.isPetFrame = false
    frame.isWatcher = false
    -- Add to the main frames table.
    MR_PARENTFRAMES[#MR_PARENTFRAMES+1] = parentFrame
    MR_ALLFRAMES[#MR_ALLFRAMES+1] = frame
    return frame
end

function mRadial:CreateFrameTimerElements(frame)
    -- TEXTS
    frame.countText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.countText:SetTextColor(0, 1, 1)
    frame.countText:SetPoint("CENTER", frame.iconFrame, "TOP", 00, -15)

    frame.buffTimerTextBG = frame:CreateTexture(nil, "BACKGROUND")
    frame.buffTimerTextBG:SetColorTexture(0, .25, 0, 1)

    frame.buffTimerText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.buffTimerText:SetTextColor(.1, 1, .1)

    frame.debuffTimerText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.debuffTimerText:SetTextColor(1, 0, 0)

    frame.cooldownText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.cooldownText:SetPoint("CENTER", frame.iconFrame, "CENTER", 0, -20)

    frame.readyText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.readyText:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.readyText:SetTextColor(.1, 1, .1)
    frame.readyText:SetText(READYSTR)

end

function mRadial:CreateMovableFrame(frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize, asTimer)
    -- Creates a moveable icon frame to be used by mRadial:SetMoveFrameScripts
    local frame = mRadial:CreateIconFrame(frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize)
    if asTimer then
        mRadial:CreateFrameTimerElements(frame)
    end
    -- Now put it all back to where it was previously set by the user if these exist.
    mRadial:RestoreFrame(frameName, frame)
    mRadial:SetMoveFrameScripts(frame)
    return frame
end

function mRadial:CreateRadialWatcherFrame(frameName, spellName, iconPath)
    -- Timer frame, that is part of the radial menu that doesn't get moved when the UI is set to movable state.
    
    local asButtons = MRadialSavedVariables["asbuttons"] or false
    local size = 200
    -- frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize, asbutton
    local watcher = mRadial:CreateIconFrame(frameName, 
                                            {size, size}, 
                                            mRadialMainFrame, 
                                            "BackdropTemplate", 
                                            iconPath, 
                                            "ARTWORK", 
                                            "Interface/CHARACTERFRAME/TempPortraitAlphaMask", 
                                            nil, 
                                            {size, size}, 
                                            {size, size}, 
                                            asButtons)
    
    mRadial:CreateFrameTimerElements(watcher)
    
    -- -- Assign a nice littler border..
    watcher.borderFrame = watcher:CreateTexture(nil, "ARTWORK")
    watcher.borderFrame:SetPoint("CENTER", watcher, "CENTER") -- allows scaling.
    watcher.borderFrame:SetTexture("Interface/ARTIFACTS/Artifacts-PerkRing-Final-Mask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    watcher.borderFrame:SetAlpha(.5)
    
    -- make sure to mask the base icons the same as the 
    watcher.movetex:AddMaskTexture(watcher.mask)
    
    watcher.aura = watcher:CreateTexture(nil, "OVERLAY")
    watcher.aura:SetPoint("CENTER", 0, 0)
    watcher.aura:SetTexture("Interface/COMMON/portrait-ring-withbg-highlight", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    watcher.aura:Hide()
    -- watcher.aura:AddMaskTexture(watcher.mask)

    -- special tag for helping determine this is a raidal button.
    watcher.isWatcher = true
    mRadial:SetMountedFrameScripts(watcher)

    return watcher
end

function mRadial:SetMoveFrameScripts(frame)
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
        MRadialSavedVariables.framePositions[frameName] = {}
        MRadialSavedVariables.framePositions[frameName]["point"] = point
        MRadialSavedVariables.framePositions[frameName]["relativeTo"] = relativeTo
        MRadialSavedVariables.framePositions[frameName]["relativePoint"] = relativePoint
        MRadialSavedVariables.framePositions[frameName]["x"] = offsetX
        MRadialSavedVariables.framePositions[frameName]["y"] = offsetY
        MRadialSavedVariables.framePositions[frameName]["sx"] = frame:GetWidth()
        MRadialSavedVariables.framePositions[frameName]["sy"] = frame:GetHeight()
    end)
end

local mlast = 0
function mRadial:SetMountedFrameScripts(frame)
    frame:GetParent():SetScript("OnUpdate", function(self, elapsed)
        mlast = mlast + elapsed
        if mlast <= .02 then
            return
        end
        if IsMounted() or IsFlying() then
            frame:Hide()
        else
            frame:Show()
        end
        mlast = 0
        frame:RegisterEvent("PLAYER_REGEN_DISABLED")
        frame:SetScript("OnEvent", function(self, event, ...)
            -- Show the frame when entering combat
            if event == "PLAYER_REGEN_DISABLED" then
                frame:Show()
            end
        end)
    end)
end

function mRadial:SetUIMovable(isMovable)
    --Sets frames to be moveable or not. Assigns a blue color to their respective movetex, textures.
    if isMovable == nil then
        isMovable=MRadialSavedVariables["moveable"] or false
    end

    MAINFRAME_ISMOVING = isMovable
    for _, frame in pairs(MR_ALLFRAMES) do
        if isMovable and not frame.isWatcher then
            frame:EnableMouse(isMovable)
            frame:SetMovable(isMovable)
            frame.movetex:Show()
            frame.movetex:SetColorTexture(0, 0, 1, .5)
            mRadialMainFrame.iconFrame:SetColorTexture(1, 0, 0, .5)
            mRadialMainFrame.crosshair:Show()
        elseif not isMovable and not frame.isWatcher then
            frame:EnableMouse(isMovable)
            frame:SetMovable(isMovable)
            frame.movetex:SetColorTexture(0, 0, 0, 0)
            frame.movetex:Hide()
            mRadialMainFrame.iconFrame:SetColorTexture(1, 0, 0, 0)
            mRadialMainFrame.crosshair:Hide()
        elseif frame.isWatcher then
            if isMovable then
                frame.readyText:Show()
                frame.iconFrame:Show()
                frame.countText:Show()
                frame.cooldownText:Show()
                frame.buffTimerText:Show()
                frame.buffTimerTextBG:Show()
                frame.buffTimerTextBG:SetColorTexture(0, .25, 0, 1)
                frame.buffTimerText:SetText("00")
                frame.countText:SetText("00")
                frame.cooldownText:SetText("00")
                frame.movetex:SetColorTexture(1, 0, 0, 1)
            end
        end
    end

end

function mRadial:RestoreFrame(frameName, frame)
    local framePosData = MRadialSavedVariables.framePositions[frameName]
    if framePosData == nil then
        framePosData = {}
        framePosData["x"] = 0
        framePosData["y"] = 0
        framePosData["point"] = "CENTER"
        framePosData["relativeTo"] = "UIParent"
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

function mRadial:createWatcherFrames()
    local activeTalentTreeSpells = mRadial:GetAllActiveTalentTreeSpells()
    if activeTalentTreeSpells == nil then
        return
    end
    for _, spellInfo in ipairs(activeTalentTreeSpells) do
        local spellId = spellInfo[2]
        local spellName, rank, iconPath, castTime, minRange, maxRange, spellID, originalSpellIcon = GetSpellInfo(spellId)
        local isActive  = false
        if spellName ~= nil then 
            isActive = MRadialSavedVariables["isActive"..spellName] or false
            
            local isKnown  = IsPlayerSpell(spellId)
            local isPassive = IsPassiveSpell(spellID)
            if isActive and isKnown and not isPassive then
                -- print("Adding watcherFrame for  %s", spellName)
                mRadial:addWatcherFrame(spellID)
                UdOffset = UdOffset + 32
            end
        end
    end
end

---------------------------------------------------------------------------------------------------
function mRadial:CreateMainFrame()
    local radius = MRadialSavedVariables.radius or DEFAULT_RADIUS
    local ooShardsMult = MRadialSavedVariables.shardOutOfFrameSize or 150
    local size = radius*ooShardsMult
    -- Main Frame
    mRadialMainFrame = mRadial:CreateMovableFrame(MAINBG_FRAMENAME,
                                                    {size, size},
                                                    UIParent,
                                                    "BackdropTemplate",
                                                    "Interface/Tooltips/UI-Tooltip-Background",
                                                    "ARTWORK",
                                                    "Interface/Artifacts/Artifacts-PerkRing-Final-Mask",
                                                    false, {size, size}, {size, size})

    -- Out of shards masks and textures are set on this base frame, so we scale this for the red out of shards indicator
    mRadial:setOOSShardFramesSize()

    -- Create an invisible crosshair indicator for when we are moving the UI
    mRadialMainFrame.crosshair = mRadialMainFrame:CreateTexture("crossHair")
    mRadialMainFrame.crosshair:SetPoint("CENTER", 0, 0)
    local crossHairPath = MEDIAPATH .."\\crosshair.blp"
    mRadialMainFrame.crosshair:SetTexture(crossHairPath)
    mRadialMainFrame.crosshair:SetSize(25, 25)
    mRadialMainFrame.crosshair:Hide()
    mRadialMainFrame:Show()
end
---------------------------------------------------------------------------------------------------
-- PET FRAMES
local plast = 0
function mRadial:createPetFrames()
    mRadial:RemoveAllPetFrames()
    -- Clear out existing
    local petSpellData = {}
    if mRadial:IsFelguardSummoned() then 
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
    elseif mRadial:IsSuccubusSummoned() then 
        petSpellData = {
            ["Seduction"] = {["spellName"] = "Seduction",
                             ["spellIcon"] = string.format("%s/Spell_shadow_seduction.blp", ROOTICONPATH)},
                             ["Whiplash"] = {["spellName"] = "Whiplash",
                             ["spellIcon"] = string.format("%s/Ability_warlock_whiplash.blp", ROOTICONPATH)},        
                            }
    elseif mRadial:IsFelhunterSummoned() then 
        petSpellData = {
            ["SpelLock"] = {["spellName"] = "Spell Lock",
                            ["spellIcon"] = string.format("%s/Spell_shadow_mindrot.blp", ROOTICONPATH)},
            ["DevourMagic"] = {["spellName"] = "Devour Magic",
                               ["spellIcon"] = string.format("%s/Spell_nature_purge.blp", ROOTICONPATH)},
                            }

    elseif mRadial:IsVoidWalkerSummoned() then 
        petSpellData = {
            ["ShadowBulwark"] = {["spellName"] = "Shadow Bulwark",
                            ["spellIcon"] = string.format("%s/Spell_shadow_antishadow.blp", ROOTICONPATH)},
            ["Suffering"] = {["spellName"] = "Suffering",
                                ["spellIcon"] = string.format("%s/Spell_shadow_blackplague.blp", ROOTICONPATH)},
                            }
    elseif mRadial:IsFelImpSummoned() then 
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
        if MR_ALLFRAMES[frameName] == nil then
            -- print("Creating new pet  frame: %s", frameName)
            local size = 100
            local frame = mRadial:CreateMovableFrame(frameName,
                                                {100, 100},
                                                UIParent,
                                                "",
                                                spellIcon,
                                                "ARTWORK",
                                                nil,
                                                true, 
                                                {size, size}, {size, size},
                                                true)
          
            frame.cooldownText:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE, MONOCHROME")
            frame.isPetFrame = true
            frame:SetScript("OnUpdate", function(self, elapsed)
                plast = plast + elapsed
                if plast <= .05 then
                    return
                end
                mRadial:DoSpellFrameCooldown(spellName, frame)
                mRadial:DoPetFrameAuraTimer(spellName, frame)
                plast = 0
            end)
            
        end
    end
end

function mRadial:ShowPetFrames()
    for _, frame in pairs(MR_ALLFRAMES) do
        if frame.isPetFrame then
            frame:Show()
        end
    end
end

function mRadial:TogglePetFrameVisibility()
    local isVisible = MRadialSavedVariables["hidePetFrame"] or false
    for _, frame in pairs(MR_ALLFRAMES) do
        if frame.isPetFrame and isVisible then
            frame:Hide()
        elseif frame.isPetFrame and not isVisible then
            frame:Show()
        end
    end
end

function mRadial:RemoveAllPetFrames()
    for idx, frame in pairs(MR_ALLFRAMES) do
        if frame.isPetFrame then
            local children = frame:GetChildren()
            if children ~= nil then
                for childFrame in children do
                    childFrame:Hide()
                    childFrame:SetParent(nil)
                end
            end
            MR_ALLFRAMES[idx] = nil
            frame:Hide()
            frame:SetParent(nil)
        end
    end
end

function mRadial:setPetFramePosAndSize()
    local frameSize = MRadialSavedVariables["PetFramesSize"] or 45
    for idx, frame in ipairs(MR_ALLFRAMES) do
        if frame.isPetFrame then
            mRadial:RestoreFrame(frame:GetName(), frame)
            frame:SetSize(frameSize, frameSize)
        end
    end
end
---------------------------------------------------------------------------------------------------
-- Watcher radial layout.

function mRadial:radialButtonLayout()
    print("Performing radial layout now.")
    --- Handles adding the frames around a unit circle cause I like it better this way....
    local cfontName = "Accidental Presidency.ttf"
    local customFontPath = "Interface\\Addons\\mRadial\\fonts\\" .. cfontName
    
    local radius = MRadialSavedVariables.radius or 100
    local offset = MRadialSavedVariables.offset or 0
    local spread = MRadialSavedVariables.watcherFrameSpread or 0
    local widthDeform = MRadialSavedVariables.widthDeform or 1
    local heightDeform = MRadialSavedVariables.heightDeform or 1

    local countFontSize = MRadialSavedVariables.countFontSize or 22
    local readyFontSize = MRadialSavedVariables.readyFontSize or 22
    local coolDownFontSize = MRadialSavedVariables.coolDownFontSize or 22
    local timerFontSize = MRadialSavedVariables.timerFontSize or 22

    local radialUdOffset = MRadialSavedVariables.radialUdOffset or 0
    local radialLROffset = MRadialSavedVariables.radialLROffset or -10

    local cdUdOffset = MRadialSavedVariables.cdUdOffset or 0
    local cdLROffset = MRadialSavedVariables.cdLROffset or -10

    local countUdOffset = MRadialSavedVariables.countUdOffset or 0
    local countLROffset = MRadialSavedVariables.countLROffset or -10

    local watcherFrameSize = MRadialSavedVariables.watcherFrameSize or 45

    local angleStep = math.pi / #MR_ALLFRAMES + spread
    for x = 1, #MR_ALLFRAMES do
        local angle = (x-1)*angleStep + offset*math.pi
        local sinAng = math.sin(angle)
        local cosAng = math.cos(angle)
        local w = cosAng*radius*widthDeform
        local h = sinAng*radius*heightDeform
        local watcher = MR_ALLFRAMES[x]
        if watcher.isWatcher then
            -- print("Found watcher frame!")
            watcher:SetSize(watcherFrameSize, watcherFrameSize)
            -- expand the iconFrame a little so we don't get strange squares in the circles.
            watcher.iconFrame:SetSize(watcherFrameSize*1.2, watcherFrameSize*1.2)
            -- because the graphic for the border is a little smaller.. we wanna handle the scale now too
            watcher.borderFrame:SetSize(watcherFrameSize*1.6, watcherFrameSize*1.6)
            watcher.aura:SetSize(watcherFrameSize*3, watcherFrameSize*3)
            
            watcher.mask:SetSize(watcherFrameSize, watcherFrameSize)
            watcher.buffTimerTextBG:SetSize(watcherFrameSize/1.5, watcherFrameSize/1.5)
            
            -- TEXT
            watcher.buffTimerText:SetSize(watcherFrameSize*1.25, watcherFrameSize)
            watcher.debuffTimerText:SetSize(watcherFrameSize*1.25, watcherFrameSize)
            watcher.cooldownText:SetPoint("CENTER", watcher.iconFrame, "CENTER", cdLROffset, cdUdOffset)
            watcher.readyText:SetPoint("CENTER", watcher.iconFrame, "CENTER", cdLROffset, cdUdOffset)
            watcher.countText:SetPoint("CENTER", watcher.iconFrame, "CENTER", countLROffset, countUdOffset)
            
            -- SET FONT
            watcher.buffTimerText:SetFont(customFontPath, timerFontSize, "OUTLINE, MONOCHROME")
            watcher.debuffTimerText:SetFont(customFontPath, timerFontSize, "OUTLINE, MONOCHROME")
            watcher.countText:SetFont(customFontPath, countFontSize, "THICKOUTLINE")
            watcher.cooldownText:SetFont(customFontPath, coolDownFontSize, "THICKOUTLINE")
            watcher.readyText:SetFont(customFontPath, readyFontSize, "THICKOUTLINE")
            
            -- Move the watcher around the center of the frame
            watcher:SetPoint("CENTER", mRadialMainFrame, "CENTER", w, h)
            
            -- We don't do ANY SHOW HIDE HERE!!
            watcher.buffTimerText:SetPoint("CENTER", watcher.buffTimerTextBG, "CENTER", 0, 0)
            watcher.debuffTimerText:SetPoint("CENTER", watcher.buffTimerTextBG, "CENTER", 0, 0)
            if cosAng <= 0 then
                watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "LEFT", radialLROffset, radialUdOffset)
                watcher.debuffTimerText:SetPoint("CENTER", watcher.iconFrame, "LEFT", radialLROffset, radialUdOffset)
            elseif cosAng == 0 then
                -- Bottom of the circle, we want to keep the text UNDER the icon here
                watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, radialUdOffset)
                watcher.debuffTimerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, radialUdOffset)
            else
            watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "RIGHT", radialLROffset*-1, radialUdOffset)
            watcher.debuffTimerText:SetPoint("CENTER", watcher.iconFrame, "RIGHT", radialLROffset*-1, radialUdOffset)
            end
        end
    end
end
---------------------------------------------------------------------------------------------------
function mRadial:RemoveAllParentFrames()
    -- Used by the InitUI to clear all existing frames for a full refresh on spec changes etc
    if MR_PARENTFRAMES == nil then
        return
    end

    for x = 1, #MR_PARENTFRAMES do
        local frame = MR_PARENTFRAMES[x]
        local children = frame:GetChildren()
        if children ~= nil then
            for idx, childFrame in ipairs(children) do
                childFrame:Hide()
                childFrame:SetParent(nil)
            end
        end
        frame:Hide()
        frame:SetParent(nil)
    end
end