local appName = "mRadial"
local L = LibStub("AceLocale-3.0"):GetLocale(appName, false) or nil

function mRadial:CreateIconFrame(frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize, asbutton, spellName)
    if template == nil then template = "BackdropTemplate" end
    local sizeX = frameSize[1] or DEFAULT_FRAMESIZE
    local sizeY = frameSize[2] or DEFAULT_FRAMESIZE
    -- If we don't explicity set as buttons use the global saved variable.
    if asbutton == nil then
        asbutton = MRadialSavedVariables["asbuttons"] or MR_DEFAULT_ASBUTTONS
    end
    local parentName = frameName .."_parent"
    local parentFrame = CreateFrame("Frame", parentName, parent, "BackdropTemplate")
    parentFrame.isParentFrame = true

    local frame
    if asbutton then
        frame = CreateFrame("Button", frameName, parentFrame, "SecureActionButtonTemplate")  
        frame:SetEnabled(true)
        frame:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
        frame:SetParent(parentFrame)
    else
        frame = CreateFrame("Frame", frameName, parentFrame, template)        
        frame:SetParent(parentFrame)
    end
    frame:SetAttribute("type", "spell")
    frame:SetAttribute("name", spellName)

    -- local frame = CreateFrame("Frame", frameName, parent, template)
    frame:SetPoint("CENTER", parent, "CENTER", 0, 0)
    frame:RegisterForDrag("LeftButton")
    frame:SetSize(sizeX, sizeY)
    parentFrame.baseFrame = frame
    
    -- TEXTURE
    frame.iconFrame = frame:CreateTexture("texture_" .. frameName, strata)
    frame.iconFrame:SetPoint("CENTER", 0, 0)
    if texturePath ~= nil then
        frame.iconFrame:SetTexture(texturePath)
        frame.iconPath = texturePath
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
    frame.movetext = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.movetext:SetTextColor(1, 1, 1, 0)
    frame.movetext:SetPoint("CENTER", frame.iconFrame, "TOP", 0, 0)
    frame.movetext:SetText(frame:GetName())
    if maskPath ~= nil then
        frame.movetex:AddMaskTexture(frame.mask)
    end
    mRadial:HideFrame(frame.movetext)

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
    frame.countText:SetPoint("CENTER", frame.iconFrame, "TOP", 00, -15)

    frame.buffTimerTextBG = frame:CreateTexture(nil, "BACKGROUND")
    frame.buffTimerTextBG:SetColorTexture(0, .25, 0, 1)

    frame.buffTimerText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")

    frame.debuffTimerTextBG = frame:CreateTexture(nil, "BACKGROUND")
    frame.debuffTimerTextBG:SetColorTexture(.25, 0, 0, 1)
    frame.debuffTimerText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")

    frame.cooldownText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.cooldownText:SetPoint("CENTER", frame.iconFrame, "CENTER", 0, -20)

    frame.readyText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.readyText:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.readyText:SetText(READYSTR)
    
    frame.powerText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.powerText:SetPoint("CENTER", frame, "CENTER", 0, 0)

    local customFontPath = MRadialSavedVariables['Font'] or MR_DEFAULT_FONT
    frame.buffTimerText:SetFont(customFontPath,  24, "OUTLINE, MONOCHROME")
    frame.debuffTimerText:SetFont(customFontPath,  24, "OUTLINE, MONOCHROME")
    frame.countText:SetFont(customFontPath,  24, "THICKOUTLINE")
    frame.cooldownText:SetFont(customFontPath,  24, "THICKOUTLINE")
    frame.readyText:SetFont(customFontPath, 24, "THICKOUTLINE")
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

function mRadial:CreateRadialWatcherFrame(frameName, spellName, iconPath, parentFrame)
    -- Timer frame, that is part of the radial menu that doesn't get moved when the UI is set to movable state.
    local asButtons = MRadialSavedVariables["asbuttons"] or MR_DEFAULT_ASBUTTONS
    local size = 200
    -- frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize, asbutton
    local watcher = mRadial:CreateIconFrame(frameName, 
                                            {size, size}, 
                                            parentFrame, 
                                            "BackdropTemplate", 
                                            iconPath, 
                                            "ARTWORK", 
                                            "Interface/CHARACTERFRAME/TempPortraitAlphaMask", 
                                            nil, 
                                            {size, size}, 
                                            {size, size}, 
                                            asButtons,
                                            spellName)
    
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
    mRadial:HideFrame(watcher.aura)
    
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
        local playerName = UnitName("player")
        local playerSpec = GetSpecialization()
        local frameCache = PerPlayerPerSpecSavedVars[playerName][playerSpec]["framePositions"]
        local frameName = frame:GetName()
        -- print("storing frame pos: %s", frameName)
        local point, relativeTo, relativePoint, offsetX, offsetY = frame:GetPoint()
        frameCache[frameName] = {}
        frameCache[frameName]["point"] = point
        frameCache[frameName]["relativeTo"] = relativeTo
        frameCache[frameName]["relativePoint"] = relativePoint
        frameCache[frameName]["x"] = offsetX
        frameCache[frameName]["y"] = offsetY
        frameCache[frameName]["sx"] = frame:GetWidth()
        frameCache[frameName]["sy"] = frame:GetHeight()
    end)
end

function mRadial:SetMountedFrameScripts(frame, alpha)
    frame:GetParent():RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:GetParent():SetScript("OnEvent", function(self, event, ...)
        local asButtons = MRadialSavedVariables["asbuttons"] or MR_DEFAULT_ASBUTTONS
        -- Show the frame when entering combat
        if event == "PLAYER_REGEN_DISABLED" then
            mRadial:ShowFrame(frame)
            if asButtons and frame.isWatcher then
                frame:EnableMouse(true)
            end
        end
    end)

    frame:GetParent():SetScript("OnUpdate", function(self, elapsed)
        local hideOOC = MRadialSavedVariables["hideooc"] or MR_DEFAULT_HIDEOOC
        local asButtons = MRadialSavedVariables["asbuttons"] or MR_DEFAULT_ASBUTTONS
        if IsMounted() or IsFlying() then
            mRadial:HideFrame(frame)
            if asButtons and frame.isWatcher and not InCombatLockdown() then
                frame:EnableMouse(false)
            end
        else
            if hideOOC and not InCombatLockdown() then 
                mRadial:HideFrame(frame)
            else
                mRadial:ShowFrame(frame, alpha)
            end
            if asButtons and frame.isWatcher and not InCombatLockdown() then
                frame:EnableMouse(true)
            end
        end
    end)
