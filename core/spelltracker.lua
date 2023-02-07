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

defaultW = 45
defaultH = 45
watcherCount = 0
watchers = {}
timerTexts = {}
timerBGs = {}
iconFrames = {}
READYSTR = "RDY"
function addWatcher(buffName, lr, ud, iconPath, parentSpellIcon, parentSpellName, skipBuff, isShardDependant)
    -- Create the watcher frame
    if parentSpellIcon then
        frameName = string.format("Frame_%s", parentSpellName)
    else
        frameName = string.format("Frame_%s", buffName)
    end

    local watcher = CreateFrame("Frame", frameName, MWarlockMainFrame, "BackdropTemplate")
          watcher:SetSize(100, 32)

    local iconFrame = watcher:CreateTexture()
          if parentSpellIcon ~= null then
            iconFrame:SetTexture(parentSpellIcon)
          else
            iconFrame:SetTexture(iconPath)
          end

          iconFrame:SetSize(defaultW, defaultH)
          iconFrame:SetPoint("CENTER", watcher, "CENTER", 0, 0)
          iconFrame:Show()

    local timerBG = watcher:CreateTexture(nil, "BACKGROUND")
          timerBG:SetSize(80, 20)
          timerBG:SetColorTexture(0, 0, 0, 0.5)

    local timerText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          timerText:SetSize(80, 20)
          timerText:SetTextColor(.1, 1, .1)
          timerText:SetText(READYSTR)

    local cooldownText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          cooldownText:SetSize(50, 50)
          cooldownText:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)
          cooldownText:SetText(CD)

    watcher:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

    -- Set the OnUpdate function for the frame
    watcher:SetScript("OnUpdate", function(self, elapsed)
        local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo("player")
        if not HasBuff(buffName) then
            if skipBuff ~= nil then
                timerText:SetText("")
            else
                if buffName ~= summonSoulKeeperSpellName then
                    timerText:SetText("NA")
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
                        -- iconFrame:SetSize(defaultW, defaultH)
                        UIFrameFadeIn(iconFrame, 0, 1, 1, iconFrame:SetSize(defaultW, defaultH))
                    else
                        -- We are still on cooldown
                        if minutes > 0 then
                            cooldownText:SetText(string.format("%d:%d", minutes, seconds))
                        else
                            cooldownText:SetText(string.format("%ds", seconds))
                        end
                        cooldownText:SetTextColor(1, .1, .1)
                        iconFrame:SetAlpha(0.5)
                        if name == nil then
                            UIFrameFadeIn(iconFrame, 1, 0, 1, iconFrame:SetSize(25, 25))
                        end
                    end
                end
            else
                cooldownText:SetText("")
            end
        end

        -- Hide all the background when the timer text = READYSTR
        timerRdy = timerText:GetText()
        if timerRdy == READYSTR then
            timerBG:Show()
        else
            timerBG:Hide()
        end

        for idx = 1, 40 do
            local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
            spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff("player", idx)
            if name == buffName and expirationTime ~= nil then
                -- -- Buff is active
                timerText:Show()
                timerBG:Show()
                local minutes, seconds = GetAuraTimeLeft(expirationTime)
                if minutes > 0 then
                    timerText:SetText(string.format("%d:%d", minutes, seconds))
                else
                    timerText:SetText(string.format("%ds", seconds))
                end
                timerText:SetTextColor(.1, 1, .1)
                iconFrame:SetTexture(iconPath)
                radialButtonLayout()
            end
        end

        if isShardDependant then
            local soulShards = UnitPower("player", 7)
            if soulShards == 0 then
                timerText:SetText("NO SS!")
                timerText:SetTextColor(1, 0, 0)
            end
            if buffName == callDreadStealersSpellName then
                if soulShards < 2 then
                    timerText:SetText("NO SS!")
                    timerText:SetTextColor(1, 0, 0)
                    return
                end
            end
        end

        
    end)
    
    watcherCount = watcherCount +1
    watchers[watcherCount] = watcher
    timerTexts[watcherCount] = timerText
    timerBGs[watcherCount] = timerBG
    iconFrames[watcherCount] = iconFrame
end


function radialButtonLayout()
    radius = MWarlockSavedVariables.radius
    MWarlockMainFrame:SetSize(radius*2, radius*2)
    local angleStep = math.pi / #watchers
    for x = 1, #watchers do
        angle = (x-1)*angleStep + math.pi
        local w = math.cos(angle)*radius
        local h = math.sin(angle)*radius
        watcher = watchers[x]
        timerBg = timerBGs[x]
        timerText = timerTexts[x]
        iconFrame = iconFrames[x]
        timerRdy = timerText:GetText()

        -- Move the watcher around the center of the frame
        watcher:SetPoint("CENTER", MWarlockMainFrame, "CENTER", w, h)
       
        -- Now manage the timers texts so they're center icon when READYSTR and on the bg when ticking
        if timerRdy == READYSTR then
            timerText:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)
            timerBg:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)
        else
            if angle > 1.57 and angle < 4.9 then
                -- left side
                    timerText:SetPoint("CENTER", iconFrame, "RIGHT", 0, 0)
                    timerBg:SetPoint("CENTER", iconFrame, "RIGHT", 0, 0)
            -- Bottom of the circle, we want to keep the text UNDER the icon here
            elseif angle >= 4.711 and angle <= 4.713 then
                timerText:SetPoint("CENTER", iconFrame, "CENTER", 0, -20)
                timerBg:SetPoint("CENTER", iconFrame, "CENTER", 0, -20)
            else
                -- Right side
                    timerText:SetPoint("CENTER", iconFrame, "LEFT", 0, 0)
                    timerBg:SetPoint("CENTER", iconFrame, "LEFT", 0, 0)
            end
        end
    end
end