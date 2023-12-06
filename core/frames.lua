local appName = "mRadial"
local L = LibStub("AceLocale-3.0"):GetLocale(appName, false) or nil
local mRadial = mRadial
---------------------------------------------------------------------------------------
-- Create an Icon frame.
-- This function sets up the necessary elements for any frame with a texture in the UI.
--
-- Properties of:
    -- parentFrame.frame
    -- parentFrame.spellName    # Default ""
    -- frame.spellName          # Default ""
    -- frame.spellID            # Default ""
    -- frame.iconPath
    -- frame.maskPath
    -- frame.specialTexture01
    -- frame.configText 
    -- frame.isWatcher          # Default false
function mRadial:CreateIconFrame(frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize, asbutton)
    if template == nil then template = MR_DEFAULT_TEMPLATE end
    local sizeX = frameSize[1]
    local sizeY = frameSize[2]
    
    -- PARENT FRAME (Should be visible at all times for update scripts to fire.)
    local parentName = frameName .."_parent"
    local curParentFrame = mRadial:GetFrame(parentName)
    local parentFrame
    if curParentFrame == nil then
        parentFrame = CreateFrame("Frame", parentName, parent, MR_DEFAULT_TEMPLATE)
    else
        parentFrame = curParentFrame
    end
    parentFrame.isParentFrame = true
    parentFrame:SetFrameStrata(LOW)
    parentFrame:SetFrameLevel(5)
    parentFrame:SetMovable(false)
    parentFrame:EnableMouse(false)
    
    -- Main Icon Frame now.
    local frame
    local curFrame = mRadial:GetFrame(frameName)
    if asbutton == nil then 
        asbutton = MRadialSavedVariables["asbuttons"] or MR_DEFAULT_ASBUTTONS
    end

    if curFrame == nil then
        if asbutton then
            frame = CreateFrame("Button", frameName, parentFrame, "SecureActionButtonTemplate")  
            frame:SetEnabled(true)
            parentFrame:EnableMouse(true)
            frame:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
        else
            frame = CreateFrame("Frame", frameName, parentFrame, template)        
        end
    else
        frame = curFrame
    end
    -- Attrs for button clicks
    frame:SetAttribute("type", "spell")
    frame:SetAttribute("name", spellName)
    
    frame:SetParent(parentFrame)
    frame:SetFrameStrata(LOW)
    frame:SetFrameLevel(10)
    frame:SetPoint("CENTER", parent, "CENTER", 0, 0)
    frame:RegisterForDrag("LeftButton")
    if not InCombatLockdown() then
        frame:SetSize(sizeX, sizeY)
    end
    frame:SetMovable(false)
    frame:EnableMouse(false)

    -- TEXTURE
    frame.iconFrame = frame:CreateTexture("texture_" .. frameName, strata)
    frame.iconFrame:SetPoint("CENTER", 0, 0)
    if texturePath ~= nil then
        frame.iconFrame:SetTexture(texturePath)
        frame.iconPath = texturePath
    end
    -- MASK
    frame.mask = frame:CreateMaskTexture("mask_" .. frameName)
    frame.mask:SetPoint("CENTER", 0, 0)
    if maskPath ~= nil then
        frame.mask:SetTexture(maskPath, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        frame.iconFrame:AddMaskTexture(frame.mask)
        frame.maskPath = maskPath
    end

    -------------------------------------------------
    -- Special Texture
    frame.specialTexture01 = frame:CreateTexture(nil, "OVERLAY")
    frame.specialTexture01:SetPoint("CENTER", 0, 0)
    frame.specialTexture01:SetAllPoints(frame)
    frame.specialTexture01:SetColorTexture(0, 0, 0, 0)
    
    frame.configText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.configText:SetTextColor(1, 1, 1, 0)
    frame.configText:SetPoint("CENTER", frame.iconFrame, "TOP", 0, 0)
    frame.configText:SetText(frame:GetName())
    if maskPath ~= nil then
        frame.specialTexture01:AddMaskTexture(frame.mask)
    end
    mRadial:HideFrame(frame.configText)

    if not InCombatLockdown() then
        if allPoints ~= nil then
            frame.iconFrame:SetAllPoints(frame)
            if frame.mask ~= nil then
                frame.mask:SetAllPoints(frame.iconFrame)
            end
        else
            if textureSize ~= nil then
                local texSizeX, texSizeY = textureSize, textureSize
                frame.iconFrame:SetSize(texSizeX, texSizeY)
            end
            if frame.mask ~= nil and maskSize ~= nil then
                local maskSizeX, maskSizeY = maskSize, maskSize
                frame.mask:SetSize(maskSizeX, maskSizeY)
            end
        end
    end

    -- SET PROPERTIES UP
    parentFrame.frame = frame
    parentFrame.spellName = ""
    parentFrame.timerTextElements = {}
    parentFrame.timerTextBGElements = {}
    frame.spellName = ""
    frame.spellID = -1
    frame.isWatcher = false
    frame.isShardFrame = false
    frame.isImpFrame = false
    frame.isMovable = false
    frame.isPetFrame = false
    
    -- Handle all frames vanishing when mounted.
    mRadial:SetMountedFrameScripts(frame)

    -- Add to the main frames table.
    MR_PARENTFRAMES[#MR_PARENTFRAMES+1] = parentFrame
    MR_ALLFRAMES[#MR_ALLFRAMES+1] = frame
    return frame
end

----------------------------------------------------------------------------------------------
-- Create all timer elements for the given frame.
-- This function sets up the necessary elements for a timer display within the provided frame.
--
-- Parameters:
--   frame (table): The frame to which the timer elements will be added.
function mRadial:CreateFrameTimerElements(frame)
    -- COUNT
    frame.countText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    -- COOLDOWN
    frame.cooldownText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    -- LINKED
    frame.linkedTimerTextBG = frame:CreateTexture(nil, "BACKGROUND")
    frame.linkedTimerText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    -- DEBUFF
    frame.deBuffTimerTextBG = frame:CreateTexture(nil, "BACKGROUND")
    frame.deBuffTimerText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    -- READY
    frame.readyText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    -- POWER
    frame.powerText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    
    local timerTextElements = {}
          timerTextElements[1] = frame.countText
          timerTextElements[2] = frame.linkedTimerText
          timerTextElements[3] = frame.deBuffTimerText
          timerTextElements[4] = frame.cooldownText
          timerTextElements[5] = frame.readyText
          timerTextElements[6] = frame.powerText
    
    local timerTextBGElements = {}
          timerTextBGElements[1] = frame.linkedTimerTextBG
          timerTextBGElements[2] = frame.deBuffTimerTextBG
    
    frame:GetParent().timerTextElements = timerTextElements
    frame:GetParent().timerBGElements = timerTextBGElements
end

--------------------------------------------------------------------------
-- Creates a moveable icon frame to be used by mRadial:SetMoveFrameScripts
--
function mRadial:CreateMovableFrame(frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize, asTimer)
    local frame = mRadial:GetFrame(frameName)
    if frame == nil then 
        -- frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize, asbutton
        frame = mRadial:CreateIconFrame(frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize)
    end

    frame.isMovable = true

    -- Petframes have timers, lets build those now.
    if asTimer then mRadial:CreateFrameTimerElements(frame) end
    
    -- And set the scripts up for moving these frames.
    mRadial:SetMoveFrameScripts(frame)

    -- Now put it all back to where it was previously set by the user if these exist.
    mRadial:RestoreFrame(frameName, frame)
    return frame
end

-----------------------------------------------------------------------------------------------------------
-- Timer frame, that is part of the radial menu that doesn't get moved when the UI is set to movable state.
--
function mRadial:CreateRadialWatcherFrame(frameName, spellName, iconPath, parentFrame)
    local asButtons = MRadialSavedVariables[MR_KEY_ASBUTTONS]
    if asButtons == nil then asButtons = MR_DEFAULT_ASBUTTONS end
    
    -- frameName, frameSize, parent, template, texturePath, strata, maskPath, allPoints, textureSize, maskSize, asbutton
    local watcher = mRadial:CreateIconFrame(frameName, 
                                            {MR_DEFAULT_ICONSIZE, MR_DEFAULT_ICONSIZE}, 
                                            parentFrame, 
                                            MR_DEFAULT_TEMPLATE, 
                                            iconPath, 
                                            "ARTWORK", 
                                            "Interface/CHARACTERFRAME/TempPortraitAlphaMask", 
                                            nil, 
                                            MR_DEFAULT_ICONSIZE, 
                                            MR_DEFAULT_ICONSIZE, 
                                            asButtons)
    -- special tag for helping determine this is a raidal button.
    watcher.isWatcher = true
    mRadial:CreateFrameTimerElements(watcher)
    
    function createBorder(watcher)
        -- Assign a nice littler border!
        watcher.borderFrame = watcher:CreateTexture(nil, "ARTWORK")
        watcher.borderFrame:SetPoint("CENTER", watcher, "CENTER") -- allows scaling.
        watcher.borderFrame:SetTexture("Interface/ARTIFACTS/Artifacts-PerkRing-Final-Mask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        watcher.borderFrame:SetAlpha(MR_DEFAULT_BORDERALPHA)
        
        watcher.aura = watcher:CreateTexture(nil, "OVERLAY")
        watcher.aura:SetPoint("CENTER", 0, 0)
        watcher.aura:SetTexture("Interface/COMMON/portrait-ring-withbg-highlight", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mRadial:HideFrame(watcher.aura)
    end
    createBorder(watcher)

    return watcher
end

---------------------------------------------------------------------------------------------------
-- Spell watchers for timers/cooldowns.

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
    local isUnitPowerDependant, powerType, powerMinCost = mRadial:IsPowerDependant(spellID)
    ----------------------------------------------
    -- Assign the spell to cast if we're a button!
    local asButtons = MRadialSavedVariables[MR_KEY_ASBUTTONS]
    if asButtons then
        watcher:SetAttribute("spell", spellName)
        -- set the button tooltip
        watcher:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
            GameTooltip:SetText("Cast " .. spellName .. " | " ..  spellID)
            GameTooltip:SetSize(200, 40)
        end)
        watcher:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
    end

    local allLinkedSpells = MRadialSavedVariables["LINKEDSPELLS"] or LINKEDSPELLS
    local linkedSpell = allLinkedSpells[spellName] or nil

    mRadial:SetWatcherScripts(watcher, spellName, isUnitPowerDependant, powerType, powerMinCost, linkedSpell)
    return watcher
end

function mRadial:CreateWatcherFrames()
    local activeTalentTreeSpells = mRadial:GetAllActiveTalentTreeSpells()
    if activeTalentTreeSpells == nil then
        return
    end

    -- Hide all for Spec changes!
    for _, frame in ipairs(MR_WATCHERFRAMES) do
        mRadial:HideFrame(frame)
        local pframe = frame:GetParent()
        if pframe ~= nil then
            mRadial:HideFrame(pframe)
        end
    end
    
    local spellBookSpells = {}
    local spellsInBook = mRadial:GetAllSpells(spellBookSpells)
    for _, spellInfo in ipairs(activeTalentTreeSpells) do
        local spellId = spellInfo[2]
        local spellName, _, _, _, _, _, spellID, _ = GetSpellInfo(spellId)
        local isActive = false
        local isSecondaryActive = false
        if spellName ~= nil then 
            isActive = MRadialSavedVariables["isActive"..spellName] or false
            isSecondaryActive = MRadialSavedVariables["isSecondaryActive"..spellName] or false
            local isKnown = IsPlayerSpell(spellId, true)
            if not isKnown then
                isKnown = mRadial:TableContains(spellBookSpells, {spellName, spellID})
            end

            local isPassive = IsPassiveSpell(spellID)
            local frameName = string.format("Frame_%s", spellName)
            if isActive and isKnown and not mRadial:WatcherExists(frameName) then
                local frame = mRadial:CreateWatcherFrame(spellID, MRadialPrimaryFrame)
                MR_WATCHERFRAMES[#MR_WATCHERFRAMES+1] = frame
                local pframe = frame:GetParent()
                frame.isPrimary = isActive
                frame.isSecondary = isSecondaryActive
                frame.isPassive = isPassive
                mRadial:HideFrame(frame)
            elseif isSecondaryActive and isKnown and not mRadial:WatcherExists(frameName) then
                local frame = mRadial:CreateWatcherFrame(spellID, MRadialSecondaryFrame)
                MR_WATCHERFRAMES[#MR_WATCHERFRAMES+1] = frame
                local pframe = frame:GetParent()
                frame.isPrimary = isActive
                frame.isSecondary = isSecondaryActive
                mRadial:HideFrame(frame)
            elseif isKnown and mRadial:WatcherExists(frameName) then
                local frame, _ = mRadial:GetWatcher(frameName)
                if frame ~= nil then
                    local pframe = frame:GetParent()
                    mRadial:HideFrame(frame)
                end
            end
        end
    end
    
end

---------------------------------------------------------------------------------------------------
function mRadial:CreateMainFrame()
    local radius = MRadialSavedVariables.radius or DEFAULT_RADIUS
    local ooShardsMult = MRadialSavedVariables.shardOutOfFrameSize or MR_DEFAULT_OOS_FS
    local size = radius*ooShardsMult
    local exists, frame = mRadial:GetFrameByName(MAINBG_FRAMENAME)
    local primary_exists, primaryFrame = mRadial:GetFrameByName(PRIMARY_FRAMENAME)
    local secondary_exists, secondaryFrame = mRadial:GetFrameByName(SECONDARY_FRAMENAME)
    local hideOOfShardFrame = MRadialSavedVariables["hideOOShardFrame"]
    if hideOOfShardFrame == nil then hideOOfShardFrame = MR_DEFAULT_HIDE_OOSF end
    -- Main Frame
    if not exists then
        local mask = ""
        if mRadial:IsWarlock() and not hideOOS then
            mask = MR_DEFAULT_RADIAL_MASK
        end
        -- frameName, frameSize, parent, template, texturePath, strata, maskPath, 
        -- allPoints, textureSize, maskSize, asTimer
        MRadialMainFrame = mRadial:CreateMovableFrame(MAINBG_FRAMENAME,
                                                        {size, size},
                                                        UIParent,
                                                        MR_DEFAULT_TEMPLATE,
                                                        "Interface/Tooltips/UI-Tooltip-Background",
                                                        "BACKGROUND",
                                                        mask,
                                                        false, size, size, false)

    else
        MRadialMainFrame = frame
    end
    
    if not primary_exists then
        MRadialPrimaryFrame = mRadial:CreateMovableFrame(PRIMARY_FRAMENAME,
                                                        {300, 200},
                                                        MRadialMainFrame,
                                                        MR_DEFAULT_TEMPLATE,
                                                        "Interface/Tooltips/UI-Tooltip-Background",
                                                        "ARTWORK",
                                                        "",
                                                        false, size, size, false)
    else
        MRadialPrimaryFrame = primaryFrame
    end
    if not secondary_exists then
        MRadialSecondaryFrame = mRadial:CreateMovableFrame(SECONDARY_FRAMENAME,
                                                        {300, 200},
                                                        MRadialMainFrame,
                                                        MR_DEFAULT_TEMPLATE,
                                                        "Interface/Tooltips/UI-Tooltip-Background",
                                                        "ARTWORK",
                                                        "",
                                                        false, size, size, false)
    else
        MRadialSecondaryFrame = secondaryFrame
    end

    -- Create an invisible crosshair indicator for when we are moving the UI
    MRadialMainFrame.crosshair = MRadialMainFrame:CreateTexture("crossHair")
    MRadialMainFrame.crosshair:SetPoint("CENTER", 0, 0)
    MRadialMainFrame.crosshair:SetTexture(MR_CROSSHAIR_PATH)
    if not InCombatLockdown() then
        MRadialMainFrame.crosshair:SetSize(25, 25)
    end
    mRadial:HideFrame(MRadialMainFrame.crosshair)
    if not InCombatLockdown() then
        MRadialMainFrame:Show()
        MRadialMainFrame:EnableMouse(false)
        MRadialPrimaryFrame:EnableMouse(false)
        MRadialSecondaryFrame:EnableMouse(false)
    end
    -- Set the outofshards frame transparent by default.
    MRadialMainFrame.iconFrame:SetColorTexture(1, 0, 0, 0) -- transparent
end


---------------------------------------------------------------------------------------------------
-- WARLOCK
local impCDLast = 0
function mRadial:CreateImpCounterFrame()
    if not mRadial:IsWarlock() then return end
    
    local frameName = IMPCOUNT_FRAMENAME
    local exists, frame = mRadial:GetFrameByName(frameName)
    local hideFrame = MRadialSavedVariables["impCounterFrame"]

    if hideFrame == nil then hideFrame = MR_DEFAULT_IMPCOUNTERFRAME end
    local iconPath = string.format("%s\\imp3.blp", MR_MEDIAPATH)
    local size = 150
    if not exists then
        MRadialImpFrame = mRadial:CreateMovableFrame(frameName,
                                                    {size, size},
                                                    UIParent,
                                                    "",
                                                    "",
                                                    "ARTWORK",
                                                    "Interface/CHARACTERFRAME/TempPortraitAlphaMask", 
                                                    true, 
                                                    size, 
                                                    size,
                                                    false)
                                                     
        MRadialImpFrame.iconFrame:SetTexture(iconPath)
        MRadialImpFrame:SetAlpha(1)
        MRadialImpFrame:GetParent():SetAlpha(1)
        MRadialImpFrame:Show()
        MRadialImpFrame:GetParent():Show()
        
        mRadial:SetMountedFrameScripts(MRadialImpFrame)
        MRadialImpFrame.countText = MRadialImpFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        MRadialImpFrame.countText:SetPoint("CENTER", MRadialImpFrame.iconFrame, "CENTER", -8, -8)
        
        MRadialImpFrame:SetScript("OnUpdate", function(self, elapsed)
            impCDLast = impCDLast + elapsed
            if impCDLast <= MR_INTERVAL then return end
            local charges = GetSpellCharges(196277)
            local count = GetSpellCount(196277) 
            MRadialImpFrame.countText:SetText(tostring(count))
            impCDLast = 0
        end)

    else
        MRadialImpFrame = frame
    end
    local customFontPath =  MRadialSavedVariables['Font']
    if customFontPath == nil then customFontPath = MR_DEFAULT_FONT end
    if fontPercentage == nil then fontPercentage = MR_DEFAULT_FONTPERCENTAGE end
    MRadialImpFrame.countText:SetFont(customFontPath,  32, "OUTLINE, MONOCHROME")

    if not InCombatLockdown() then MRadialImpFrame:EnableMouse(false) end
    MRadialImpFrame.isImpFrame = true
    mRadial:SetFrameVisibility(MRadialImpFrame)
end

function mRadial:CreateShardCountFrame()
    if not mRadial:IsWarlock() then return end
    -- Sets up the frame used for counting warlock shards on the UI
    local size = 200
    local exists, frame = mRadial:GetFrameByName(SHARD_FRAMENAME)
    if not exists then 
        ShardCounterFrame = mRadial:CreateMovableFrame(SHARD_FRAMENAME,
                                            {size, size},
                                            UIParent,
                                            "",
                                            "",
                                            "ARTWORK",
                                            nil,
                                            true, 
                                            size, 
                                            size,
                                            false)
    else
        ShardCounterFrame = frame
    end
    ShardCounterFrame.isShardFrame = true
    local alpha = MRadialSavedVariables["shardFrameTransparency"]
    if alpha == nil then alpha = MR_DEFAULT_SHARD_TRANS end
    ShardCounterFrame:SetAlpha(alpha)
    mRadial:setShardTrackerFramesSize()
    mRadial:SetMountedFrameScripts(ShardCounterFrame, alpha)
    mRadial:SetFrameVisibility(ShardCounterFrame)
    if not InCombatLockdown() then
        ShardCounterFrame:EnableMouse(false)
    end
end


---------------------------------------------------------------------------------------------------
-- PET FRAMES
function mRadial:CreatePetFrames()
    for _, frame in ipairs(MR_CURRENTPETFRAMES) do
        mRadial:HideFrame(frame)
        mRadial:HideFrame(frame:GetParent())
    end
    local petAbilities = mRadial:GetPetAbilities()
    local x = -100
    local customFontPath = MRadialSavedVariables['Font'] 
    for frameName, spellData in pairs(petAbilities) do
        local spellName = spellData["spellName"]
        local spellIconPath = spellData["spellIcon"]
        local ignoreFrameNames = MRadialSavedVariables["hidePetAbilities"] or ""
        local toIgnore = false
        for line in ignoreFrameNames:gmatch("[^\r\n]+") do
            if spellName == line then toIgnore = true break end
        end
        
        -- CREATE
        local spellExists = mRadial:CheckHasPetSpell(spellName)
        local frame = mRadial:GetPetFrame(frameName)
        if frame == nil and spellExists and not toIgnore then
            local petFrameSize = MRadialSavedVariables.PetFramesSize or MR_DEFAULT_PET_FRAMESIZE
            local fontPercentage = MRadialSavedVariables.FontPercentage or MR_DEFAULT_FONTPERCENTAGE
            local frame = mRadial:CreateMovableFrame(frameName,
            {petFrameSize, petFrameSize},
            UIParent,
            "",
            spellIconPath,
            "ARTWORK",
            nil,
            true, 
            petFrameSize, 
            petFrameSize,
            true)
            
            if customFontPath == nil then customFontPath = MR_DEFAULT_FONT end
            frame.cooldownText:SetFont(customFontPath, petFrameSize*fontPercentage+2, "OUTLINE, MONOCHROME")
            frame.readyText:SetFont(customFontPath, petFrameSize*fontPercentage+2, "THICKOUTLINE")
            
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
            frame.cooldownText:SetAlpha(1)
            frame.countText:SetAlpha(1)
            frame.readyText:SetAlpha(1)
            
            mRadial:SetPetFrameScripts(frame, spellName)
            
            frame.spellName = spellName
            frame.isPetFrame = true
            table.insert(MR_CURRENTPETFRAMES, frame)

            local playerName = UnitName("player")
            local playerSpec = GetSpecialization()
            local frameCache = PerPlayerPerSpecSavedVars[playerName][playerSpec]["framePositions"]
            -- Force default position if the user hasn't already set a custom location in the frame cache
            if not mRadial:TableContainsKey(frameCache, frameName) then 
                mRadial:RestoreFrame(frameName, frame, true, x, -150)
            end
            -- Offset default locations
            x = x + (5+petFrameSize)
        end

        if frame and not toIgnore then
            if spellExists then
                mRadial:ShowFrame(frame)
                mRadial:ShowFrame(frame:GetParent())
            else
                mRadial:HideFrame(frame)
                mRadial:HideFrame(frame:GetParent())
            end
        end
    end
end

---------------------------------------------------------------------------------------------------
-- Watcher RADIAL LAYOUT
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
    local widthDeform = wd
    local heightDeform = hd
    local spread = sprd  -- -2.94  -- -5.0

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
    
    local totalCount = #orderedWatchers
    if totalCount == 0 then totalCount = 1 end
    local angleStep = (math.pi / totalCount) + spread*.1
    local autoSpread =  MRadialSavedVariables['autoSpread'] 
    if autoSpread == nil then autoSpread = MR_DEFAULT_AUTOSPREAD end
    if autoSpread then
        angleStep = (((watcherFrameSize+10)/(radius * (math.pi/180))) * (math.pi/180)) + (spread *.01)
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
            watcher.linkedTimerText:SetTextColor(buffColor[1], buffColor[2], buffColor[3])
            watcher.deBuffTimerText:SetTextColor(debuffColor[1], debuffColor[2], debuffColor[3])
            watcher.powerText:SetTextColor(powerColor[1], powerColor[2], powerColor[3])
            
            if not InCombatLockdown() then
                watcher:SetSize(watcherFrameSize, watcherFrameSize)
                -- Expand the iconFrame a little so we don't get strange squares in the circles.
                watcher.iconFrame:SetSize(watcherFrameSize*1.2, watcherFrameSize*1.2)
                -- Because the graphic for the border is a little smaller.. we wanna handle the scale now too
                watcher.borderFrame:SetSize(watcherFrameSize*1.6, watcherFrameSize*1.6)
                watcher.aura:SetSize(watcherFrameSize*3, watcherFrameSize*3)
                watcher.mask:SetSize(watcherFrameSize, watcherFrameSize)
                watcher.linkedTimerTextBG:SetSize(watcherFrameSize/1.2, watcherFrameSize/1.5)
            end
            -- TEXT
            watcher.cooldownText:SetPoint("CENTER", watcher.iconFrame, "CENTER", cdLROffset, cdUdOffset)
            watcher.countText:SetPoint("CENTER", watcher.iconFrame, "CENTER", countLROffset, countUdOffset)
            watcher.readyText:SetPoint("CENTER", watcher.iconFrame, "CENTER", readyLROffset, readyUDOffset)
            watcher.deBuffTimerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", debuffLROffset, debuffUDOffset)
            watcher.powerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", powerLROffset, powerUDOffset)
            
            -- SET FONT
            watcher.linkedTimerText:SetFont(customFontPath,  (watcherFrameSize*fontPercentage)+timerFontSize, "OUTLINE, MONOCHROME")
            watcher.deBuffTimerText:SetFont(customFontPath,  (watcherFrameSize*fontPercentage)+debuffFontSize, "OUTLINE, MONOCHROME")
            watcher.countText:SetFont(customFontPath,  (watcherFrameSize*fontPercentage)+countFontSize, "THICKOUTLINE")
            watcher.cooldownText:SetFont(customFontPath,  (watcherFrameSize*fontPercentage)+coolDownFontSize, "THICKOUTLINE")
            watcher.readyText:SetFont(customFontPath, (watcherFrameSize*fontPercentage)+readyFontSize, "THICKOUTLINE")
            watcher.powerText:SetFont(customFontPath, (watcherFrameSize*fontPercentage)+powerFontSize, "THICKOUTLINE")
            
            -- Move the watcher around the center of the frame
            if not InCombatLockdown() then watcher:SetPoint("CENTER", parentFrame, "CENTER", w, h) end
            
            -- We don't do ANY SHOW HIDE HERE!!
            if not InCombatLockdown() then watcher.linkedTimerText:SetPoint("CENTER", watcher.linkedTimerTextBG, "CENTER", 0, 0) end
            
            if cosAng >= - 0.1 and cosAng <= 0.1 then
                -- Bottom of the circle, we want to keep the text UNDER the icon here
                local centerBelow =  MRadialSavedVariables["centerBelow"]
                if centerBelow == nil then centerBelow = MR_DEFAULT_CENTERBELOW end
                if centerBelow then
                    watcher.linkedTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, readyUDOffset - watcherFrameSize/1.5)-- - watcherFrameSize/2)
                    watcher.deBuffTimerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", debuffLROffset, debuffUDOffset)-- - watcherFrameSize/2)
                else
                    watcher.linkedTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, readyUDOffset + watcherFrameSize+10)-- - watcherFrameSize/2)
                    watcher.deBuffTimerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, readyUDOffset + watcherFrameSize+10)-- - watcherFrameSize/2)
                end
                watcher.readyText:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, readyUDOffset)
            elseif cosAng <= -0.1 then
                watcher.linkedTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "LEFT", radialLROffset, radialUdOffset)
                watcher.deBuffTimerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", debuffLROffset, debuffUDOffset)
                watcher.countText:SetPoint("CENTER", watcher.iconFrame, "CENTER", countLROffset, countUdOffset)
                watcher.cooldownText:SetPoint("CENTER", watcher.iconFrame, "CENTER", cdLROffset*cosAng, cdUdOffset)
                watcher.readyText:SetPoint("CENTER", watcher.iconFrame, "CENTER", readyLROffset*cosAng, readyUDOffset)
                watcher.powerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", powerLROffset, powerUDOffset)
            elseif  cosAng >= 0.1 then
                watcher.linkedTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "RIGHT", -radialLROffset, radialUdOffset)
                watcher.deBuffTimerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", -debuffLROffset, debuffUDOffset)
                watcher.countText:SetPoint("CENTER", watcher.iconFrame, "CENTER", -countLROffset, countUdOffset)
                watcher.cooldownText:SetPoint("CENTER", watcher.iconFrame, "CENTER", cdLROffset*cosAng, cdUdOffset)
                watcher.readyText:SetPoint("CENTER", watcher.iconFrame, "CENTER", readyLROffset*cosAng, readyUDOffset)
                watcher.powerText:SetPoint("CENTER", watcher.iconFrame, "CENTER", -powerLROffset, powerUDOffset)
            end
        end
    end
end
