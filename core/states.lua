-- This module colors / shows / hides various frames
-- STATES
    -- OnCooldown
    -- DebuffTimerActive
    -- HasCount
    -- HasPower
    -- Is Visible (mounted/flying etc)

----------------------------------------------------------
-- TIMERS

-- FRAME / PET FRAME STATES
function mRadial:SetFrameState_Active_Cooldown(frame)
    if MAINFRAME_ISMOVING then return end
    -- hide
    mRadial:HideFrame(frame.readyText)
    -- show
    frame.iconFrame:SetDesaturated(true)
    mRadial:ShowFrame(frame.cooldownText)
end

function mRadial:SetFrameState_Active_Debuff(frame)
    if MAINFRAME_ISMOVING then return end
    -- hide
    mRadial:HideFrame(frame.readyText)
    
    -- show
    frame.iconFrame:SetDesaturated(true)
    mRadial:ShowFrame(frame.deBuffTimerText)
end

function mRadial:SetFrameState_Ready(frame)
    if MAINFRAME_ISMOVING then return end
    frame.iconFrame:SetDesaturated(false)
    
    -- hide
    if frame.cooldownText ~= nil then
        mRadial:HideFrame(frame.cooldownText)
        frame.cooldownText:SetText("")
    end
    if frame.deBuffTimerText ~= nil then
        mRadial:HideFrame(frame.linkedTimerText)
        frame.deBuffTimerText:SetText("")
    end
    -- show
    if frame.readyText ~= nil then
        local readyText = frame.readyText
        mRadial:ShowFrame(readyText)
        readyText:SetText(READYSTR)
        local readyColor = MRadialSavedVariables.readyColor
        if readyColor == nil then readyColor = MR_DEFAULT_READYCOLOR end
        frame.readyText:SetTextColor(readyColor[1], readyColor[2], readyColor[3], readyColor[4]) -- RED
    end
end

function mRadial:SetFrameState_Power(frame, powerType, powerMinCost, currentPower)
    if MAINFRAME_ISMOVING then return end
    if powerType == 0 then return end -- We ignore MANA
    if currentPower == nil then currentPower = 0 end
    
    local powerTextEnabled = MRadialSavedVariables["powerTextEnabled"]
    if not powerTextEnabled then
        frame.powerText:SetText("")
        mRadial:HideFrame(frame.powerText)
        return 
    end
    
    mRadial:ShowFrame(frame.powerText)

    -- Do we continue to show power even when we're lower then the min required?
    local powerPersists = MRadialSavedVariables["powerPersistsEnabled"] or MR_DEFAULT_POWERPERSISTS
    if powerPersists and currentPower <= powerMinCost then
        frame.powerText:SetText(tostring(currentPower))
    elseif currentPower >= powerMinCost then
        frame.powerText:SetText(tostring(currentPower))
    else
        mRadial:HideFrame(frame.powerText)
    end
end

function mRadial:SetFrameState_Count(frame, linkedSpell, linkedSpellID, hasActiveBuff, scount)
    if MAINFRAME_ISMOVING then return end
    local count = 0
    local spellID = frame.spellID
    if linkedSpell then
        if hasActiveBuff then
            count = scount
        else
            local charges = GetSpellCharges(spellID)
            if count == 0 and charges then count = charges end
        end
    else
        count = GetSpellCount(spellID) 
        local charges = GetSpellCharges(spellID)
        if count == 0 and charges then count = charges end
    end

    frame.countText:SetText("")
    if count and count ~= 0 then
        mRadial:ShowFrame(frame.countText)
        frame.countText:SetText(tostring(count))
        -- When we have a count for Summon Soulkeeper this spell can be marked as ready, 
        -- else we hide the ready for that spell.
        if spellName == SUMMONSOULKEEPER_SPELLNAME then
            mRadial:ShowFrame(frame.readyText)
        end
    else
        if spellName == SUMMONSOULKEEPER_SPELLNAME then
            mRadial:HideFrame(frame.readyText)
        end
    end
end

function mRadial:SetFrameState_OOR(frame, spellName)
    if MAINFRAME_ISMOVING then return end
    local inRange = IsSpellInRange(spellName)
    if inRange ~= nil and inRange == 0 then
        frame.iconFrame:SetAlpha(.2)
        frame.readyText:SetText(OORTEXT)
    else
        frame.iconFrame:SetAlpha(1)
    end
end

