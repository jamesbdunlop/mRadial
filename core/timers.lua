mWarlock = mWarlock

function mWarlock:GetSpellRemaining(spellName)
    local start, duration, enabled, _ = GetSpellCooldown(spellName)
    start = start or GetTime()
    duration = duration or 0
    local remaining = start + duration - GetTime()

    local minutes = math.floor(remaining / 60)
    local seconds = math.floor(remaining - minutes * 60)

    return enabled, remaining, minutes, seconds
end

function mWarlock:DoSpellFrameCooldown(spellName, watcher)
    -- COOLDOWNS FOR PARENT SPELLS
    --start, duration, enabled, modRate =
    -- local start, duration, enabled, _ = GetSpellCooldown(spellName)
    -- start = start or GetTime()
    -- duration = duration or 0
    -- local remaining = start + duration - GetTime()

    -- local minutes = math.floor(remaining / 60)
    -- local seconds = math.floor(remaining - minutes * 60)
    local enabled, remaining, minutes, seconds = mWarlock:GetSpellRemaining(spellName)
    if enabled and remaining > GCD then
        watcher.cooldownText:Show()
        if watcher.readyText ~= nil then
            watcher.readyText:Hide()
        end
        if minutes and minutes > 0 then
            watcher.cooldownText:SetText(string.format("%d:%d", minutes, seconds))
        else
            watcher.cooldownText:SetText(string.format("%ds", seconds))
        end
        watcher.cooldownText:SetTextColor(1, .1, .1)
        watcher.iconFrame:SetAlpha(0.5)
        watcher.movetex:SetColorTexture(1, 0, 0, .5)
    else
        watcher.cooldownText:Hide()
        watcher.iconFrame:SetAlpha(1)
        watcher.movetex:SetColorTexture(1, 0, 0, 0)
        if not IsMounted() and watcher.readyText ~= nil then
            watcher.readyText:Show()
        end
    end
end

function mWarlock:DoDebuffTimer(spellName, watcher)
    -- DEBUFF TIMERS
    local remaining = 0
    for idx = 1, 40 do
        -- name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod
        local name, _, _, _, _, expirationTime, _, _, _, _, _, _, _, _, _ = UnitDebuff("target", idx)
        if name == spellName then 
            remaining = expirationTime - GetTime()
            break
        end
    end
    if remaining > GCD then
        watcher.debuffTimerText:Show()
        watcher.debuffTimerText:SetText(string.format("%ds", remaining))
        watcher.iconFrame:SetAlpha(0.5)
        watcher.movetex:SetColorTexture(1, 0, 0, 1)
    else
        watcher.debuffTimerText:Hide()
        watcher.iconFrame:SetAlpha(1)
        watcher.movetex:SetColorTexture(1, 0, 0, 0)
        watcher.readyText:Show()
    end
end

function mWarlock:DoPetFrameAuraTimer(spellName, frame)
    for idx = 1, 30 do
        local name, _, _, _, _, expirationTime, _, _, _,
        _, _, _, _, _, _ = UnitBuff("pet", idx)
        if name == spellName then
            -- Buff is active               
            local minutes, seconds = mWarlock:GetAuraTimeLeft(expirationTime)
            if minutes > 0 then
                frame.cooldownText:SetText(string.format("%d:%d", minutes, seconds))
            else
                frame.cooldownText:SetText(string.format("%ds", seconds))
            end
            frame.cooldownText:SetTextColor(.1, 1, .1)
        end
    end
end

function mWarlock:DoBuffTimer(spellName, watcher, iconPath)
    local found = false
    for idx = 1, 40 do
        -- local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
        -- spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff("player", idx)
        local name, _, count, _, _, expirationTime, _, _, _,
        _, _, _, _, _, _ = UnitBuff("player", idx)
        
        if name == spellName then
            if count ~= 0 and count >= 1 and expirationTime ~= nil then
                watcher.countText:Show()
                watcher.countText:SetText(tostring(count))
            end
        end

        -- TIMERS
        if name ~= nil and name == spellName and expirationTime ~= nil then
            -- Buff is active -- 
            found = true
            watcher.buffTimerText:Show()
            watcher.buffTimerTextBG:Show()
            watcher.buffTimerText:SetTextColor(.1, 1, .1)
            watcher.buffTimerTextBG:SetTexture(iconPath)
            
            local minutes, seconds =  mWarlock:GetAuraTimeLeft(expirationTime)
            if minutes~= nil and minutes > 0 then
                watcher.buffTimerText:SetText(string.format("%d:%d", minutes, seconds))
            elseif seconds > 0 then
                watcher.buffTimerText:SetText(string.format("%ds", seconds))
            else
                watcher.buffTimerText:Hide()
                watcher.buffTimerTextBG:Hide()
            end
        end
    end
    if not found then
        watcher.buffTimerText:Hide()
        watcher.buffTimerTextBG:Hide()
    end
end