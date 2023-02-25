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
        watcher.cooldownText:Show()
        watcher.readyText:Hide()
        watcher.cooldownText:SetText(string.format("%ds", remaining))
        watcher.cooldownText:SetTextColor(1, .1, .1)
        watcher.iconFrame:SetAlpha(0.5)
        watcher.movetex:SetColorTexture(1, 0, 0, .2)
    else
        watcher.cooldownText:Hide()
        watcher.iconFrame:SetAlpha(1)
        watcher.movetex:SetColorTexture(1, 0, 0, 0)
        if not IsMounted() then
            watcher.readyText:Show()
        end
        -- SHow any cooldowns instead!
        mWarlock:DoSpellFrameCooldown(spellName, watcher)
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