end

function mRadial:SetUIMovable(isMovable)
    --Sets frames to be moveable or not. Assigns a blue color to their respective movetex, textures.
    if isMovable == nil then
        isMovable = MRadialSavedVariables["moveable"] or false
    end
    MAINFRAME_ISMOVING = isMovable
    
    if isMovable then
        if mRadial:IsWarlock() then
            mRadial:ShowFrame(MRadialMainFrame.crosshair)
            local hideOOfShardFrame = MRadialSavedVariables["hideOOShardFrame"]
            if hideOOfShardFrame == nil then hideOOfShardFrame = MR_DEFAULT_HIDE_OOSF end
            if not hideOOfShardFrame then 
                MRadialMainFrame.iconFrame:SetColorTexture(1, 0, 0, .5)
            else
                MRadialMainFrame.iconFrame:SetColorTexture(1, 0, 0, 0)
            end
        end
        MRadialPrimaryFrame.iconFrame:SetColorTexture(1, 0, 1, .5)
        MRadialSecondaryFrame.iconFrame:SetColorTexture(1, 0, 1, .5)
    else
        mRadial:HideFrame(MRadialMainFrame.crosshair)
        MRadialMainFrame.iconFrame:SetColorTexture(1, 0, 0, 0)
        MRadialPrimaryFrame.iconFrame:SetColorTexture(1, 0, 0, 0)
        MRadialSecondaryFrame.iconFrame:SetColorTexture(1, 0, 0, 0)
    end

    for _, pframe in pairs(MR_PARENTFRAMES) do
        if isMovable then
            if not pframe.baseFrame.isWatcher then
                pframe.baseFrame.movetex:SetColorTexture(0, 0, 1, .25)
                mRadial:ShowFrame(pframe.baseFrame.movetext, .25)
                pframe.baseFrame:EnableMouse(isMovable)
                pframe.baseFrame:SetMovable(isMovable)
                local srdFrm = pframe.ShardCounterFrame
                if srdFrm ~= nil then
                    if not InCombatLockdown() then 
                        pframe.ShardCounterFrame:EnableMouse(isMovable)
                    end
                    pframe.ShardCounterFrame:SetMovable(isMovable)
                end
                if pframe.baseFrame.isPetFrame then
                    mRadial:ShowFrame(pframe.baseFrame.readyText)
                    mRadial:ShowFrame(pframe.baseFrame.countText)
                    mRadial:ShowFrame(pframe.baseFrame.cooldownText)
                    mRadial:ShowFrame(pframe.baseFrame.debuffTimerText)
                    mRadial:ShowFrame(pframe.baseFrame.buffTimerText)
                    mRadial:ShowFrame(pframe.baseFrame.buffTimerTextBG)
                    pframe.baseFrame.buffTimerTextBG:SetColorTexture(0, .25, 0, 1)
                    pframe.baseFrame.buffTimerText:SetText("00")
                    pframe.baseFrame.countText:SetText("00")
                    pframe.baseFrame.cooldownText:SetText("00")
                    pframe.baseFrame.debuffTimerText:SetText("00")
                end
            else
                mRadial:ShowFrame(pframe.baseFrame.powerText)
                mRadial:ShowFrame(pframe.baseFrame.readyText)
                mRadial:ShowFrame(pframe.baseFrame.countText)
                mRadial:ShowFrame(pframe.baseFrame.cooldownText)
                mRadial:ShowFrame(pframe.baseFrame.debuffTimerText)
                mRadial:ShowFrame(pframe.baseFrame.buffTimerText)
                mRadial:ShowFrame(pframe.baseFrame.buffTimerTextBG)
                pframe.baseFrame.buffTimerTextBG:SetColorTexture(0, .25, 0, 1)
                pframe.baseFrame.buffTimerText:SetText("00")
                pframe.baseFrame.countText:SetText("00")
                pframe.baseFrame.cooldownText:SetText("00")
                pframe.baseFrame.debuffTimerText:SetText("00")
                pframe.baseFrame.powerText:SetText("00")
            end
        else
            if not pframe.baseFrame.isWatcher then
                pframe.baseFrame.movetex:SetColorTexture(0, 0, 1, 0)
                mRadial:HideFrame(pframe.baseFrame.movetext)
                if not InCombatLockdown() then 
                    pframe.baseFrame:EnableMouse(isMovable)
                end
                pframe.baseFrame:SetMovable(isMovable)
                if pframe.baseFrame.isPetFrame then
                    mRadial:HideFrame(pframe.baseFrame.readyText)
                    mRadial:HideFrame(pframe.baseFrame.countText)
                    mRadial:HideFrame(pframe.baseFrame.cooldownText)
                    mRadial:HideFrame(pframe.baseFrame.debuffTimerText)
                    mRadial:HideFrame(pframe.baseFrame.buffTimerText)
                    mRadial:HideFrame(pframe.baseFrame.buffTimerTextBG)
                end
            else
                mRadial:HideFrame(pframe.baseFrame.readyText)
                mRadial:HideFrame(pframe.baseFrame.powerText)
                mRadial:HideFrame(pframe.baseFrame.countText)
                mRadial:HideFrame(pframe.baseFrame.cooldownText)
                mRadial:HideFrame(pframe.baseFrame.debuffTimerText)
                mRadial:HideFrame(pframe.baseFrame.buffTimerText)
                mRadial:HideFrame(pframe.baseFrame.buffTimerTextBG)
            end
        end
    end
end

function mRadial:ForceUpdateAllMoveableFramePositions()
    for x=1, #MR_ALLFRAMES do
        local frame = MR_ALLFRAMES[x]
        if not frame.isWatcher then
            mRadial:RestoreFrame(frame:GetName(), frame, false)
        end
    end
    mRadial:UpdateUI(false)
    mRadial:setShardTrackerFramesSize()
    mRadial:setOOSShardFramesSize()
    mRadial:SetPetFramePosAndSize()
end

function mRadial:CopyFromSpec(specNum)
    local playerName = UnitName("player")
    local playerSpec = GetSpecialization()
    local srcFramePosData = PerPlayerPerSpecSavedVars[playerName][specNum]["framePositions"]
    local destFramePosData = PerPlayerPerSpecSavedVars[playerName][playerSpec]["framePositions"]

    local srcPetAbilitesToIgnore = PerPlayerPerSpecSavedVars[playerName][specNum]["hidePetAbilities"]
    PerPlayerPerSpecSavedVars[playerName][playerSpec]["hidePetAbilities"] = srcPetAbilitesToIgnore

    for frameName, framePositionData in pairs(srcFramePosData) do
        destFramePosData[frameName] = framePositionData
    end
    mRadial:ForceUpdateAllMoveableFramePositions()
