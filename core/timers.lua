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

function mRadial:GetDebuffTimer(spellName)
    local remaining = 0
    for idx = 1, 40 do
        local name, _, _, _, _, expirationTime, source, _, _, _, _, _, _, _, _ = UnitDebuff("target", idx)
        if name == spellName and source == "player" then 
            remaining = expirationTime - GetTime() +1
            break
        end
    end
    return remaining
end

function mRadial:DoSpellFrameCooldown(spellName, frame, outOfPower)
    if MAINFRAME_ISMOVING then return end
    -- COOLDOWNS FOR PARENT SPELLS
    -- Try to make sure we have NOTHING competing against a running debuff dot etc
    local debuffCheck = mRadial:IsActiveDebuff(spellName)
    if debuffCheck then
        return false
    else
        mRadial:SetFrameState_Active_Cooldown(frame)
    end

    ----------------------------
    -- COOLDOWN NOW
    local enabled, remaining, minutes, seconds = mRadial:GetSpellCoolDown(spellName)
    if enabled and minutes > 0 or seconds > 0 then
        if minutes ~= 0 then
            frame.cooldownText:SetText(string.format("%d:%d", minutes, seconds))
        else
            frame.cooldownText:SetText(string.format("%d", seconds))
        end
        return true
    end

    return false
end

function mRadial:DoDebuffTimer(spellName, watcher, iconPath)
    if MAINFRAME_ISMOVING then return end

    local remaining = mRadial:GetDebuffTimer(spellName)
    if remaining > MR_GCD then
        watcher.deBuffTimerText:SetText(string.format("%d", remaining))
        return true
    elseif remaining < MR_GCD and remaining ~= 0 then
        watcher.deBuffTimerText:SetText(string.format("%d", remaining))
        return true
    end
    return false
end

function mRadial:DoPetFrameAuraTimer(spellName, frame)
    if MAINFRAME_ISMOVING then return end

    for idx = 1, 30 do
        local name, _, _, _, _, expirationTime, _, _, _,
        _, _, _, _, _, _ = UnitBuff("pet", idx)
        if name == spellName then
            -- Buff is active               
            local minutes, seconds = mRadial:GetAuraTimeLeft(expirationTime)
            if minutes > 0 then
                frame.cooldownText:SetText(string.format("%d:%d", minutes, seconds))
                return true
            else
                frame.cooldownText:SetText(string.format("%ds", seconds))
                return true
            end
        end
    end
    return false
end

function mRadial:DoLinkedTimer(spellName, watcher, iconPath)
    if MAINFRAME_ISMOVING then return end

    local found = false
    for idx = 1, 40 do
        -- local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
        -- spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff("player", idx)
        local name, _, count, _, _, expirationTime, _, _, _, _, _, _, _, _, _ = UnitBuff("player", idx)
        
        -- We set the count to the buff count for things like Demonic Core etc...
        if name ~= nil and name == spellName then
            if count ~= 0 and count >= 1 and expirationTime ~= nil then
                watcher.countText:SetText(tostring(count))
            end
        end

        -- TIMERS
        -- Buff is active -- 
        if name ~= nil and name == spellName and expirationTime ~= nil then
            watcher.linkedTimerTextBG:SetTexture(iconPath)
            local minutes, seconds = mRadial:GetAuraTimeLeft(expirationTime)
            if minutes~= nil and minutes > 0 then
                watcher.linkedTimerText:SetText(string.format("%d:%d", minutes, seconds))
            elseif seconds > 0 then
                watcher.linkedTimerText:SetText(string.format("%d", seconds))
            else
                watcher.linkedTimerText:SetText("")
            end
        end
    end
end

function mRadial:DoTotemTimer(watcher, startTime, duration, iconPath)
    if MAINFRAME_ISMOVING then return end

    local hideOOC = MRadialSavedVariables["fadeooc"] or MR_DEFAULT_FADEOOC
    -- TIMERS
    if duration ~= nil and startTime ~= nil and not IsMounted() and not hideOOC then
        startTime = startTime or GetTime()
        duration = duration or 0
        local remaining = startTime + duration+1 - GetTime()
    
        local minutes = math.floor(remaining / 60)
        local seconds = math.floor(remaining - minutes * 60)

        -- Totem is active -- 
        mRadial:ShowFrame(watcher.linkedTimerText)
        mRadial:ShowFrame(watcher.linkedTimerTextBG)
        watcher.linkedTimerTextBG:SetTexture(iconPath)
        watcher.linkedTimerTextBG:SetAlpha(.5)
        if minutes~= nil and minutes > 0 then
            watcher.linkedTimerText:SetText(string.format("%d:%d", minutes, seconds))
        elseif seconds > 0 then
            watcher.linkedTimerText:SetText(string.format("%d", seconds))
        else
            mRadial:HideFrame(watcher.linkedTimerText)
            mRadial:HideFrame(watcher.linkedTimerTextBG)
        end
    else
        mRadial:HideFrame(watcher.linkedTimerText)
        mRadial:HideFrame(watcher.linkedTimerTextBG)
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
