-- Some globals
local watcherCount = 0
local watchers = {}

local fontName, fontHeight, fontFlags = GameFontNormal:GetFont()
---------------------------------------------------------------------------------------------------
-- UTILS
function mWarlock:GetAuraTimeLeft(expirationTime)
    if expirationTime == nil then
        return nil
    end
    local timeLeft = expirationTime - GetTime()
    local minutes = math.floor(timeLeft / 60)
    local seconds = math.floor(timeLeft - minutes * 60)
    return minutes, seconds
end

function mWarlock:HasBuff(buffName)
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i)
        if name and name == buffName then
            return true
        end
    end
    return false
end

---------------------------------------------------------------------------------------------------
-- Spell watchers for timers/cooldowns.
function mWarlock:addWatcher(buffName, iconPath, parentSpellIcon, parentSpellName, skipBuff, isShardDependant, spellID)
    -- Create the watcher frame
    -- If we have a parentSpell, this is cast and goes on cooldown, and the buff is the result 
    -- of casting this to keep track of...
    -- If we don't  have a buff name, we're tracking the parent spell entirely.
    if not buffName then
        buffName = parentSpellName
    end
    
    local frameName
    if parentSpellIcon then
        frameName = string.format("Frame_%s", parentSpellName)
    else
        frameName = string.format("Frame_%s", buffName)
    end
    
    local watcher = mWarlock:CreateWatcherFrame(frameName)

    -- Set the OnUpdate function for the frame
    watcher:SetScript("OnUpdate", function(self, elapsed)
        -- Hide all the UI when mounted.
        if IsMounted() then
            watcher:Hide()
            watcher.texture:Hide()
            watcher.iconFrame:Hide()
            watcher.readyText:Hide()
            watcher.countText:Hide()
            watcher.cooldownText:Hide()
        else
            watcher:Show()
            watcher.texture:Show()
            watcher.readyText:Show()
            watcher.iconFrame:Show()
            watcher.countText:Show()
            watcher.cooldownText:Show()
        end

        -- Swap the icon if we have a parent spell, eg: Power Siphon buffs Demonic Core.
        if parentSpellName then
            watcher.iconFrame:SetTexture(parentSpellIcon)
        else
           watcher.iconFrame:SetTexture(iconPath)
        end 

        -- If we do have a parent spell, if it has a cool down we need to run that cooldown timer.
        if parentSpellName and not IsMounted() then
            -- COOLDOWNS FOR PARENT SPELLS
            local start, duration, enabled, modRate = GetSpellCooldown(parentSpellName)
            -- catch a bug when changing talents.
            if start == nil then
                start = 0
            end

            local remaining = start + duration - GetTime()
            local minutes = math.floor(remaining / 60)
            local seconds = math.floor(remaining - minutes * 60)
            if enabled and remaining > 0 then
                watcher.cooldownText:Show()
                watcher.readyText:Hide()
                if minutes and minutes > 0 then
                    watcher.cooldownText:SetText(string.format("%d:%d", minutes, seconds))
                else
                    watcher.cooldownText:SetText(string.format("%ds", seconds))
                end
                watcher.cooldownText:SetTextColor(1, .1, .1)
                watcher.iconFrame:SetAlpha(0.5)
            else
                watcher.cooldownText:Hide()
                watcher.iconFrame:SetAlpha(1)
                if not IsMounted() then
                    watcher.readyText:Show()
                end
            end
        end

        -- Find any "counts" for buffs, eg Implosion etc
        found = false
        local count = GetSpellCount(spellID)
        if count ~= 0 and not IsMounted() then
            watcher.countText:Show()
            watcher.countText:SetText(tostring(count))
            
            -- When we have a count for Summon Soulkeeper this spell can be marked as ready, 
            -- else we hide the ready for that spell.
            if buffName == SUMMONSOULKEEPER_SPELLNAME then
                watcher.readyText:Show()
            end
        else
            if buffName == SUMMONSOULKEEPER_SPELLNAME then
                watcher.readyText:Hide()
            end
        end

        if not mWarlock:HasBuff(buffName) and buffName == DEMONICCORE_SPELLNAME then
            watcher.countText:SetText("")
            watcher.countText:Hide()
        end

        for idx = 1, 40 do
            local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
            spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff("player", idx)
            
            if name == buffName then
                if count ~= 0 and count >= 1 and expirationTime ~= nil then
                    watcher.countText:Show()
                    watcher.countText:SetText(tostring(count))
                end
            end

            -- TIMERS
            if name ~= nil and name == buffName and expirationTime ~= nil then
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
        if isShardDependant then
            local soulShards = UnitPower("player", 7)
            if soulShards == 0 then
                watcher.readyText:SetText(NOSSSTR)
                watcher.readyText:SetTextColor(1, 0, 0)
            else
                watcher.readyText:SetText(READYSTR)
                watcher.readyText:SetTextColor(0, 1, 0)
            end
            
            if buffName == CALLDREADSTALKERS_SPELLNAME and soulShards < 2 then
                watcher.readyText:SetText(NOSSSTR)
                watcher.readyText:SetTextColor(1, 0, 0)
            else
                watcher.readyText:SetText(READYSTR)
                watcher.readyText:SetTextColor(0, 1, 0)
            end
        end
        mWarlock:radialButtonLayout()
    end)
    
    -- Now stores all these frames into tables for laying out in the radial fashion
    watcherCount = watcherCount+1
    watchers[watcherCount] = watcher