end

function mRadial:RestoreFrame(frameName, frame, forceDefault, dx, dy)
    if forceDefault == nil then forceDefault = false end
    local playerName = UnitName("player")
    local playerSpec = GetSpecialization()
    local framePosData = PerPlayerPerSpecSavedVars[playerName][playerSpec]["framePositions"][frameName]
    
    if framePosData == nil or forceDefault then
        framePosData = {}
        local x = dx or 0
        local y = dy or 0
        framePosData["x"] = x
        framePosData["y"] = y
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
    MRadialSavedVariables.framePositions[frameName] = framePosData
end

function mRadial:WatcherExists(frameName)
    for x = 1, #MR_WATCHERFRAMES do
        local watcher = MR_WATCHERFRAMES[x]
        if watcher ~= nil and watcher.isWatcher and watcher:GetName() == frameName then
            return true
        end
    end
    return false
end

function mRadial:GetWatcher(frameName)
    for x = 1, #MR_WATCHERFRAMES do
        local watcher = MR_WATCHERFRAMES[x]
        if watcher ~= nil and watcher.isWatcher and watcher:GetName() == frameName then
            return watcher, x
        end
    end
    return nil, -1
end

function mRadial:GetFrameByName(frameName)
    for x = 1, #MR_ALLFRAMES do
        local frame = MR_ALLFRAMES[x]
        if frame ~= nil and frame:GetName() == frameName then
            return true, frame
        end
    end
    return false, nil
end
---------------------------------------------------------------------------------------------------
-- Spell watchers for timers/cooldowns.
local cdlast = 0
function mRadial:CreateWatcherFrame(spellID, parentFrame)
    -- Create the watcher frame
    -- If we have a parentSpell, this is cast and goes on cooldown, and the buff is the result 
    -- of casting. If we don't have a buff name, we're tracking the parent spell entirely.

    -- spellName, rank, iconPath, castTime, minRange, maxRange, spellID, originalSpellIcon = 
    local spellName, _, iconPath, _, minRange, maxRange, _, _ = GetSpellInfo(spellID)
    local frameName = string.format("Frame_%s", spellName)
    local watcher = mRadial:CreateRadialWatcherFrame(frameName, spellName, iconPath, parentFrame)
    watcher.spellName = spellName
    watcher.spellID = spellID
    watcher:GetParent().spellName = spellName
    ------------------------------------------
    -- SPELL INFORMATION TO USE FOR TIMERS ETC
    local costInfo = GetSpellPowerCost(spellID)
    local isUnitPowerDependant = false
    -- local powerTypeRequired = nil
    local powerMinCost = 0
    local powerType = 0
    if costInfo[1] == nil then 
        isUnitPowerDependant = false
    else 
        isUnitPowerDependant = true
        powerType = costInfo[1]["type"]
        -- powerTypeRequired = costInfo[1]["name"]
        powerMinCost = costInfo[1]["minCost"]
    end
    ----------------------------------------------
    -- Assign the spell to cast if we're a button!
    local asButtons = MRadialSavedVariables["asbuttons"] or MR_DEFAULT_ASBUTTONS
    if asButtons then
        watcher:SetAttribute("spell", spellName)
        -- set the button tooltip
        watcher:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
            GameTooltip:SetText("Cast ".. spellName)
            GameTooltip:SetSize(200, 40)
        end)
        watcher:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
    end
    
    watcher:SetScript("OnUpdate", function(self, elapsed)
        cdlast = cdlast + elapsed
        if cdlast <= MR_INTERVAL then return end

        if MAINFRAME_ISMOVING then return end
        
        if isUnitPowerDependant then
            -- Do we have enough shards to allow this to show timers / cast from?
            local power = UnitPower("player", powerType)
            local powerTextEnabled = MRadialSavedVariables["powerTextEnabled"]
            if powerTextEnabled == nil then powerTextEnabled = MR_DEFAULT_POWERENABLED end
            if power == 0 or power < powerMinCost and powerType ~= 0 then
                if powerTextEnabled then
                    watcher.powerText:SetText(tostring(power))
                    mRadial:ShowFrame(watcher.powerText, 1)
                else
                    watcher.powerText:SetText("")
                    mRadial:HideFrame(watcher.powerText)
                end
                watcher.readyText:SetText(NOPOWER)
                watcher.readyText:SetTextColor(1, 0, 0)
                watcher.cooldownText:SetText("")
                watcher.debuffTimerText:SetText("")
                mRadial:ShowFrame(watcher.readyText)
                mRadial:ShowFrame(watcher.movetex)
                watcher.movetex:SetColorTexture(MR_DEFAULT_NOPOWER[1], MR_DEFAULT_NOPOWER[2], MR_DEFAULT_NOPOWER[3], MR_DEFAULT_NOPOWER[4])
            else
                watcher.readyText:SetText(READYSTR)
                local powerPersists = MRadialSavedVariables["powerPersistsEnabled"]
                if powerPersists == nil then powerPersists = MR_DEFAULT_POWERPERSISTS end
                if powerTextEnabled and powerPersists and power >= powerMinCost and powerType ~= 0 then
                    watcher.powerText:SetText(tostring(power))
                    mRadial:ShowFrame(watcher.powerText, 1)
                else
                   watcher.powerText:SetText("")
                   mRadial:HideFrame(watcher.powerText)
                end
                mRadial:HideFrame(watcher.movetex)
                local readyColor = MRadialSavedVariables.readyColor or MR_DEFAULT_READYCOLOR
                watcher.readyText:SetTextColor(readyColor[1], readyColor[2], readyColor[3])
            end
        end
        
        mRadial:DoDebuffTimer(spellName, watcher, iconPath, isUnitPowerDependant)
        mRadial:DoSpellFrameCooldown(spellName, watcher, isUnitPowerDependant)

        local allLinkedSpells = MRadialSavedVariables["LINKEDSPELLS"] or LINKEDSPELLS
        local getLinked = allLinkedSpells[spellName] or nil
        
        local linkedSpellID
        local linkedSpellName
        local linkedIconPath

        if getLinked ~= nil then 
            linkedSpellName = getLinked[1] 
            linkedSpellID = getLinked[2]
            _, _, linkedIconPath, _, _, _, _, _ = GetSpellInfo(linkedSpellID)
            if linkedIconPath == nil then
                _, _, linkedIconPath, _, _, _, _, _ = GetSpellInfo(linkedSpellName)
            end
            mRadial:DoBuffTimer(linkedSpellName, watcher, linkedIconPath)
            
            local hideOOC = MRadialSavedVariables["hideooc"] or MR_DEFAULT_HIDEOOC
            if mRadial:HasActiveBuff(linkedSpellName) and not IsMounted() and not hideOOC then
                mRadial:ShowFrame(watcher.aura)
            else
                mRadial:HideFrame(watcher.aura)
            end
        else
            mRadial:DoBuffTimer(spellName, watcher, iconPath)
            mRadial:HideFrame(watcher.aura)
        end

        -- TOTEM WATCHING
        for slot = 1, 4 do
            local haveTotem, totemName, startTime, duration, icon = GetTotemInfo(slot)
            if haveTotem and totemName == spellName then
                mRadial:DoTotemTimer(watcher, startTime, duration, icon)
            end
        end

        -- Now set the count on the frame regardless.
        local count = 0
        if getLinked ~= nil then
            local linkedSpellName = getLinked[1] 
            local hasActiveBuff, scount = mRadial:HasActiveBuff(linkedSpellName)
            if hasActiveBuff then
                count = scount
            else
                local charges = GetSpellCharges(spellID)
                if count == 0 and charges then
                    count = charges
                end
            end
        else
            count = GetSpellCount(spellID) 
            local charges = GetSpellCharges(spellID)
            if count == 0 and charges then
                count = charges
            end
        end

        watcher.countText:SetText("")
        local hideOOC = MRadialSavedVariables["hideooc"] or MR_DEFAULT_HIDEOOC
        if count ~= 0 and not IsMounted() and not hideOOC then
            mRadial:ShowFrame(watcher.countText)
            watcher.countText:SetText(tostring(count))
            -- When we have a count for Summon Soulkeeper this spell can be marked as ready, 
            -- else we hide the ready for that spell.
            if spellName == SUMMONSOULKEEPER_SPELLNAME then
                mRadial:ShowFrame(watcher.readyText)
            end
        else
            if spellName == SUMMONSOULKEEPER_SPELLNAME then
                mRadial:HideFrame(watcher.readyText)
            end
        end

        local inRange = IsSpellInRange(spellName)
        if inRange ~= nil and inRange == 0 then
            watcher.iconFrame:SetAlpha(.2)
            watcher.readyText:SetText(OORTEXT)
        else
            watcher.iconFrame:SetAlpha(1)
        end
        cdlast = 0
    end)

    return watcher
