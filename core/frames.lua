
function mWarlock:CreateIconFrame(frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize, asbutton)
    if template == nil then template = "BackdropTemplate" end
    local sizeX = frameSize[1] or DEFAULT_FRAMESIZE
    local sizeY = frameSize[2] or DEFAULT_FRAMESIZE
    -- If we don't explicity set as buttons use the global saved variable.
    if asbutton == nil then
        asbutton = MWarlockSavedVariables["asbuttons"]
    end
    local parentName = "%s_parent", frameName
    local parentFrame = CreateFrame("Frame", parentName, parent, "BackdropTemplate")  
    local frame
    if asbutton then
        frame = CreateFrame("Button", frameName, parentFrame, "SecureActionButtonTemplate")  
        frame:SetEnabled(true)
        frame:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
        frame:SetAttribute("type", "spell")
    else
        frame = CreateFrame("Frame", frameName, parentFrame, template)        
    end
    -- local frame = CreateFrame("Frame", frameName, parent, template)
    frame:SetPoint("CENTER", parent, "CENTER", 0, 0)
    frame:RegisterForDrag("LeftButton")
    frame:SetSize(sizeX, sizeY)
    frame:Show()
    frame.isWatcher = false
    
    -- TEXTURE
    frame.iconFrame = frame:CreateTexture("texture_" .. frameName)
    frame.iconFrame:SetPoint("CENTER", 0, 0)
    if texturePath ~= nil then
        frame.iconFrame:SetTexture(texturePath)
        frame.iconFrame:Show()
    end
    -- MASK
    frame.mask = frame:CreateMaskTexture("mask_" .. frameName)
    if maskPath ~= nil then
        frame.mask:SetPoint("CENTER", 0, 0)
        frame.mask:SetTexture(maskPath, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        frame.iconFrame:AddMaskTexture(frame.mask)
        frame.mask:Show()
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

    -- Add to the main frames table.
    MW_PARENTFRAMES[parentName] = parentFrame
    MW_ALLFRAMES[frameName] = frame
    return frame
end

function mWarlock:CreateFrameTimerElements(frame)
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

function mWarlock:CreateMovableFrame(frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize, asTimer)
    -- Creates a moveable icon frame to be used by mWarlock:SetMoveFrameScripts
    local frame = mWarlock:CreateIconFrame(frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize)
    if asTimer then
        mWarlock:CreateFrameTimerElements(frame)
    end
    -- Now put it all back to where it was previously set by the user if these exist.
    mWarlock:RestoreFrame(frameName, frame)
    mWarlock:SetMoveFrameScripts(frame)
    return frame
end

function mWarlock:CreateRadialWatcherFrame(frameName, spellName, iconPath)
    -- Timer frame, that is part of the radial menu that doesn't get moved when the UI is set to movable state.
    
    local asButtons = MWarlockSavedVariables["asbuttons"] or false
    -- frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize, asbutton
    local size = 200
    local watcher = mWarlock:CreateIconFrame(frameName, 
                                            {size, size}, 
                                            MWarlockMainFrame, 
                                            "BackdropTemplate", 
                                            iconPath, 
                                            "ARTWORK", 
                                            "Interface/CHARACTERFRAME/TempPortraitAlphaMask", 
                                            nil, 
                                            {size, size}, 
                                            {size, size}, 
                                            asButtons)
    mWarlock:CreateFrameTimerElements(watcher)
    
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
    watcher:Show()
    MW_WatcherFrames[#MW_WatcherFrames+1] = watcher
    return watcher
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
            MWarlockMainFrame.iconFrame:SetColorTexture(1, 0, 0, .5)
            MWarlockMainFrame.crosshair:Show()
        elseif not isMovable and not frame.isWatcher then
            frame:EnableMouse(isMovable)
            frame:SetMovable(isMovable)
            frame.movetex:SetColorTexture(0, 0, 0, 0)
            frame.movetex:Hide()
            MWarlockMainFrame.iconFrame:SetColorTexture(1, 0, 0, 0)
            MWarlockMainFrame.crosshair:Hide()
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

function mWarlock:RestoreFrame(frameName, frame)
    local framePosData = MWarlockSavedVariables.framePositions[frameName]
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

function mWarlock:RemoveAllWatcherFrames()
    for x = 1, #MW_WatcherFrames do
        local frame = MW_WatcherFrames[x]
        -- print("Removing: %s", frame:GetName())
        
        local frameName = frame:GetName()
        for index, frame in ipairs(MW_ALLFRAMES) do
            if frameName == frame:GetName() then
                MW_ALLFRAMES.remove(index)
            end
        end
        frame:Hide()
        frame:SetParent(nil)
    end
end

function mWarlock:RemoveAllParentFrames()
    for x = 1, #MW_WatcherFrames do
        local frame = MW_WatcherFrames[x]
        -- print("Removing: %s", frame:GetName())
        
        local frameName = frame:GetName()
        for index, frame in ipairs(MW_PARENTFRAMES) do
            if frameName == frame:GetName() then
                MW_PARENTFRAMES.remove(index)
            end
        end
        frame:Hide()
        frame:SetParent(nil)
    end
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
    MWarlockMainFrame:Show()
end
---------------------------------------------------------------------------------------------------
-- PET FRAMES
PetFrames = {}
local last = 0
function mWarlock:createPetFrames()
    -- Clear out existing
    for _, frame in pairs(PetFrames) do
        frame:Hide()
        frame:SetParent(nil)
    end

    PetFrames = {}
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
            local frame = mWarlock:CreateMovableFrame(frameName,
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
            
            frame:SetScript("OnUpdate", function(self, elapsed)
                last = last + elapsed
                if last <= .1 then
                    return
                end
                mWarlock:DoSpellFrameCooldown(spellName, frame)
                mWarlock:DoPetFrameAuraTimer(spellName, frame)
                last = 0
            end)
            
            -- Add to the frame table for felguard frames
            PetFrames[frameName] = frame
        end
    end
    mWarlock:setPetFramePosAndSize()
    
end

function mWarlock:setPetFramePosAndSize()
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
    local widthDeform = MWarlockSavedVariables.widthDeform or 1
    local heightDeform = MWarlockSavedVariables.heightDeform or 1

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

    local watcherFrameSize = MWarlockSavedVariables.watcherFrameSize or 45

    local angleStep = math.pi / #MW_WatcherFrames + spread
    for x = 1, #MW_WatcherFrames do
        local angle = (x-1)*angleStep + offset*math.pi
        local sinAng = math.sin(angle)
        local cosAng = math.cos(angle)
        local w = cosAng*radius*widthDeform
        local h = sinAng*radius*heightDeform
        local watcher = MW_WatcherFrames[x]

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
        watcher.cooldownText:SetPoint("CENTER", watcher.iconFrame, "CENTER", cdLROffset, cdUDOffset)
        watcher.readyText:SetPoint("CENTER", watcher.iconFrame, "CENTER", cdLROffset, cdUDOffset)
        watcher.countText:SetPoint("CENTER", watcher.iconFrame, "CENTER", countLROffset, countUDOffset)
        
        -- SET FONT
        watcher.buffTimerText:SetFont(customFontPath, timerFontSize, "OUTLINE, MONOCHROME")
        watcher.debuffTimerText:SetFont(customFontPath, timerFontSize, "OUTLINE, MONOCHROME")
        watcher.countText:SetFont(customFontPath, countFontSize, "THICKOUTLINE")
        watcher.cooldownText:SetFont(customFontPath, coolDownFontSize, "THICKOUTLINE")
        watcher.readyText:SetFont(customFontPath, readyFontSize, "THICKOUTLINE")
        
        -- Move the watcher around the center of the frame
        watcher:SetPoint("CENTER", MWarlockMainFrame, "CENTER", w, h)
        
        -- We don't do ANY SHOW HIDE HERE!!
        watcher.buffTimerText:SetPoint("CENTER", watcher.buffTimerTextBG, "CENTER", 0, 0)
        watcher.debuffTimerText:SetPoint("CENTER", watcher.buffTimerTextBG, "CENTER", 0, 0)
        if cosAng <= 0 then
            watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "LEFT", radialLROffset, radialUDOffset)
            watcher.debuffTimerText:SetPoint("CENTER", watcher.iconFrame, "LEFT", radialLROffset, radialUDOffset)
        elseif cosAng == 0 then
            -- Bottom of the circle, we want to keep the text UNDER the icon here
            watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, radialUDOffset)
            watcher.debuffTimerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, radialUDOffset)
        else
            watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "RIGHT", radialLROffset*-1, radialUDOffset)
            watcher.debuffTimerText:SetPoint("CENTER", watcher.iconFrame, "RIGHT", radialLROffset*-1, radialUDOffset)
        end
    end
end
---------------------------------------------------------------------------------------------------