-----------------------
-- ACTIVE LINKED STATES
function mRadial:SetFrameState_Active_Linked(frame, linkedSpell)
    if MAINFRAME_ISMOVING then return end
    local linkedIconPath
    local linkedSpellName = linkedSpell[1] 
    local linkedSpellID = linkedSpell[2]

    _, _, linkedIconPath, _, _, _, _, _ = GetSpellInfo(linkedSpellID)
    if linkedIconPath == nil then
        _, _, linkedIconPath, _, _, _, _, _ = GetSpellInfo(linkedSpellName)
    end

    local hasActiveBuff, scount = mRadial:HasActiveBuff(linkedSpellName)
    if mRadial:HasActiveBuff(linkedSpellName) then
        mRadial:ShowFrame(frame.aura)
        mRadial:ShowFrame(frame.countText) -- Buff count
        mRadial:ShowFrame(frame.linkedTimerText)
        mRadial:ShowFrame(frame.linkedTimerTextBG)
        frame.linkedTimerTextBG:SetAlpha(.5)
    else
        mRadial:HideFrame(frame.aura)
        mRadial:HideFrame(frame.linkedTimerText)
        mRadial:HideFrame(frame.linkedTimerTextBG)
        frame.linkedTimerTextBG:SetAlpha(0)
    end
    return linkedIconPath, hasActiveBuff, scount
end

--------------
-- CONFIG MODE
function mRadial:SetFrameState_ConfigON(frame)
    local specialTexture01 = frame.specialTexture01
    if specialTexture01 then specialTexture01:SetColorTexture(0, 0, 1, .25) end
    
    -- Label the moveable frames.
    if frame.isMovable then 
        local configText = frame.configText
        if configText then 
            mRadial:ShowFrame(configText)
            configText:SetText(frame:GetName())
        end
    end
    
    --- TURN ON ANY TEXT ELEMENTS
    if frame.isParentFrame then
        local textElements = frame.timerTextElements
        if textElements then
            for x, timerTextElement in ipairs(textElements) do
                mRadial:ShowFrame(timerTextElement)
                timerTextElement:SetText("00")
            end
        end
        
        local textBGElements = frame.timerBGElements
        if timerBGElements then
            for x, timerElement in ipairs(timerBGElements) do
                mRadial:ShowFrame(timerElement)
                timerElement:SetColorTexture(1, 1, 1, 1)
            end
        end
    end
end

function mRadial:SetFrameState_ConfigOFF(frame)
    local specialTexture01 = frame.specialTexture01
    if specialTexture01 then specialTexture01:SetColorTexture(0, 0, 1, 0) end
    
    if not frame.isParentFrame and not frame.isWatcher then 
        local configText = frame.configText
        if configText then 
            mRadial:HideFrame(configText)
        end
    end

    --- TURN OFF ANY TEXT ELEMENTS
    local textElements = frame.timerTextElements
    if textElements then
        for x, timerTextElement in ipairs(textElements) do
            mRadial:HideFrame(timerTextElement)
            timerTextElement:SetText("")
        end
    end
    
    local textBGElements = frame.timerBGElements
    if timerBGElements then
        for x, timerElement in ipairs(timerBGElements) do
            mRadial:HideFrame(timerElement)
            timerElement:SetColorTexture(1, 1, 1, 0)
        end
    end
end

function mRadial:SetFrameState_Config(frame)
    local isOn = MAINFRAME_ISMOVING
    
    if isOn then
        if frame.isMovable then
            frame:EnableMouse(true)
            frame:SetMovable(true)
        end
        mRadial:SetFrameState_ConfigON(frame)
        return
    else
        if frame.isMovable then
            frame:EnableMouse(false)
            frame:SetMovable(false)
        end
        mRadial:SetFrameState_ConfigOFF(frame)
        return
    end
end

----------------------------------------------------------
-- FRAME VISIBLITY
function mRadial:EnableButtonFrame(frame)
    local asButtons = MRadialSavedVariables[MR_KEY_ASBUTTONS]
    if asButtons == nil then asButtons = MR_DEFAULT_ASBUTTONS end
    if asButtons and frame.isWatcher and not InCombatLockdown() then
        frame:EnableMouse(true)
    end
end

function mRadial:DisableButtonFrame(frame)
    local asButtons = MRadialSavedVariables[MR_KEY_ASBUTTONS]
    if asButtons == nil then asButtons = MR_DEFAULT_ASBUTTONS end
    if asButtons and frame.isWatcher and not InCombatLockdown() then
        frame:EnableMouse(false)
    end
end