end

function mRadial:CreateWatcherFrames()
    local activeTalentTreeSpells = mRadial:GetAllActiveTalentTreeSpells()
    if activeTalentTreeSpells == nil then
        return
    end

    -- hide all for spec changes.
    for _, frame in ipairs(MR_WATCHERFRAMES) do
        mRadial:HideFrame(frame)
        local pframe = frame:GetParent()
        if pframe ~= nil then
            mRadial:HideFrame(pframe)
        end
    end
    for _, spellInfo in ipairs(activeTalentTreeSpells) do
        local spellId = spellInfo[2]
        local spellName, _, _, _, _, _, spellID, _ = GetSpellInfo(spellId)
        local isActive = false
        local isSecondaryActive = false
        if spellName ~= nil then 
            isActive = MRadialSavedVariables["isActive"..spellName] or false
            isSecondaryActive = MRadialSavedVariables["isSecondaryActive"..spellName] or false
            local isKnown = IsPlayerSpell(spellId)
            local isPassive = IsPassiveSpell(spellID)
            local frameName = string.format("Frame_%s", spellName)
            -- if isActive and isKnown and not isPassive and not mRadial:WatcherExists(frameName) then
            if isActive and isKnown and not mRadial:WatcherExists(frameName) then
                local frame = mRadial:CreateWatcherFrame(spellID, MRadialPrimaryFrame)
                MR_WATCHERFRAMES[#MR_WATCHERFRAMES+1] = frame
                local pframe = frame:GetParent()
                if pframe ~= nil then
                    mRadial:HideFrame(pframe)
                end
                frame.isPrimary = true
                frame.isSecondary = false
                frame.isPassive = isPassive
                mRadial:HideFrame(frame)
            -- elseif isSecondaryActive and isKnown and not isPassive and not mRadial:WatcherExists(frameName) then
            elseif isSecondaryActive and isKnown and not mRadial:WatcherExists(frameName) then
                local frame = mRadial:CreateWatcherFrame(spellID, MRadialSecondaryFrame)
                MR_WATCHERFRAMES[#MR_WATCHERFRAMES+1] = frame
                local pframe = frame:GetParent()
                if pframe ~= nil then
                    mRadial:HideFrame(pframe)
                end
                frame.isPrimary = false
                frame.isSecondary = true
                mRadial:HideFrame(frame)
            elseif isKnown and mRadial:WatcherExists(frameName) then
                local frame, _ = mRadial:GetWatcher(frameName)
                if frame ~= nil then
                    local pframe = frame:GetParent()
                    if pframe ~= nil then
                        mRadial:HideFrame(pframe)
                    end
                    mRadial:HideFrame(frame)
                end
            end
        end
    end
end

---------------------------------------------------------------------------------------------------
function mRadial:CreateMainFrame()
    local radius = MRadialSavedVariables.radius or DEFAULT_RADIUS
    local ooShardsMult = MRadialSavedVariables.shardOutOfFrameSize or 150
    local size = radius*ooShardsMult
    local exists, frame = mRadial:GetFrameByName(MAINBG_FRAMENAME)
    local primary_exists, primaryFrame = mRadial:GetFrameByName(PRIMARY_FRAMENAME)
    local secondary_exists, secondaryFrame = mRadial:GetFrameByName(SECONDARY_FRAMENAME)
    -- Main Frame
    if not exists then
        local mask = ""
        if mRadial:IsWarlock() then
            mask = "Interface/Artifacts/Artifacts-PerkRing-Final-Mask"
        end
        MRadialMainFrame = mRadial:CreateMovableFrame(MAINBG_FRAMENAME,
                                                        {size, size},
                                                        UIParent,
                                                        "BackdropTemplate",
                                                        "Interface/Tooltips/UI-Tooltip-Background",
                                                        "ARTWORK",
                                                        mask,
                                                        false, {size, size}, {size, size}, false)
    else
        MRadialMainFrame = frame
    end
    if not primary_exists then
        MRadialPrimaryFrame = mRadial:CreateMovableFrame(PRIMARY_FRAMENAME,
                                                        {300, 200},
                                                        MRadialMainFrame,
                                                        "BackdropTemplate",
                                                        "Interface/Tooltips/UI-Tooltip-Background",
                                                        "ARTWORK",
                                                        "Interface/Artifacts/Artifacts-PerkRing-Final-Mask",
                                                        false, {size, size}, {size, size}, false)
    else
        MRadialPrimaryFrame = primaryFrame
    end
    if not secondary_exists then
        MRadialSecondaryFrame = mRadial:CreateMovableFrame(SECONDARY_FRAMENAME,
                                                        {300, 200},
                                                        MRadialMainFrame,
                                                        "BackdropTemplate",
                                                        "Interface/Tooltips/UI-Tooltip-Background",
                                                        "ARTWORK",
                                                        "Interface/Artifacts/Artifacts-PerkRing-Final-Mask",
                                                        false, {size, size}, {size, size}, false)
    else
        MRadialSecondaryFrame = secondaryFrame
    end

    -- Out of shards masks and textures are set on this base frame, so we scale this for the red out of shards indicator
    mRadial:setOOSShardFramesSize()

    -- Create an invisible crosshair indicator for when we are moving the UI
    MRadialMainFrame.crosshair = MRadialMainFrame:CreateTexture("crossHair")
    MRadialMainFrame.crosshair:SetPoint("CENTER", 0, 0)
    
    local crossHairPath = MEDIAPATH .."\\crosshair.blp"
    MRadialMainFrame.crosshair:SetTexture(crossHairPath)
    MRadialMainFrame.crosshair:SetSize(25, 25)
    mRadial:HideFrame(MRadialMainFrame.crosshair)
    local inLockdown = InCombatLockdown()
    if not inLockdown then
        MRadialMainFrame:Show()
    end
end
---------------------------------------------------------------------------------------------------
-- PET FRAMES
local plast = 0
function mRadial:CreatePetFrames()
    -- Clear out existing
    mRadial:HideAllPetFrames()
    local petAbilities = mRadial:GetPetAbilities()
    local x = -100
    for frameName, spellData in pairs(petAbilities) do
        local spellName = spellData["spellName"]
        local spellIconPath = spellData["spellIcon"]
        local ignoreFrameNames = MRadialSavedVariables["hidePetAbilities"] or ""
        local toIgnore = false
        for line in ignoreFrameNames:gmatch("[^\r\n]+") do
            if spellName == line then toIgnore = true break end
        end
        if MR_ALLFRAMES[frameName] == nil and mRadial:CheckHasSpell(spellName) and not toIgnore then
            local petFrameSize = MRadialSavedVariables.PetFramesSize 
            if petFrameSize == nil then petFrameSize = MR_DEFAULT_PET_FRAMESIZE end
            
            local fontPercentage = MRadialSavedVariables.FontPercentage
            if fontPercentage == nil then fontPercentage = MR_DEFAULT_FONTPERCENTAGE end

            local frame = mRadial:CreateMovableFrame(frameName,
                                                {petFrameSize, petFrameSize},
                                                UIParent,
                                                "",
                                                spellIconPath,
                                                "ARTWORK",
                                                nil,
                                                true, 
                                                {petFrameSize, petFrameSize}, {petFrameSize, petFrameSize},
                                                true)
            local customFontPath = MRadialSavedVariables['Font'] 
            if customFontPath == nil then customFontPath = MR_DEFAULT_FONT end
            frame.cooldownText:SetFont(customFontPath, petFrameSize*fontPercentage+2, "OUTLINE, MONOCHROME")
            frame.readyText:SetFont(customFontPath, petFrameSize*fontPercentage+2, "THICKOUTLINE")
            frame.isPetFrame = true
            -- Colors
            local readyColor = MRadialSavedVariables.readyColor
            if readyColor == nil then readyColor = MR_DEFAULT_READYCOLOR end
            local cdColor = MRadialSavedVariables.cdColor 
            if cdColor == nil then cdColor = MR_DEFAULT_CDCOLOR end
            local countColor = MRadialSavedVariables.countColor 
            if countColor == nil then countColor = MR_DEFAULT_COUNTCOLOR end
            frame.cooldownText:SetTextColor(cdColor[1], cdColor[2], cdColor[3])
            frame.readyText:SetTextColor(readyColor[1], readyColor[2], readyColor[3])
            frame.countText:SetTextColor(countColor[1], countColor[2], countColor[3])
            
            local playerName = UnitName("player")
            local playerSpec = GetSpecialization()
            local frameCache = PerPlayerPerSpecSavedVars[playerName][playerSpec]["framePositions"]
            if not mRadial:TableContainsKey(frameCache, frameName) then 
                mRadial:RestoreFrame(frameName, frame, true, x, -150)
            end

            frame:SetScript("OnUpdate", function(self, elapsed)
                plast = plast + elapsed
                if plast <= MR_INTERVAL then
                    return
                end
                if not MRadialSavedVariables['hidePetFrame'] then
                    mRadial:ShowFrame(frame, 1)
                end
                mRadial:DoSpellFrameCooldown(spellName, frame)
                mRadial:DoPetFrameAuraTimer(spellName, frame)
                plast = 0
                if UnitGUID("pet") == nil then
                    mRadial:HideAllPetFrames()
                end
            end)
            MR_PETFAMES[#MR_PETFAMES+1] = frame
            MR_ALLFRAMES[frameName] = frame
            x = x + (5+petFrameSize)
        elseif MR_ALLFRAMES[frameName] and mRadial:CheckHasSpell(spellName) then
            local frame = MR_ALLFRAMES[frameName]
            mRadial:ShowFrame(frame, 1)
            if not InCombatLockdown() then
                frame:Show()
            end
        end

    end
end

function mRadial:TogglePetFrameVisibility()
    local isVisible = MRadialSavedVariables["hidePetFrame"] or false
    for _, frame in pairs(MR_ALLFRAMES) do
        if frame.isPetFrame and isVisible then
            mRadial:HideFrame(frame)
        elseif frame.isPetFrame and not isVisible then
            mRadial:ShowFrame(frame)
        end
    end
end

function mRadial:HideAllPetFrames()
    for _, frame in pairs(MR_PETFAMES) do
        if frame.isPetFrame then
            mRadial:HideFrame(frame)
            if not InCombatLockdown() then frame:Hide() end
        end
    end
end

function mRadial:SetPetFramePosAndSize()
    local petFrameSize = MRadialSavedVariables["PetFramesSize"] or 45
    local fontPercentage = MRadialSavedVariables.FontPercentage or .5
    local customFontPath = MRadialSavedVariables['Font'] or MR_DEFAULT_FONT

    for _, frame in ipairs(MR_ALLFRAMES) do
        if frame.isPetFrame then
            mRadial:RestoreFrame(frame:GetName(), frame)
            frame:SetSize(petFrameSize, petFrameSize)
            local pet_readyColor = MRadialSavedVariables.pet_readyColor or MR_DEFAULT_READYCOLOR
            local pet_countColor = MRadialSavedVariables.pet_countColor or MR_DEFAULT_COUNTCOLOR
            local pet_cdColor = MRadialSavedVariables.pet_cdColor or MR_DEFAULT_CDCOLOR
            
            local pet_readyFontSize = MRadialSavedVariables.pet_readyFontSize or MR_DEFAULT_PET_FONTSIZE
            local pet_countFontSize = MRadialSavedVariables.pet_countFontSize or MR_DEFAULT_PET_FONTSIZE
            local pet_coolDownFontSize = MRadialSavedVariables.pet_coolDownFontSize or MR_DEFAULT_PET_FONTSIZE

            local pet_readyUDOffset = MRadialSavedVariables.pet_readyUDOffset or MR_DEFAULT_READYUDOFFSET
            local pet_readyLROffset = MRadialSavedVariables.pet_readyLROffset or MR_DEFAULT_READYLROFFSET
            local pet_countUdOffset = MRadialSavedVariables.pet_countUdOffset or MR_DEFAULT_COUNTUDOFFSET
            local pet_countLROffset = MRadialSavedVariables.pet_countLROffset or MR_DEFAULT_COUNTLROFFSET
            local pet_cdUdOffset = MRadialSavedVariables.pet_cdUdOffset or MR_DEFAULT_CDUDOFFSET
            local pet_cdLROffset = MRadialSavedVariables.pet_cdLROffset or MR_DEFAULT_CDLROFFSET

            frame.readyText:SetFont(customFontPath, petFrameSize*fontPercentage+pet_readyFontSize, "THICKOUTLINE")
            frame.countText:SetFont(customFontPath, petFrameSize*fontPercentage+pet_countFontSize, "THICKOUTLINE")
            frame.cooldownText:SetFont(customFontPath, petFrameSize*fontPercentage+pet_coolDownFontSize, "OUTLINE, MONOCHROME")
            
            frame.readyText:SetPoint("CENTER", frame.iconFrame, "CENTER", pet_readyLROffset, pet_readyUDOffset)
            frame.readyText:SetTextColor(pet_readyColor[1], pet_readyColor[2], pet_readyColor[3])
            frame.countText:SetPoint("CENTER", frame.iconFrame, "CENTER", pet_countLROffset, pet_countUdOffset)
            frame.countText:SetTextColor(pet_countColor[1], pet_countColor[2], pet_countColor[3])
            frame.cooldownText:SetPoint("CENTER", frame.iconFrame, "CENTER", pet_cdLROffset, pet_cdUdOffset)
            frame.cooldownText:SetTextColor(pet_cdColor[1], pet_cdColor[2], pet_cdColor[3])
        end
    end
end

function mRadial:HideAllWatcherFrames()
    for x=1, #MR_WATCHERFRAMES do
        -- First we hide any and all watchers that may have been active.
        local watcher = MR_WATCHERFRAMES[x]
        mRadial:HideFrame(watcher)
        if not InCombatLockdown then
            watcher:GetParent():Hide()
        end
    end
end

---------------------------------------------------------------------------------------------------
-- Watcher radial layout.
function mRadial:RadialButtonLayout(orderedWatchers, r, o, sprd, wd, hd, parentFrame)
    -- This function handles adding the frames around a unit circle cause I like it better this way....
    -- orderedWatchers (table): ordered set of watchers.
    local customFontPath =  MRadialSavedVariables['Font']
    if customFontPath == nil then customFontPath = MR_DEFAULT_FONT end
    local fontPercentage = MRadialSavedVariables.FontPercentage 
    if fontPercentage == nil then fontPercentage = MR_DEFAULT_FONTPERCENTAGE end
    local radiusMult = MRadialSavedVariables.radiusMult
    if radiusMult == nil then radiusMult = MR_DEFAULT_RADIUSMULT end
    local radius = r * radiusMult
    local offset = o
    local spread = sprd  -- -2.94  -- -5.0
    local widthDeform = wd
    local heightDeform = hd

    local readyColor = MRadialSavedVariables.readyColor
    if readyColor == nil then readyColor = MR_DEFAULT_READYCOLOR end

    local countColor = MRadialSavedVariables.countColor
    if countColor == nil then countColor = MR_DEFAULT_COUNTCOLOR end
    
    local cdColor = MRadialSavedVariables.cdColor
    if cdColor == nil then cdColor = MR_DEFAULT_CDCOLOR end

    local buffColor = MRadialSavedVariables.buffColor
    if buffColor == nil then buffColor = MR_DEFAULT_BUFFCOLOR end

    local debuffColor = MRadialSavedVariables.debuffColor
    if debuffColor == nil then debuffColor = MR_DEFAULT_DEBUFFCOLOR end

    local powerColor = MRadialSavedVariables.powerColor
    if powerColor == nil then powerColor = MR_DEFAULT_POWERCOLOR end

    local countFontSize = MRadialSavedVariables.countFontSize
    if countFontSize == nil then countFontSize = MR_DEFAULT_FONTSIZE end
    
    local readyFontSize = MRadialSavedVariables.readyFontSize
    if readyFontSize == nil then readyFontSize = MR_DEFAULT_FONTSIZE end

    local coolDownFontSize = MRadialSavedVariables.coolDownFontSize
    if coolDownFontSize == nil then coolDownFontSize = MR_DEFAULT_FONTSIZE end

    local timerFontSize = MRadialSavedVariables.timerFontSize
    if timerFontSize == nil then timerFontSize = MR_DEFAULT_FONTSIZE end

    local debuffFontSize = MRadialSavedVariables.debuffFontSize
    if debuffFontSize == nil then debuffFontSize = MR_DEFAULT_FONTSIZE end

    local powerFontSize = MRadialSavedVariables.powerFontSize
    if powerFontSize == nil then powerFontSize = MR_DEFAULT_FONTSIZE end


    local radialUdOffset = MRadialSavedVariables.radialUdOffset
    local radialLROffset = MRadialSavedVariables.radialLROffset
    if radialUdOffset == nil then radialUdOffset = MR_DEFAULT_UDOFFSET end
    if radialLROffset == nil then radialLROffset = MR_DEFAULT_LROFFSET end

    local cdUdOffset = MRadialSavedVariables.cdUdOffset
    local cdLROffset = MRadialSavedVariables.cdLROffset 
    if cdUdOffset == nil then cdUdOffset = MR_DEFAULT_CDUDOFFSET end
    if cdLROffset == nil then cdLROffset = MR_DEFAULT_CDLROFFSET end

    local countUdOffset = MRadialSavedVariables.countUdOffset
    local countLROffset = MRadialSavedVariables.countLROffset
    if countUdOffset == nil then countUdOffset = MR_DEFAULT_COUNTUDOFFSET end
    if countLROffset == nil then countLROffset = MR_DEFAULT_COUNTLROFFSET end

    
    local readyUDOffset = MRadialSavedVariables.readyUDOffset
    local readyLROffset = MRadialSavedVariables.readyLROffset
    if readyUDOffset == nil then readyUDOffset = MR_DEFAULT_READYUDOFFSET end
    if readyLROffset == nil then readyLROffset = MR_DEFAULT_READYLROFFSET end

    local debuffUDOffset = MRadialSavedVariables.debuffUdOffset
    local debuffLROffset = MRadialSavedVariables.debuffLROffset
    if debuffUDOffset == nil then debuffUDOffset = MR_DEFAULT_DEBUFFUDOFFSET end
    if debuffLROffset == nil then debuffLROffset = MR_DEFAULT_DEBUFFLROFFSET end

    local powerUDOffset = MRadialSavedVariables.powerUdOffset
    local powerLROffset = MRadialSavedVariables.powerLROffset
    if powerUDOffset == nil then powerUDOffset = MR_DEFAULT_POWERUDOFFSET end
    if powerLROffset == nil then powerLROffset = MR_DEFAULT_POWERLROFFSET end

    local watcherFrameSize = MRadialSavedVariables.watcherFrameSize
    if watcherFrameSize == nil then watcherFrameSize = MR_DEFAULT_WATCHERFRAMESIZE end

    local angleStep = (math.pi / #orderedWatchers) + spread*.1
    local autoSpread =  MRadialSavedVariables['autoSpread'] 
    if autoSpread == nil then autoSpread = MR_DEFAULT_AUTOSPREAD end
    if autoSpread then
        angleStep = (((watcherFrameSize+8)/(radius * (math.pi/180))) * (math.pi/180)) + spread *.1 
    end
    
    if orderedWatchers == nil then
        orderedWatchers = mRadial:UpdateActiveSpells()
    end
    for x, watcher in ipairs(orderedWatchers) do
        if watcher ~= nil and watcher.isWatcher then
            mRadial:ShowFrame(watcher)
            mRadial:ShowFrame(watcher:GetParent())

            local angle = ((x-1)*angleStep) + (offset*math.pi) 
            local sinAng = math.sin(angle)
            local cosAng = math.cos(angle)
            local w = (cosAng*radius)*widthDeform
            local h = (sinAng*radius)*heightDeform

            -- BASE COLORS
            watcher.readyText:SetTextColor(readyColor[1], readyColor[2], readyColor[3])
            watcher.countText:SetTextColor(countColor[1], countColor[2], countColor[3])
            watcher.cooldownText:SetTextColor(cdColor[1], cdColor[2], cdColor[3])
            watcher.buffTimerText:SetTextColor(buffColor[1], buffColor[2], buffColor[3])
            watcher.debuffTimerText:SetTextColor(debuffColor[1], debuffColor[2], debuffColor[3])
            watcher.powerText:SetTextColor(powerColor[1], powerColor[2], powerColor[3])
            
            watcher:SetSize(watcherFrameSize, watcherFrameSize)
            -- Expand the iconFrame a little so we don't get strange squares in the circles.
            watcher.iconFrame:SetSize(watcherFrameSize*1.2, watcherFrameSize*1.2)
            -- Because the graphic for the border is a little smaller.. we wanna handle the scale now too
            watcher.borderFrame:SetSize(watcherFrameSize*1.6, watcherFrameSize*1.6)
            watcher.aura:SetSize(watcherFrameSize*3, watcherFrameSize*3)
            watcher.mask:SetSize(watcherFrameSize, watcherFrameSize)
            watcher.buffTimerTextBG:SetSize(watcherFrameSize/1.2, watcherFrameSize/1.5)
            
            -- TEXT
            watcher.cooldownText:SetPoint("CENTER", watcher.iconFrame, "CENTER", cdLROffset, cdUdOffset)
            watcher.countText:SetPoint("CENTER", watcher.iconFrame, "CENTER", countLROffset, countUdOffset)
            watcher.readyText:SetPoint("CENTER", watcher.iconFrame, "CENTER", readyLROffset, readyUDOffset)
            watcher.debuffTimerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", debuffLROffset, debuffUDOffset)
            watcher.powerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", powerLROffset, powerUDOffset)
            
            -- SET FONT
            watcher.buffTimerText:SetFont(customFontPath,  (watcherFrameSize*fontPercentage)+timerFontSize, "OUTLINE, MONOCHROME")
            watcher.debuffTimerText:SetFont(customFontPath,  (watcherFrameSize*fontPercentage)+debuffFontSize, "OUTLINE, MONOCHROME")
            watcher.countText:SetFont(customFontPath,  (watcherFrameSize*fontPercentage)+countFontSize, "THICKOUTLINE")
            watcher.cooldownText:SetFont(customFontPath,  (watcherFrameSize*fontPercentage)+coolDownFontSize, "THICKOUTLINE")
            watcher.readyText:SetFont(customFontPath, (watcherFrameSize*fontPercentage)+readyFontSize, "THICKOUTLINE")
            watcher.powerText:SetFont(customFontPath, (watcherFrameSize*fontPercentage)+powerFontSize, "THICKOUTLINE")
            
            -- Move the watcher around the center of the frame
            watcher:SetPoint("CENTER", parentFrame, "CENTER", w, h)
            
            -- We don't do ANY SHOW HIDE HERE!!
            watcher.buffTimerText:SetPoint("CENTER", watcher.buffTimerTextBG, "CENTER", 0, 0)
            
            if cosAng >= - 0.1 and cosAng <= 0.1 then
                -- Bottom of the circle, we want to keep the text UNDER the icon here
                local centerBelow =  MRadialSavedVariables["centerBelow"]
                if centerBelow == nil then centerBelow = MR_DEFAULT_CENTERBELOW end
                if centerBelow then
                    watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, readyUDOffset - watcherFrameSize/1.5)-- - watcherFrameSize/2)
                    watcher.debuffTimerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", debuffLROffset, debuffUDOffset)-- - watcherFrameSize/2)
                else
                    watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, readyUDOffset + watcherFrameSize+10)-- - watcherFrameSize/2)
                    watcher.debuffTimerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, readyUDOffset + watcherFrameSize+10)-- - watcherFrameSize/2)
                end
                watcher.readyText:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, readyUDOffset)
            elseif cosAng <= -0.1 then
                watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "LEFT", radialLROffset, radialUdOffset)
                watcher.debuffTimerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", debuffLROffset, debuffUDOffset)
                watcher.countText:SetPoint("CENTER", watcher.iconFrame, "CENTER", countLROffset, countUdOffset)
                watcher.cooldownText:SetPoint("CENTER", watcher.iconFrame, "CENTER", cdLROffset*cosAng, cdUdOffset)
                watcher.readyText:SetPoint("CENTER", watcher.iconFrame, "CENTER", readyLROffset*cosAng, readyUDOffset)
                watcher.powerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", powerLROffset, powerUDOffset)
            elseif  cosAng >= 0.1 then
                watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "RIGHT", -radialLROffset, radialUdOffset)
                watcher.debuffTimerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", -debuffLROffset, debuffUDOffset)
                watcher.countText:SetPoint("CENTER", watcher.iconFrame, "CENTER", -countLROffset, countUdOffset)
                watcher.cooldownText:SetPoint("CENTER", watcher.iconFrame, "CENTER", cdLROffset*cosAng, cdUdOffset)
                watcher.readyText:SetPoint("CENTER", watcher.iconFrame, "CENTER", readyLROffset*cosAng, readyUDOffset)
                watcher.powerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", -powerLROffset, powerUDOffset)
            end
        end
    end
