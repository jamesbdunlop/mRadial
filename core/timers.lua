local mRadial = mRadial

function mRadial:GetSpellCoolDown(spellName)
    local start, duration, enabled, _ = GetSpellCooldown(spellName)
    start = start or GetTime()
    duration = duration or 0
    if start and duration > 1.5 then
        local remaining = start + duration - GetTime()

        local minutes = math.floor(remaining / 60)
        local seconds = (remaining+1 - minutes * 60) 
        return enabled, remaining, minutes, seconds
    end
    return false, 0, 0, 0 -- If the spell is not on cooldown or invalid spellID provided
end

function mRadial:DoSpellFrameCooldown(spellName, watcher, outOfPower)
    if outOfPower == nil then outOfPower = false end
    local hideOOC = MRadialSavedVariables["hideooc"]
    if hideOOC == nil then hideOOC = MR_DEFAULT_HIDEOOC end
    
    -- UI is in config mode, or we are mounted.
    if MAINFRAME_ISMOVING or IsMounted() then
        return
    end
    -- We are out of combat, but we want to hide the ui when out of combat.
    if not InCombatLockdown() and hideOOC then
        return
    end
    
    -- COOLDOWNS FOR PARENT SPELLS
    -- Try to make sure we have NOTHING competing against a running debuff dot etc
    local debuffCheck = nil
    for idx = 1, 40 do
        local name, _, _, _, _, expirationTime, source, _, _, _, _, _, _, _, _ = UnitDebuff("target", idx)
        if name == spellName and source == "player" then 
            debuffCheck = expirationTime - GetTime()
            break
        end
    end
    if debuffCheck ~= nil then
        mRadial:HideFrame(watcher.readyText)
        mRadial:HideFrame(watcher.debuffTimerTextBG)
        watcher.cooldownText:SetAlpha(0)
        watcher.cooldownText:SetText(string.format(""))
        watcher.movetex:SetColorTexture(MR_DEFAULT_NOPOWER[1], MR_DEFAULT_NOPOWER[2], MR_DEFAULT_NOPOWER[3], MR_DEFAULT_NOPOWER[4])
        return
    end

    ----------------------------
    -- COOLDOWN NOW
    local enabled, remaining, minutes, seconds = mRadial:GetSpellCoolDown(spellName)
    if enabled and minutes > 0 or seconds > 0 then
        mRadial:HideFrame(watcher.readyText)
        watcher.cooldownText:SetAlpha(1)
        watcher.iconFrame:SetAlpha(1)
        watcher.movetex:SetColorTexture(MR_DEFAULT_NOPOWER[1], MR_DEFAULT_NOPOWER[2], MR_DEFAULT_NOPOWER[3], MR_DEFAULT_NOPOWER[4])
        
        if minutes == 0 then
            watcher.cooldownText:SetText(string.format("%d", seconds))
        else
            watcher.cooldownText:SetText(string.format("%d:%d", minutes, seconds))
        end
        return
    end

    -- No cooldown running.
    if minutes <= 0 and seconds <= 0 then
        watcher.cooldownText:SetAlpha(0)
        watcher.cooldownText:SetText(string.format(""))
        watcher.iconFrame:SetAlpha(1)
        if debuffCheck ~= nil or outOfPower then
            watcher.movetex:SetColorTexture(MR_DEFAULT_NOPOWER[1], MR_DEFAULT_NOPOWER[2], MR_DEFAULT_NOPOWER[3], MR_DEFAULT_NOPOWER[4])
        else
            watcher.movetex:SetColorTexture(0, 0, 0, 0)
        end

        if watcher.readyText ~= nil and not IsMounted() and not hideOOC then
            mRadial:ShowFrame(watcher.readyText)
            watcher.movetex:SetColorTexture(0, 0, 0, 0)
        end
    end
    if outOfPower then
        watcher.movetex:SetColorTexture(MR_DEFAULT_NOPOWER[1], MR_DEFAULT_NOPOWER[2], MR_DEFAULT_NOPOWER[3], MR_DEFAULT_NOPOWER[4])
    end
end

function mRadial:DoDebuffTimer(spellName, watcher, iconPath, outOfPower)
    if outOfPower == nil then outOfPower = false end
    -- DEBUFF TIMERS
    if MAINFRAME_ISMOVING then
        return
    end

    local remaining = 0

    for idx = 1, 40 do
        local name, _, _, _, _, expirationTime, source, _, _, _, _, _, _, _, _ = UnitDebuff("target", idx)
        if name == spellName and source == "player" then 
            remaining = expirationTime - GetTime() +1
            break
        end
    end

    local hideOOC = MRadialSavedVariables["hideooc"] or MR_DEFAULT_HIDEOOC
    if remaining > MR_GCD and not IsMounted() and not hideOOC then
        -- mRadial:ShowFrame(watcher.debuffTimerTextBG, .5)
        -- mRadial:HideFrame(watcher.readyText)
        watcher.movetex:SetColorTexture(MR_DEFAULT_NOPOWER[1], MR_DEFAULT_NOPOWER[2], MR_DEFAULT_NOPOWER[3], MR_DEFAULT_NOPOWER[4])
        mRadial:ShowFrame(watcher.debuffTimerText)
        watcher.debuffTimerText:SetText(string.format("%d", remaining))
        watcher.iconFrame:SetAlpha(0.5)
    elseif remaining < MR_GCD and remaining ~= 0 then
        watcher.movetex:SetColorTexture(MR_DEFAULT_NOPOWER[1], MR_DEFAULT_NOPOWER[2], MR_DEFAULT_NOPOWER[3], MR_DEFAULT_NOPOWER[4])
        mRadial:ShowFrame(watcher.debuffTimerText)
        watcher.debuffTimerText:SetText(string.format("%d", remaining))
        watcher.iconFrame:SetAlpha(0.5)
    else
        watcher.movetex:SetColorTexture(0, 0, 0, 0)
        mRadial:ShowFrame(watcher.readyText)
        mRadial:HideFrame(watcher.debuffTimerText)
        watcher.iconFrame:SetAlpha(1)
    end
    if outOfPower then
        watcher.movetex:SetColorTexture(MR_DEFAULT_NOPOWER[1], MR_DEFAULT_NOPOWER[2], MR_DEFAULT_NOPOWER[3], MR_DEFAULT_NOPOWER[4])
    end
