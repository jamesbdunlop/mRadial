function GetAuraTimeLeft(expirationTime)
    local timeLeft = expirationTime - GetTime()
    local minutes = math.floor(timeLeft / 60)
    local seconds = math.floor(timeLeft - minutes * 60)
    return minutes, seconds
end

local function HasBuff(buffName)
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i)
        if name and name == buffName then
            return true
        end
    end
    return false
end

function addBuffWatcher(buffName, lr, ud, iconPath, parentSpellIcon, parentSpellName, skipBuff, isShardDependant)
    -- Create the watcher frame
    local watcher = CreateFrame("Frame", string.format("Frame_%s", buffName), BuffBGFrame, "BackdropTemplate")
          watcher:SetSize(100, 100)
          watcher:SetPoint("BOTTOMLEFT")
          
          local iconFrame = watcher:CreateTexture()
          if parentSpellIcon ~= null then
            iconFrame:SetTexture(parentSpellIcon)
          else
            iconFrame:SetTexture(iconPath)
          end

          iconFrame:SetSize(32, 32)
          iconFrame:SetPoint("CENTER", lr-32, ud)
          iconFrame:Show()
    
    local timerText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          timerText:SetSize(100, 50)
          timerText:SetPoint("CENTER", watcher, "RIGHT", lr-40, ud)
          timerText:SetTextColor(.1, 1, .1)

    local cooldownText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          cooldownText:SetSize(50, 50)
          cooldownText:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)
          cooldownText:SetText(CD)

    -- frame movement
    -- TO DO, set this script so I can move these where ever and then reparent in situ to the main BuffBGFrame
    -- watcher:EnableMouse(true)
    -- watcher:SetMovable(true)
    -- watcher:RegisterForDrag("LeftButton")
    -- watcher:SetScript("OnDragStart", function(self) self:StartMoving() end)
    -- watcher:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    watcher:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

    -- Set the OnUpdate function for the frame
    watcher:SetScript("OnUpdate", function(self, elapsed)
        if isShardDependant then
            local soulShards = UnitPower("player", 7)
            if soulShards == 0 then
                timerText:SetText("NO SS!")
                timerText:SetTextColor(1, 0, 0)
                return
            end
            if buffName == callDreadStealersSpellName then
                if soulShards < 2 then
                    timerText:SetText("NO SS!")
                    timerText:SetTextColor(1, 0, 0)
                    return
                end
            end
        end

        -- Range check
        local inRange = IsItemInRange(buffName, "target")
        if inRange ~= nil then
            print("IN RANGE")
        end

        if not HasBuff(buffName)then
            if skipBuff ~= nil then
                timerText:SetText("")
            else
                timerText:SetText("N/A")
                timerText:SetTextColor(1, .1, .1)
            end
            
            if parentSpellIcon ~= nil then
                iconFrame:SetTexture(parentSpellIcon)
            else
                iconFrame:SetTexture(iconPath)
            end
        
            -- COOLDOWNS FOR PARENT SPELLS.. eg power siphon
            if parentSpellName ~= nil then
                local start, duration, enable = GetSpellCooldown(parentSpellName)
                if enable then
                    local remaining = start + duration - GetTime()
                    local minutes = math.floor(remaining / 60)
                    local seconds = math.floor(remaining - minutes * 60)

                    if remaining < 0 then
                        cooldownText:SetText("")
                        iconFrame:SetAlpha(1)
                        timerText:SetText("READY")
                        timerText:SetTextColor(.1, 1, .1)
                    else
                        if minutes >0 then
                            cooldownText:SetText(string.format("%dm%d", minutes, seconds))
                        else
                            cooldownText:SetText(string.format("%ds", seconds))
                        end
                        cooldownText:SetTextColor(1, .1, .1)
                        iconFrame:SetAlpha(0.5)
                    end
                end
            else
                cooldownText:SetText("")
            end
        else
            for idx = 1, 40 do
                local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
                spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff("player", idx)
                if name == buffName and expirationTime ~= nil then
                    -- -- Buff is active
                    -- if expirationTime == nil then
                    --     watcher:Hide() 
                    --     watcher:SetParent(nil)
                    --     timerText:SetText("")
                    --     timerText:Hide()
                    --     timerText:SetParent(nil)
                    --     return
                    -- end
                    local minutes, seconds = GetAuraTimeLeft(expirationTime)
                    if minutes >0 then
                        timerText:SetText(string.format("%dm%d", minutes, seconds))
                    else
                        timerText:SetText(string.format("%ds", seconds))
                    end
                    timerText:SetTextColor(.1, 1, .1)
                    iconFrame:SetTexture(iconPath)  
                end
            end
        end
    end)
end