end

---------------------------------------------------------------------------------------------------
-- SOME UTIL STUFF
function mRadial:ShowFrame(frame, alpha) 
    local spellName = frame.spellName
    if spellName ~= nil then
        local isActive = MRadialSavedVariables["isActive".. frame.spellName] or false
        local isSecondaryActive = MRadialSavedVariables["isSecondaryActive".. frame.spellName] or false
        if not isActive and not isSecondaryActive then
            return
        end
        local hideSecondary = MRadialSavedVariables["hideSecondary"] or MR_DEFAULT_HIDESECONDARY
        if hideSecondary and frame.isSecondary then
            return
        end
    end

    if frame.isParentFrame then
        local childFrames = {}
        childFrames[1] = frame.iconFrame
        childFrames[2] = frame.borderFrame
        childFrames[3] = frame.countText
        childFrames[4] = frame.buffTimerTextBG
        childFrames[5] = frame.buffTimerText
        childFrames[6] = frame.debuffTimerTextBG
        childFrames[7] = frame.debuffTimerTextBG
        childFrames[8] = frame.cooldownText
        childFrames[9] = frame.readyText
        childFrames[10] = frame.mask
        childFrames[11] = frame.aura
        
        for _, frame in ipairs(childFrames) do
            if frame ~= nil then
                if alpha == nil then
                    frame:SetAlpha(1)
                else
                    frame:SetAlpha(alpha)
                end
            end
        end
        if frame.borderFrame ~= nil then
            frame.borderFrame:SetAlpha(0)
        end
    else
        if alpha == nil then
            frame:SetAlpha(1)
        else
            frame:SetAlpha(alpha)
        end
        if frame.borderFrame ~= nil then
            frame.borderFrame:SetAlpha(0.5)
        end
    end
