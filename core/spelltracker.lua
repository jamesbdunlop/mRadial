-- Some globals
local fontName, fontHeight, fontFlags = GameFontNormal:GetFont()

---------------------------------------------------------------------------------------------------
-- Spell watchers for timers/cooldowns.
local last = 0
function mWarlock:addWatcherFrame(spellID)
    -- Create the watcher frame
    -- If we have a parentSpell, this is cast and goes on cooldown, and the buff is the result 
    -- of casting. If we don't have a buff name, we're tracking the parent spell entirely.

    -- spellName, rank, iconPath, castTime, minRange, maxRange, spellID, originalSpellIcon = 
    local spellName, _, iconPath, _, _, _, spellID, _ = GetSpellInfo(spellID)
    local frameName = string.format("Frame_%s", spellName)

    local watcher = mWarlock:CreateRadialWatcherFrame(frameName, spellName, iconPath)
    watcher.spellName = spellName
    ------------------------------------------
    -- SPELL INFORMATION TO USE FOR TIMERS ETC
    local isUnitPowerDependant, UnitPowerCount = mWarlock:IsSpellUnitPowerDependant(spellID)
    -- local overrideSpellID = C_SpellBook.GetOverrideSpell(spellID)
    -- local pSpellName, _, pIconPath, _, pMinRange, pMaxRange, _, _ = GetSpellInfo(overrideSpellID)
    -- local disabled = C_SpellBook.IsSpellDisabled(spellID)

    ----------------------------------------------
    -- Assign the spell to cast if we're a button!
    local asButtons = MWarlockSavedVariables["asbuttons"] or false
    if asButtons then
        watcher:SetAttribute("spell", spellName)
        -- set the button tooltip
        watcher:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Cast ".. spellName)
            GameTooltip:SetSize(80, 50)
            GameTooltip:Show()
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
                if mWarlock:IsWarlock() then
                    unitpower = UnitPower("player", 7) -- soul shards
                else
                    unitpower = UnitPower("player") -- hopefully the rest list insanity etc
                end
    
                if unitpower == 0 or unitpower < UnitPowerCount then
                    watcher.readyText:SetText(NOSSSTR)
                    watcher.readyText:SetTextColor(1, 0, 0)
                    watcher.movetex:SetColorTexture(1, 0, 0, .5)
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
            mWarlock:DoDebuffTimer(spellName, watcher)
            mWarlock:DoSpellFrameCooldown(spellName, watcher)
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
                mWarlock:DoBuffTimer(linkedSpellName, watcher, linkedIconPath)
                
                if mWarlock:HasActiveBuff(linkedSpellName) and not IsMounted() then
                    watcher.aura:Show()
                    -- watcher.aura:SetColorTexture(0, 1, 0, 1)
                else
                    watcher.aura:Hide()
                end
            else
                mWarlock:DoBuffTimer(spellName, watcher, iconPath)
                watcher.aura:Hide()
            end

            -- Now set the count on the frame regardless.
            local count = 0
            if getLinked ~= nil then
                local linkedSpellName = getLinked[1] 
                local linkedSpellID = getLinked[2]
                local hasActiveBuff, scount = mWarlock:HasActiveBuff(linkedSpellName)
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

end
