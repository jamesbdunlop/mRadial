-- Some globals
defaultW = 45
defaultH = 45
watcherCount = 0
watchers = {}
timerTexts = {}
timerTextBGs = {}
iconFrames = {}
READYSTR = "RDY"
NOSSSTR = "N0 SS!"

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

function addWatcher(buffName, lr, ud, iconPath, parentSpellIcon, parentSpellName, skipBuff, isShardDependant)
    -- Create the watcher frame
    frameName = string.format("Frame_%s", buffName)
    if parentSpellIcon then
        frameName = string.format("Frame_%s", parentSpellName)
    end

    local watcher = CreateFrame("Frame", frameName, MWarlockMainFrame, "BackdropTemplate")
          watcher:SetSize(100, 100)
        --   watcher:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

    local iconFrame = watcher:CreateTexture(nil, "ARTWORK")
          iconFrame:SetTexture(iconPath)
          if parentSpellIcon ~= null then
            iconFrame:SetTexture(parentSpellIcon)
          end
          iconFrame:SetSize(defaultW, defaultH)
          iconFrame:SetPoint("CENTER", watcher, "CENTER", 0, 0)

    local timerTextBG = watcher:CreateTexture(nil, "BACKGROUND")
          timerTextBG:SetSize(30, 20)
          timerTextBG:SetColorTexture(0, 0, 0, 1)

    local timerText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          timerText:SetSize(80, 20)
          timerText:SetTextColor(.1, 1, .1)
          timerText:SetText(READYSTR)

    local cooldownText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          cooldownText:SetSize(50, 50)
          cooldownText:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)
          cooldownText:SetText(CD)

    -- Set the OnUpdate function for the frame
    
    watcher:SetScript("OnUpdate", function(self, elapsed)
        local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo("player")
        if not HasBuff(buffName) then
            if skipBuff ~= nil then
                timerText:SetText("")
            else
                if buffName ~= summonSoulKeeperSpellName then
                    timerText:SetText("")
                    timerText:SetTextColor(1, .1, .1)
                end
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

                    -- Cooldown is finished
                    if remaining < 1.5 then
                        cooldownText:SetText("")
                        iconFrame:SetAlpha(1)
                        timerText:SetText(READYSTR)
                        timerText:SetTextColor(.1, 1, .1)
                        iconFrame:SetSize(defaultW, defaultH)
                    else
                        -- We are still on cooldown
                        if minutes > 0 then
                            cooldownText:SetText(string.format("%d:%d", minutes, seconds))
                        else
                            cooldownText:SetText(string.format("%ds", seconds))
                        end
                        cooldownText:SetTextColor(1, .1, .1)
                        iconFrame:SetAlpha(0.5)
                        iconFrame:SetSize(25, 25)
                    end
                end
            else
                cooldownText:SetText("")
            end
        end

        for idx = 1, 40 do
            local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
            spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff("player", idx)
            if name == buffName and expirationTime ~= nil then
                -- Buff is active -- 
                timerText:Show()
                timerTextBG:Show()
                radialButtonLayout()

                local minutes, seconds = GetAuraTimeLeft(expirationTime)
                if minutes > 0 then
                    timerText:SetText(string.format("%d:%d", minutes, seconds))
                else
                    timerText:SetText(string.format("%ds", seconds))
                end
                timerText:SetTextColor(.1, 1, .1)
                iconFrame:SetTexture(iconPath)
            else
                timerTextBG:Hide()
            end
        end

        -- Hide the timer background when the timer text = READYSTR
        timerRdy = timerText:GetText()
        if timerRdy == READYSTR or not timerRdy then
            timerText:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)
            timerTextBG:Hide()
        elseif timerRdy == NOSSSTR then
            radialButtonLayout()
            timerTextBG:Show()
        else
            timerTextBG:Show()
        end

        if isShardDependant then
            local soulShards = UnitPower("player", 7)
            if soulShards == 0 then
                timerText:SetText(NOSSSTR)
                timerText:SetTextColor(1, 0, 0)
            end

            if buffName == callDreadStealersSpellName and soulShards < 2 then
                timerText:SetText(NOSSSTR)
                timerText:SetTextColor(1, 0, 0)
            end
        end
    end)
    
    -- Now stores all these frames into tables for laying out in the radial fashion
    watcherCount = watcherCount+1
    watchers[watcherCount] = watcher
    timerTexts[watcherCount] = timerText
    timerTextBGs[watcherCount] = timerTextBG
    iconFrames[watcherCount] = iconFrame
    
end

function radialButtonLayout()
    --- Handles adding the frames around a unit circle cause I like it better this way....
    radius = MWarlockSavedVariables.radius
    MWarlockMainFrame:SetSize(radius*2, radius*2)
    local angleStep = math.pi / #watchers
    for x = 1, #watchers do
        angle = (x-1)*angleStep + math.pi
        local w = math.cos(angle)*radius
        local h = math.sin(angle)*radius
        watcher = watchers[x]
        timerTextBG = timerTextBGs[x]
        timerText = timerTexts[x]
        iconFrame = iconFrames[x]
        timerRdy = timerText:GetText()
        -- Move the watcher around the center of the frame
        watcher:Show()
        watcher:SetPoint("CENTER", MWarlockMainFrame, "CENTER", w, h)
       
        -- Now manage the timers texts so they're center icon when READYSTR and on the bg when ticking
        -- We don't do ANY SHOW HIDE HERE!!
        if angle > 1.57 and angle <  4.9 and timerRdy ~= READYSTR then
            -- left side
            timerText:SetPoint("CENTER", iconFrame, "LEFT", -20, 0)
            timerTextBG:SetPoint("RIGHT", iconFrame, "LEFT", 0, 0)
        
        elseif angle >= 4.711 and angle <= 4.713 and timerRdy ~= READYSTR then
            -- Bottom of the circle, we want to keep the text UNDER the icon here
            timerText:SetPoint("CENTER", iconFrame, "CENTER", 0, -20)
            timerTextBG:SetPoint("CENTER", iconFrame, "CENTER", 0, -20)

        elseif timerRdy ~= READYSTR then
            timerText:SetPoint("CENTER", iconFrame, "RIGHT", 20, 0)
            timerTextBG:SetPoint("LEFT", iconFrame, "RIGHT", 20, 0)
        end
    end
end