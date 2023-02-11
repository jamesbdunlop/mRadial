-- Some globals
local watcherFrameWidth = 45
local watcherFrameHeight = 45
local defIconWidth = watcherFrameWidth*1.2
local defIconHeight = watcherFrameHeight*1.2
watcherCount = 0
watchers = {}
timerTexts = {}
timerTextBGs = {}
iconFrames = {}
READYSTR = "RDY"
NOSSSTR = "N0 SS!"

function mWarlock:GetAuraTimeLeft(expirationTime)
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

function mWarlock:addWatcher(buffName, iconPath, parentSpellIcon, parentSpellName, skipBuff, isShardDependant)
    -- Create the watcher frame
    frameName = string.format("Frame_%s", buffName)
    if parentSpellIcon then
        frameName = string.format("Frame_%s", parentSpellName)
    end

    local watcher = CreateFrame("Frame", frameName, MWarlockMainFrame, "BackdropTemplate")
          watcher:SetSize(watcherFrameWidth, watcherFrameHeight)
          
          watcher.tex = watcher:CreateTexture(nil, "BACKGROUND")
          watcher.tex:SetAllPoints(watcher)
          watcher.tex:SetTexture("Interface/Tooltips/UI-Tooltip-Background")
          watcher.tex:SetColorTexture(0, 0, 0, 1)

          watcher.mask = watcher:CreateMaskTexture("testMask")
          watcher.mask:SetAllPoints(watcher.tex)
          watcher.mask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
          
          watcher.tex:AddMaskTexture(watcher.mask)

    local iconFrame = watcher:CreateTexture(nil, "ARTWORK")
          iconFrame:SetTexture(iconPath)
          if parentSpellIcon ~= null then
            iconFrame:SetTexture(parentSpellIcon)
          end
          iconFrame:SetSize(defIconWidth, defIconHeight)
          iconFrame:SetPoint("CENTER", watcher, "CENTER", 0, 0)
          iconFrame:AddMaskTexture(watcher.mask)


    local timerTextBG = watcher:CreateTexture(nil, "BACKGROUND")
          timerTextBG:SetSize(watcherFrameWidth/1.5, watcherFrameHeight/2)
          timerTextBG:SetColorTexture(0, .25, 0, 1)

    local timerText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          timerText:SetSize(watcherFrameWidth, watcherFrameHeight)
          timerText:SetTextColor(.1, 1, .1)
          timerText:SetText(READYSTR)

    local cooldownText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          cooldownText:SetText(CD)
          cooldownText:SetAllPoints(watcher)

    -- Set the OnUpdate function for the frame
    
    watcher:SetScript("OnUpdate", function(self, elapsed)
        local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo("player")
        if not  mWarlock:HasBuff(buffName) then
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
                        iconFrame:SetSize(defIconWidth, defIconHeight)
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
                mWarlock:radialButtonLayout()

                local minutes, seconds =  mWarlock:GetAuraTimeLeft(expirationTime)
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
            mWarlock:radialButtonLayout()
            timerTextBG:Show()
        else
            timerTextBG:Show()
        end

        if isShardDependant then
            local soulShards = UnitPower("player", 7)
            if soulShards == 0 then
                timerText:SetText(NOSSSTR)
                timerText:SetTextColor(1, 0, 0)
                timerText:SetPoint("TOP", iconFrame, "TOP", 0, 0)
            end
            
            if buffName == callDreadStealersSpellName and soulShards < 2 then
                timerText:SetText(NOSSSTR)
                timerText:SetTextColor(1, 0, 0)
                timerText:SetPoint("TOP", iconFrame, "TOP", 0, 0)
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

function mWarlock:radialButtonLayout()
    --- Handles adding the frames around a unit circle cause I like it better this way....
    local radius = MWarlockSavedVariables.radius
    local offset = MWarlockSavedVariables.offset
    MWarlockMainFrame:SetSize(radius*2, radius*2)

    local angleStep = math.pi / #watchers 
    for x = 1, #watchers do
        angle = (x-1)*angleStep + offset*math.pi
        local sinAng = math.sin(angle)
        local cosAng = math.cos(angle)
        local w = cosAng*radius
        local h = sinAng*radius
        watcher = watchers[x]
        timerTextBG = timerTextBGs[x]
        timerText = timerTexts[x]
        iconFrame = iconFrames[x]
        timerRdy = timerText:GetText()
        -- Move the watcher around the center of the frame
        watcher:Show()
        watcher:SetPoint("CENTER", MWarlockMainFrame, "CENTER", w, h)
       
        -- Now manage the timers texts so they're center icon when 
        -- READYSTR and on the bg when ticking
        -- We don't do ANY SHOW HIDE HERE!!
        if cosAng <= 0 and timerRdy ~= READYSTR then
            timerText:SetPoint("CENTER", iconFrame, "LEFT", -20, -20)
            timerTextBG:SetPoint("RIGHT", iconFrame, "LEFT", 0, -20)
        
        elseif cosAng == 0 and timerRdy ~= READYSTR then
            -- Bottom of the circle, we want to keep the text UNDER the icon here
            timerText:SetPoint("CENTER", iconFrame, "CENTER", 0, -20)
            timerTextBG:SetPoint("CENTER", iconFrame, "CENTER", 0, -20)

        elseif timerRdy ~= READYSTR then
            timerText:SetPoint("CENTER", iconFrame, "RIGHT", 20, -20)
            timerTextBG:SetPoint("LEFT", iconFrame, "RIGHT", 0, -20)
        end
    end
end