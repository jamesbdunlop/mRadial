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
    parentFrame.isParentFrame = true

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
    parentFrame.baseFrame = frame
    
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

    frame.debuffTimerTextBG = frame:CreateTexture(nil, "BACKGROUND")
    frame.debuffTimerTextBG:SetColorTexture(.25, 0, 0, 1)

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
                                            MRadialMainFrame, 
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
    
    if isMovable then
        MRadialMainFrame.crosshair:Show()
        MRadialMainFrame.movetex:Show()
        MRadialMainFrame.iconFrame:SetColorTexture(1, 0, 0, .5)
    else
        MRadialMainFrame.crosshair:Hide()
        MRadialMainFrame.movetex:Hide()
        MRadialMainFrame.iconFrame:SetColorTexture(1, 0, 0, 0)
    end

    for _, pframe in pairs(MR_PARENTFRAMES) do
        if isMovable then
            if not pframe.baseFrame.isWatcher then
                pframe.baseFrame.movetex:Show()
                pframe.baseFrame.movetex:SetColorTexture(0, 0, 1, .5)
                pframe.baseFrame:EnableMouse(isMovable)
                pframe.baseFrame:SetMovable(isMovable)
            else
                pframe.baseFrame.readyText:Show()
                pframe.baseFrame.countText:Show()
                pframe.baseFrame.cooldownText:Show()
                pframe.baseFrame.buffTimerText:Show()
                pframe.baseFrame.buffTimerTextBG:Show()
                pframe.baseFrame.debuffTimerTextBG:Show()

                pframe.baseFrame.buffTimerTextBG:SetColorTexture(0, .25, 0, 1)
                pframe.baseFrame.buffTimerText:SetText("00")
                pframe.baseFrame.countText:SetText("00")
                pframe.baseFrame.cooldownText:SetText("00")
            end
        else
            if not pframe.baseFrame.isWatcher then
                pframe.baseFrame.movetex:Hide()
                pframe.baseFrame.movetex:SetColorTexture(0, 0, 1, 0)
                pframe.baseFrame:EnableMouse(isMovable)
                pframe.baseFrame:SetMovable(isMovable)
            else
                pframe.baseFrame.readyText:Hide()
                pframe.baseFrame.countText:Hide()
                pframe.baseFrame.cooldownText:Hide()
                pframe.baseFrame.buffTimerText:Hide()
                pframe.baseFrame.buffTimerTextBG:Hide()
                pframe.baseFrame.debuffTimerTextBG:Hide()
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