end

function mRadial:DoPetFrameAuraTimer(spellName, frame)
    if MAINFRAME_ISMOVING then
        return
    end
    
    for idx = 1, 30 do
        local name, _, _, _, _, expirationTime, _, _, _,
        _, _, _, _, _, _ = UnitBuff("pet", idx)
        if name == spellName then
            -- Buff is active               
            local minutes, seconds = mRadial:GetAuraTimeLeft(expirationTime)
            if minutes > 0 then
                frame.cooldownText:SetText(string.format("%d:%d", minutes, seconds))
            else
                frame.cooldownText:SetText(string.format("%ds", seconds))
                frame.movetex:SetColorTexture(0, 0, 0, 0)
            end
        end
    end
end

function mRadial:DoBuffTimer(spellName, watcher, iconPath)
    local found = false
    if MAINFRAME_ISMOVING then return end
    local hideOOC = MRadialSavedVariables["hideooc"] or MR_DEFAULT_HIDEOOC
    for idx = 1, 40 do
        -- local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
        -- spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff("player", idx)
        local name, _, count, _, _, expirationTime, _, _, _, _, _, _, _, _, _ = UnitBuff("player", idx)
        
        if name == spellName then
            if count ~= 0 and count >= 1 and expirationTime ~= nil and not IsMounted() and not hideOOC then
                mRadial:ShowFrame(watcher.countText)
                watcher.countText:SetText(tostring(count))
            end
        end

        -- TIMERS
        if name ~= nil and name == spellName and expirationTime ~= nil and not IsMounted() and not hideOOC then
            -- Buff is active -- 
            found = true
            mRadial:ShowFrame(watcher.buffTimerText)
            mRadial:ShowFrame(watcher.buffTimerTextBG)
            watcher.buffTimerTextBG:SetTexture(iconPath)
            watcher.buffTimerTextBG:SetAlpha(.5)
            
            local minutes, seconds =  mRadial:GetAuraTimeLeft(expirationTime)
            if minutes~= nil and minutes > 0 then
                watcher.buffTimerText:SetText(string.format("%d:%d", minutes, seconds))
            elseif seconds > 0 then
                watcher.buffTimerText:SetText(string.format("%d", seconds))
            else
                mRadial:HideFrame(watcher.buffTimerText)
                mRadial:HideFrame(watcher.buffTimerTextBG)
            end
        end
    end
    if not found then
        mRadial:HideFrame(watcher.buffTimerText)
        mRadial:HideFrame(watcher.buffTimerTextBG)
    end
end

function mRadial:DoTotemTimer(watcher, startTime, duration, iconPath)
    if MAINFRAME_ISMOVING then
        return
    end

    local hideOOC = MRadialSavedVariables["hideooc"] or MR_DEFAULT_HIDEOOC
    -- TIMERS
    if duration ~= nil and startTime ~= nil and not IsMounted() and not hideOOC then
        startTime = startTime or GetTime()
        duration = duration or 0
        local remaining = startTime + duration+1 - GetTime()
    
        local minutes = math.floor(remaining / 60)
        local seconds = math.floor(remaining - minutes * 60)

        -- Totem is active -- 
        mRadial:ShowFrame(watcher.buffTimerText)
        mRadial:ShowFrame(watcher.buffTimerTextBG)
        watcher.buffTimerTextBG:SetTexture(iconPath)
        watcher.buffTimerTextBG:SetAlpha(.5)
        
        if minutes~= nil and minutes > 0 then
            watcher.buffTimerText:SetText(string.format("%d:%d", minutes, seconds))
        elseif seconds > 0 then
            watcher.buffTimerText:SetText(string.format("%d", seconds))
        else
            mRadial:HideFrame(watcher.buffTimerText)
            mRadial:HideFrame(watcher.buffTimerTextBG)
        end
    else
        mRadial:HideFrame(watcher.buffTimerText)
        mRadial:HideFrame(watcher.buffTimerTextBG)
    end
end

function mRadial:DoChanneledTimer(spellID)
    if MAINFRAME_ISMOVING then return end

    local channeledWatcher
    for _, watcher in ipairs(MR_WATCHERFRAMES) do
        if watcher.spellID == spellID then
            channeledWatcher = watcher
            break
        end
    end
    if channeledWatcher ~= nil then 
        local spellName, _, spellIcon, startTime, endTime, isChanneling = UnitCastingInfo("player")
        channeledWatcher.readyText:SetText("")
        local currentTime = GetTime() * 1000 -- Convert current time to milliseconds
        if endTime ~= nil then
            local remainingTime = endTime - currentTime
        end
    end
end
