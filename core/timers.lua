local mRadial = mRadial

function mRadial:GetSpellRemaining(spellName)
    local start, duration, enabled, _ = GetSpellCooldown(spellName)
    start = start or GetTime()
    duration = duration or 0
    local remaining = start + duration - GetTime()

    local minutes = math.floor(remaining / 60)
    local seconds = math.floor(remaining - minutes * 60) + 1

    return enabled, remaining, minutes, seconds
end

function mRadial:DoSpellFrameCooldown(spellName, watcher)
    -- COOLDOWNS FOR PARENT SPELLS
    if MAINFRAME_ISMOVING then
        return
    end

    local enabled, remaining, minutes, seconds = mRadial:GetSpellRemaining(spellName)
    local hideOOC = MRadialSavedVariables["hideooc"] or MR_DEFAULT_HIDEOOC
    if enabled and remaining > MR_GCD and not IsMounted() and not hideOOC then
        watcher.cooldownText:SetAlpha(1)
        watcher.cooldownText:SetTextColor(1, .1, .1)
        watcher.iconFrame:SetAlpha(1)
        watcher.movetex:SetColorTexture(1, 0, 0, .5)

        if watcher.readyText ~= nil then
            watcher.readyText:SetAlpha(0)
        end
        if minutes and minutes > 0 then
            watcher.cooldownText:SetText(string.format("%d:%d", minutes, seconds))
        elseif seconds then
            watcher.cooldownText:SetText(string.format("%ds", seconds))
        else
            watcher.cooldownText:SetText(string.format(""))
            watcher.iconFrame:SetAlpha(1)
            watcher.movetex:SetColorTexture(1, 0, 0, 0)
        end
    else
        watcher.cooldownText:SetAlpha(0)
        watcher.cooldownText:SetText(string.format(""))
        watcher.iconFrame:SetAlpha(1)
        watcher.movetex:SetColorTexture(1, 0, 0, 0)
        if watcher.readyText ~= nil and not IsMounted() and not hideOOC then
            mRadial:ShowFrame(watcher.readyText)
        end
    end
end

function mRadial:DoDebuffTimer(spellName, watcher, iconPath)
    -- DEBUFF TIMERS
    if MAINFRAME_ISMOVING then
        return
    end

    local remaining = 0
    for idx = 1, 40 do
        -- name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod
        local name, _, _, _, _, expirationTime, _, _, _, _, _, _, _, _, _ = UnitDebuff("target", idx)
        if name == spellName then 
            remaining = expirationTime - GetTime()
            break
        end
    end
    local hideOOC = MRadialSavedVariables["hideooc"] or MR_DEFAULT_HIDEOOC
    if remaining > MR_GCD and not IsMounted() and not hideOOC then
        mRadial:ShowFrame(watcher.debuffTimerTextBG)
        watcher.debuffTimerTextBG:SetTexture(iconPath)
        watcher.debuffTimerTextBG:SetAlpha(.5)

        mRadial:ShowFrame(watcher.debuffTimerText)
        watcher.debuffTimerText:SetText(string.format("%ds", remaining))

        watcher.iconFrame:SetAlpha(0.5)
        watcher.movetex:SetColorTexture(1, 0, 0, 1)
    else
        mRadial:HideFrame(watcher.debuffTimerTextBG)
        mRadial:HideFrame(watcher.debuffTimerText)
        watcher.iconFrame:SetAlpha(1)
        watcher.movetex:SetColorTexture(1, 0, 0, 0)
        if not IsMounted() and not hideOOC then
            mRadial:ShowFrame(watcher.readyText)
        end
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
            end
            frame.cooldownText:SetTextColor(.1, 1, .1)
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
            watcher.buffTimerText:SetTextColor(.1, 1, .1)
            watcher.buffTimerTextBG:SetTexture(iconPath)
            watcher.buffTimerTextBG:SetAlpha(.5)
            
            local minutes, seconds =  mRadial:GetAuraTimeLeft(expirationTime)
            if minutes~= nil and minutes > 0 then
                watcher.buffTimerText:SetText(string.format("%d:%d", minutes, seconds))
            elseif seconds > 0 then
                watcher.buffTimerText:SetText(string.format("%ds", seconds))
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
        watcher.buffTimerText:SetTextColor(.1, 1, .1)
        watcher.buffTimerTextBG:SetAlpha(.5)
        
        if minutes~= nil and minutes > 0 then
            watcher.buffTimerText:SetText(string.format("%d:%d", minutes, seconds))
        elseif seconds > 0 then
            watcher.buffTimerText:SetText(string.format("%ds", seconds))
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