---------------------------------------------------------------------------------------------------
-- Spell watchers for timers/cooldowns.
local last = 0
function mRadial:createWatcherFrame(spellID)
    -- Create the watcher frame
    -- If we have a parentSpell, this is cast and goes on cooldown, and the buff is the result 
    -- of casting. If we don't have a buff name, we're tracking the parent spell entirely.

    -- spellName, rank, iconPath, castTime, minRange, maxRange, spellID, originalSpellIcon = 
    local spellName, _, iconPath, _, _, _, spellID, _ = GetSpellInfo(spellID)
    local frameName = string.format("Frame_%s", spellName)

    local watcher = mRadial:CreateRadialWatcherFrame(frameName, spellName, iconPath)
    watcher.spellName = spellName
    ------------------------------------------
    -- SPELL INFORMATION TO USE FOR TIMERS ETC
    local isUnitPowerDependant, UnitPowerCount = mRadial:IsSpellUnitPowerDependant(spellID)
    -- local overrideSpellID = C_SpellBook.GetOverrideSpell(spellID)
    -- local pSpellName, _, pIconPath, _, pMinRange, pMaxRange, _, _ = GetSpellInfo(overrideSpellID)
    -- local disabled = C_SpellBook.IsSpellDisabled(spellID)

    ----------------------------------------------
    -- Assign the spell to cast if we're a button!
    local asButtons = MRadialSavedVariables["asbuttons"] or false
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
        last = last + elapsed
        if last <= .25 then
            return
        end

        if MAINFRAME_ISMOVING then
            return
        end
        
        if not MAINFRAME_ISMOVING then 
            if isUnitPowerDependant then
                -- Do we have enough shards to allow this to show timers / cast from?
                local unitpower = 0
                if mRadial:IsWarlock() then
                    unitpower = UnitPower("player", 7) -- soul shards
                else
                    unitpower = UnitPower("player") -- hopefully the rest list insanity etc
                end
    
                if unitpower == 0 or unitpower < UnitPowerCount then
                    watcher.readyText:SetText(NOSSSTR)
                    watcher.readyText:SetTextColor(1, 0, 0)
                    watcher.movetex:SetColorTexture(1, 0, 0, .5)
                    watcher.buffTimerTextBG:Hide()
                    last = 0
                    if not IsMounted() then
                        watcher.movetex:Show()
                    end
                    return
                else
                    watcher.readyText:SetText(READYSTR)
                    watcher.readyText:SetTextColor(0, 1, 0)
                    watcher.movetex:Hide()
                end
            end
            mRadial:DoDebuffTimer(spellName, watcher)
            mRadial:DoSpellFrameCooldown(spellName, watcher)
            -- LINKED SPELLS!!!!
            -- I need a way to link a spell to another, perhaps a manually written table for now
            -- as I can't find anythign in the API
            -- in the cast of a linked spell I need to know that eg
                -- when VoidTorrent is cast, we have a buff VoidForm running we want to track, and cooldowns for VoidBolts during that time.
                -- and when we run out of VoidForm we then end up showing the cooldown for VoidTorrent.
                -- relationships = {spellName, buffName, swapSpellNameTo}
            local getLinked = linkedSpells[spellName] or nil
            
            if getLinked ~= nil then 
                local linkedSpellName = getLinked[1] 
                local linkedSpellID = getLinked[2]
                local linkedIconPath
                _, _, linkedIconPath, _, _, _, _, _ = GetSpellInfo(linkedSpellID)
                mRadial:DoBuffTimer(linkedSpellName, watcher, linkedIconPath)
                
                if mRadial:HasActiveBuff(linkedSpellName) and not IsMounted() then
                    watcher.aura:Show()
                else
                    watcher.aura:Hide()
                end
            else
                mRadial:DoBuffTimer(spellName, watcher, iconPath)
                watcher.aura:Hide()
            end

            -- Now set the count on the frame regardless.
            local count = 0
            if getLinked ~= nil then
                local linkedSpellName = getLinked[1] 
                local linkedSpellID = getLinked[2]
                local hasActiveBuff, scount = mRadial:HasActiveBuff(linkedSpellName)
                if  hasActiveBuff then
                    count = scount
                end
            else
                count = GetSpellCount(spellID)
            end

            watcher.countText:SetText("")
            if count ~= 0 and not IsMounted() then
                watcher.countText:Show()
                watcher.countText:SetText(tostring(count))
                -- When we have a count for Summon Soulkeeper this spell can be marked as ready, 
                -- else we hide the ready for that spell.
                if spellName == SUMMONSOULKEEPER_SPELLNAME then
                    watcher.readyText:Show()
                end
            else
                if spellName == SUMMONSOULKEEPER_SPELLNAME then
                    watcher.readyText:Hide()
                end
            end

        end
        
        last = 0
    end)

    return watcher
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
            
            local isKnown = IsPlayerSpell(spellId)
            local isPassive = IsPassiveSpell(spellID)
            local frameName = string.format("Frame_%s", spellName)
            if isActive and isKnown and not isPassive and not mRadial:WatcherExists(frameName) then
                -- print("Adding watcherFrame for  %s", spellName)
                local frame = mRadial:createWatcherFrame(spellID)
                MR_WATCHERFRAMES[#MR_WATCHERFRAMES+1] = frame
                UdOffset = UdOffset + 32
            elseif not isActive and mRadial:WatcherExists(frameName) then
                local frame, idx = mRadial:GetWatcher(frameName)
                if frame ~= nil then
                    local pframe = frame:GetParent()
                    if pframe ~= nil then
                        pframe:Hide()
                    end
                    frame:Hide()
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
    -- Main Frame
    MRadialMainFrame = mRadial:CreateMovableFrame(MAINBG_FRAMENAME,
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
    MRadialMainFrame.crosshair = MRadialMainFrame:CreateTexture("crossHair")
    MRadialMainFrame.crosshair:SetPoint("CENTER", 0, 0)
    
    local crossHairPath = MEDIAPATH .."\\crosshair.blp"
    MRadialMainFrame.crosshair:SetTexture(crossHairPath)
    MRadialMainFrame.crosshair:SetSize(25, 25)
    MRadialMainFrame.crosshair:Hide()
    MRadialMainFrame:Show()
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
            MR_PETFAMES[#MR_PETFAMES+1] = frame
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
    for idx, frame in pairs(MR_PETFAMES) do
        if frame.isPetFrame then
            local pframe = frame:GetParent()
            if pframe ~= nil then
                pframe:Hide()
            end
            frame:Hide()
        end
    end
end

function mRadial:SetPetFramePosAndSize()
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

function mRadial:RadialButtonLayout()
    -- print("Performing radial layout now.")
    --- Handles adding the frames around a unit circle cause I like it better this way....
    local cfontName = "Accidental Presidency.ttf"
    local customFontPath = "Interface\\Addons\\mRadial\\fonts\\" .. cfontName
    
    local radius = MRadialSavedVariables.radius or 100
    local offset = MRadialSavedVariables.offset or .5
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

    ACTIVEWATCHERS = {}
    for x=1, #MR_WATCHERFRAMES do
        local watcher = MR_WATCHERFRAMES[x]
        watcher:Hide()
        local isActive = MRadialSavedVariables["isActive".. watcher.spellName] or false
        if isActive then
            ACTIVEWATCHERS[#ACTIVEWATCHERS+1] = watcher
        end
    end

    local angleStep = math.pi / #ACTIVEWATCHERS + spread
    for x = 1, #ACTIVEWATCHERS do
        local watcher = ACTIVEWATCHERS[x]
        watcher:Show()
        watcher:GetParent():Show()
        local angle = (x-1)*angleStep + offset*math.pi
        local sinAng = math.sin(angle)
        local cosAng = math.cos(angle)
        local w = cosAng*radius*widthDeform
        local h = sinAng*radius*heightDeform
        if watcher ~= nil and watcher.isWatcher then
            -- print("Found watcher frame! %s", watcher:GetName())
            watcher:SetSize(watcherFrameSize, watcherFrameSize)
            -- expand the iconFrame a little so we don't get strange squares in the circles.
            watcher.iconFrame:SetSize(watcherFrameSize*1.2, watcherFrameSize*1.2)
            -- because the graphic for the border is a little smaller.. we wanna handle the scale now too
            watcher.borderFrame:SetSize(watcherFrameSize*1.6, watcherFrameSize*1.6)
            watcher.aura:SetSize(watcherFrameSize*3, watcherFrameSize*3)
            
            watcher.mask:SetSize(watcherFrameSize, watcherFrameSize)
            watcher.buffTimerTextBG:SetSize(watcherFrameSize/1.5, watcherFrameSize/1.5)
            watcher.debuffTimerTextBG:SetSize(watcherFrameSize/1.5, watcherFrameSize/1.5)
            
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
            watcher:SetPoint("CENTER", MRadialMainFrame, "CENTER", w, h)
            
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
            watcher.debuffTimerTextBG:SetPoint("CENTER", watcher.buffTimerTextBG, "CENTER", 0, 0)
        end
    end
end