end

---------------------------------------------------------------------------------------------------
-- Watcher radial layout.
function mWarlock:radialButtonLayout()
    --- Handles adding the frames around a unit circle cause I like it better this way....
    local cfontName = "Accidental Presidency.ttf"
    local customFontPath = "Interface\\Addons\\mWarlock\\fonts\\" .. cfontName
    
    local radius = MWarlockSavedVariables.radius
    local offset = MWarlockSavedVariables.offset
    local spread = MWarlockSavedVariables.watcherFrameSpread or 0
    local countFontSize = MWarlockSavedVariables.countFontSize or 22
    local readyFontSize = MWarlockSavedVariables.readyFontSize or 22
    local coolDownFontSize = MWarlockSavedVariables.coolDownFontSize or 22
    local timerFontSize = MWarlockSavedVariables.timerFontSize or 22

    local watcherFrameSize = MWarlockSavedVariables.watcherFrameSize or 55

    local angleStep = math.pi / #watchers +spread
    for x = 1, #watchers do
        local angle = (x-1)*angleStep + offset*math.pi
        local sinAng = math.sin(angle)
        local cosAng = math.cos(angle)
        local w = cosAng*radius
        local h = sinAng*radius
        local watcher = watchers[x]
        
        watcher:SetSize(watcherFrameSize, watcherFrameSize)
        watcher.buffTimerTextBG:SetSize(watcherFrameSize/1.5, watcherFrameSize/1.5)
        watcher.buffTimerText:SetSize(watcherFrameSize*1.25, watcherFrameSize)
        watcher.iconFrame:SetSize(watcherFrameSize*1.25, watcherFrameSize*1.25)
        
        watcher.buffTimerText:SetFont(customFontPath, timerFontSize, "OUTLINE, MONOCHROME")
        watcher.countText:SetFont(customFontPath, countFontSize, "THICKOUTLINE")
        watcher.cooldownText:SetFont(customFontPath, coolDownFontSize, "THICKOUTLINE")
        watcher.readyText:SetFont(customFontPath, readyFontSize, "THICKOUTLINE")
        
        -- Move the watcher around the center of the frame
        watcher:Show()
        watcher:SetPoint("CENTER", MWarlockMainFrame, "CENTER", w, h)
        
        -- Now manage the timers texts so they're center icon when 
        -- READYSTR and on the bg when ticking
        -- We don't do ANY SHOW HIDE HERE!!
        local radialUDOffset = -10
        local radialLROffset = -10
        watcher.buffTimerText:SetPoint("CENTER", watcher.buffTimerTextBG, "CENTER", 0, 0)
        if cosAng <= 0 then
            watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "LEFT", radialLROffset, radialUDOffset)
        
        elseif cosAng == 0 then
            -- Bottom of the circle, we want to keep the text UNDER the icon here
            watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "CENTER", 0, radialUDOffset)

        else
            watcher.buffTimerTextBG:SetPoint("CENTER", watcher.iconFrame, "RIGHT", radialLROffset*-1, radialUDOffset)
        end
    end
end
---------------------------------------------------------------------------------------------------