end

function mRadial:HideFrame(frame)
    if frame.isParentFrame then
        local childFrames = {}
        childFrames[1] = frame.iconFrame
        childFrames[2] = frame.borderFrame
        childFrames[3] = frame.countText
        childFrames[4] = frame.buffTimerTextBG
        childFrames[5] = frame.buffTimerText
        childFrames[6] = frame.debuffTimerTextBG
        childFrames[7] = frame.debuffTimerTextBG
        childFrames[8] = frame.cooldownText
        childFrames[9] = frame.readyText
        childFrames[10] = frame.mask
        childFrames[11] = frame.aura
        for _, frame in ipairs(childFrames) do
            if frame ~= nil then
                frame:SetAlpha(0)
            end
        end
    else
        frame:SetAlpha(0)   
    end
end

function mRadial:UpdateActivePrimarySpells()
    -- Flush existing
    ACTIVEPRIMARYWATCHERS = {}
    mRadial:HideAllWatcherFrames()
    for x=1, #MR_WATCHERFRAMES   do
        -- -- Now we check for isActive (options toggles)
        local watcher = MR_WATCHERFRAMES[x]
        local isActive = MRadialSavedVariables["isActive".. watcher.spellName] or false
        if isActive then 
            ACTIVEPRIMARYWATCHERS[#ACTIVEPRIMARYWATCHERS+1] = watcher
            mRadial:ShowFrame(watcher)
            if not InCombatLockdown then
                watcher:GetParent():Show()
            end
        end
    end
    return ACTIVEPRIMARYWATCHERS
end

function mRadial:UpdateActiveSecondarySpells()
    -- Flush existing
    ACTIVESECONDARYWATCHERS = {}
    local hideSecondary = MRadialSavedVariables["hideSecondary"] 
    if hideSecondary == nil then hideSecondary = MR_DEFAULT_HIDESECONDARY end
    if hideSecondary then
        return
    end
    for x=1, #MR_WATCHERFRAMES do
        -- First we hide any and all watchers that may have been active.
        local watcher = MR_WATCHERFRAMES[x]
        local isActive = MRadialSavedVariables["isActive".. watcher.spellName] or false
        local isSecondaryActive = MRadialSavedVariables["isSecondaryActive".. watcher.spellName] or false
        -- Now we check for isActive (options toggles)
        if isSecondaryActive and not isActive then 
            ACTIVESECONDARYWATCHERS[#ACTIVESECONDARYWATCHERS+1] = watcher 
            mRadial:ShowFrame(watcher)
            if not InCombatLockdown then
                watcher:Show()
            end
        end
    end
    return ACTIVESECONDARYWATCHERS
end