function mRadial:SetFrameVisibility(frame)
    if IsMounted() or IsFlying() then
        mRadial:HideFrame(frame)
        mRadial:DisableButtonFrame(frame)
        return
    end
    
    local hideOOC = MRadialSavedVariables["hideooc"] or MR_DEFAULT_HIDEOOC
    if hideOOC and not InCombatLockdown() then 
        mRadial:HideFrame(frame)
        mRadial:DisableButtonFrame(frame)
        return
    end

    local hidePetFrame = MRadialSavedVariables["hidePetFrame"] or false
    if frame.isPetFrame and hidePetFrame then
        mRadial:HideFrame(frame)
        return
    elseif frame.isPetFrame then
        -- DEAD PET
        local petGUID = UnitGUID("pet")
        if petGUID == nil then
            mRadial:HideFrame(frame)
            return
        end
        
        local spellName = frame.spellName
        local spellExists = mRadial:CheckHasPetSpell(spellName)
        if not spellExists then
            mRadial:HideFrame(frame)
            return
        end
    end

    if frame.isShardFrame then
        local hide = MRadialSavedVariables["hideShardFrame"]
        if hide == nil then hide = MR_DEFAULT_SHARD_HIDE end
        if hide then
            mRadial:HideFrame(ShardCounterFrame)
            return
        end
    end

    if frame.isImpFrame then
        local hide = MRadialSavedVariables["impCounterFrame"]
        if hide == nil then hide = MR_DEFAULT_IMP_HIDE end
        if hide then
            mRadial:HideFrame(frame)
            return
        end
    end

    mRadial:ShowFrame(frame)
    mRadial:EnableButtonFrame(frame)
end

function mRadial:ShowFrame(frame, alpha)
    if alpha == nil then alpha = 1 end

    if frame.isParentFrame then
        frame:SetAlpha(alpha)
        local childFrames = {}
        childFrames[1] = frame.iconFrame
        childFrames[2] = frame.borderFrame
        childFrames[3] = frame.aura
        
        for idx, childFrame in ipairs(childFrames) do
            if childFrame ~= nil then
                childFrame:SetAlpha(alpha)
                if idx == 2 then
                    childFrame:SetAlpha(MR_DEFAULT_BORDERALPHA)
                end
            end
        end
    else
        frame:SetAlpha(alpha)
        if frame.borderFrame ~= nil then
            frame.borderFrame:SetAlpha(MR_DEFAULT_BORDERALPHA)
        end
    end
    
    if frame:GetName() == SHARD_FRAMENAME then
        local shardFrameTransparency = MRadialSavedVariables["shardFrameTransparency"] or MR_DEFAULT_SHARD_TRANS
        frame:SetAlpha(shardFrameTransparency)
    end
end

function mRadial:HideFrame(frame)
    if MAINFRAME_ISMOVING then return end
    if frame.isParentFrame then
        frame:SetAlpha(0)
        local textElements = frame.timerElements
        if textElements ~= nil then
            for _, frame in ipairs(textElements) do
                frame:SetAlpha(0)
            end
        end
    else
        frame:SetAlpha(0)
    end
end

function mRadial:SetConfigMode(isMovable)
    --Sets frames to be moveable or not. Assigns a blue color to their respective specialTexture01, textures.
    if isMovable == nil then isMovable = MRadialSavedVariables["moveable"] or false end
    
    -- set the global CONST for config mode now.
    MAINFRAME_ISMOVING = isMovable
    
    local mask = MR_DEFAULT_RADIAL_MASK
    if not MAINFRAME_ISMOVING then mask = "" end
    if MRadialPrimaryFrame ~= nil then
        MRadialPrimaryFrame.mask:SetTexture(mask, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        MRadialPrimaryFrame:SetFrameLevel(100)
    end
    if MRadialSecondaryFrame ~= nil then
        MRadialSecondaryFrame.mask:SetTexture(mask, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        MRadialSecondaryFrame:SetFrameLevel(100)
    end

    -- ALL FRAMES CONFIG STATE NOW.
    for _, frame in pairs(MR_ALLFRAMES) do
        mRadial:SetFrameState_Config(frame)
    end
    for _, frame in pairs(MR_PARENTFRAMES) do
        mRadial:SetFrameState_Config(frame)
    end

    -- Handle class specific frames (Warlock)
    if mRadial:IsWarlock() then
        local hideOOfShardFrame = MRadialSavedVariables["hideOOShardFrame"] or MR_DEFAULT_HIDE_OOSF
        if not hideOOfShardFrame then 
            mRadial:SetFrameState_ConfigON(MRadialMainFrame.iconFrame)
        else
            mRadial:SetFrameState_ConfigOFF(MRadialMainFrame.iconFrame)
        end

        if ShardCounterFrame ~= nil then
            ShardCounterFrame:SetFrameLevel(90)
        end
        
        if MRadialImpFrame ~= nil then
            MRadialImpFrame:SetFrameLevel(90)
        end
    end
end
