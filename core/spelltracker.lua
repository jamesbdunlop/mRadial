-- Some globals
local fontName, fontHeight, fontFlags = GameFontNormal:GetFont()

---------------------------------------------------------------------------------------------------
-- Spell watchers for timers/cooldowns.
local last = 0
function mWarlock:addWatcher(buffName, iconPath, parentSpellIcon, parentSpellName, isUnitPowerDependant, UnitPowerCount, spellID, isDebuff)
    -- Create the watcher frame
    -- If we have a parentSpell, this is cast and goes on cooldown, and the buff is the result 
    -- of casting. If we don't have a buff name, we're tracking the parent spell entirely.
    if not buffName then
        buffName = parentSpellName
    end
    
    local frameName
    if parentSpellIcon then
        frameName = string.format("Frame_%s", parentSpellName)
    else
        frameName = string.format("Frame_%s", buffName)
    end
    
    -- print("Creating watcherFrame now for: %s", frameName)
    local watcher = mWarlock:CreateWatcherFrame(frameName)
    local asButtons = MWarlockSavedVariables["asbuttons"] or false
    watcher.spellName = buffName
    if asButtons then
        watcher:SetAttribute("spell", parentSpellName)
        -- set the button tooltip
        watcher:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Cast ".. parentSpellName)
            GameTooltip:SetSize(80, 50)
            GameTooltip:Show()
        end)
        watcher:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
    end

    -- Swap the icon if we have a parent spell, eg: Power Siphon buffs Demonic Core.
    if parentSpellIcon ~= "" then
        watcher.iconFrame:SetTexture(parentSpellIcon)
    else
        watcher.iconFrame:SetTexture(iconPath)
    end 

    watcher:SetScript("OnUpdate", function(self, elapsed)
        last = last + elapsed
        if last <= .5 then
            return
        end
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

        if isDebuff and not IsMounted() and not MAINFRAME_ISMOVING then
            mWarlock:DoDebuffTimer(parentSpellName, watcher)
        end

        if parentSpellName and not isDebuff and not IsMounted() and not MAINFRAME_ISMOVING then
            -- If we do have a parent spell, if it has a cool down we need to run that cooldown timer.
            mWarlock:DoSpellCooldown(parentSpellName, watcher)
        end

        -- Find any "counts" for buffs, eg Implosion etc
        local found = false
        local count = GetSpellCount(spellID) or 0
        watcher.countText:SetText("")
        if count ~= 0 and not IsMounted() and not MAINFRAME_ISMOVING then
            watcher.countText:Show()
            watcher.countText:SetText(tostring(count))
            -- When we have a count for Summon Soulkeeper this spell can be marked as ready, 
            -- else we hide the ready for that spell.
            if buffName == SUMMONSOULKEEPER_SPELLNAME then
                watcher.readyText:Show()
            end
        elseif MAINFRAME_ISMOVING then
            watcher.countText:Show()
            watcher.countText:SetText("00")
        else
            if buffName == SUMMONSOULKEEPER_SPELLNAME then
                watcher.readyText:Hide()
            end
        end

        if not mWarlock:HasBuff(buffName) and buffName == DEMONICCORE_SPELLNAME and not MAINFRAME_ISMOVING then
            watcher.countText:SetText("")
            watcher.countText:Hide()
        end

        if not MAINFRAME_ISMOVING then 
            for idx = 1, 40 do
                -- local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
                -- spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff("player", idx)
                local name, _, count, _, _, expirationTime, _, _, _,
                _, _, _, _, _, _ = UnitBuff("player", idx)
                
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
            
            if isUnitPowerDependant then
                local unitpower = 0
                if mWarlock:IsWarlock() then
                    unitpower = UnitPower("player", 7)
                else
                    unitpower = UnitPower("player")--, 7)
                end

                -- print("%s is unitPower dependant", buffName)
                -- print("unitpower: %d", unitpower)
                if unitpower == 0 or unitpower < UnitPowerCount then
                    watcher.readyText:SetText(NOSSSTR)
                    watcher.readyText:SetTextColor(1, 0, 0)
                    watcher.movetex:Show()
                    watcher.movetex:SetColorTexture(1, 0, 0, .5)
                else
                    watcher.readyText:SetText(READYSTR)
                    watcher.readyText:SetTextColor(0, 1, 0)
                    watcher.movetex:Hide()
                end
            end
        end
    end)

    watcher:Show()
end
