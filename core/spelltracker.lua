-- Some globals
local watcherFrameWidth = 45
local watcherFrameHeight = 45
local defIconWidth = watcherFrameWidth*1.2
local defIconHeight = watcherFrameHeight*1.2
watcherCount = 0
watchers = {}
buffTimerTexts = {}
buffTimerTextBGs = {}
iconFrames = {}
READYSTR = "RDY"
NOSSSTR = "N0 SS!"
---------------------------------------------------------------------------------------------------
-- UTILS
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
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Spell watchers for timers/cooldowns.
function mWarlock:addWatcher(buffName, iconPath, parentSpellIcon, parentSpellName, skipBuff, isShardDependant, spellID)
    -- Create the watcher frame
    if buffName == nil and parentSpellName ~= nil then
        buffName = parentSpellName
    end
    
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

    local countText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          countText:SetSize(50, 50)
          countText:SetTextColor(.1, 1, 1)
          countText:SetText("")
          countText:SetPoint("TOP", iconFrame, "BOTTOM", 0, 20)
          countText:Show()

    
          local buffTimerTextBG = watcher:CreateTexture(nil, "BACKGROUND")
          buffTimerTextBG:SetSize(watcherFrameWidth/2, watcherFrameHeight/1.5)
          buffTimerTextBG:SetColorTexture(0, .25, 0, 1)

    local buffTimerText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          buffTimerText:SetSize(watcherFrameWidth, watcherFrameHeight)
          buffTimerText:SetTextColor(.1, 1, .1)
          buffTimerText:SetText(READYSTR)

    
    local cooldownText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          cooldownText:SetText(CD)
          cooldownText:SetAllPoints(watcher)

    -- Set the OnUpdate function for the frame
    
    watcher:SetScript("OnUpdate", function(self, elapsed)
        -- Don't display any timers for anything set to skip a buff timer.
        if skipBuff ~= nil then
            buffTimerText:SetText("")
        end
        
        local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo("player")
        -- if buffName ~= summonSoulKeeperSpellName then
        --     -- Summon soul keep 
        --     buffTimerText:SetText("")
        --     buffTimerText:SetTextColor(1, .1, .1)
        -- end
                    
        if parentSpellIcon ~= nil then
            -- COOLDOWNS FOR PARENT SPELLS.. eg power siphon
            iconFrame:SetTexture(parentSpellIcon)
            local start, duration, enable = GetSpellCooldown(parentSpellName)
            if enable then
                local remaining = start + duration - GetTime()
                local minutes = math.floor(remaining / 60)
                local seconds = math.floor(remaining - minutes * 60)

                -- Cooldown is finished
                if remaining < 1.5 then
                    cooldownText:SetText("")
                    iconFrame:SetAlpha(1)
                    buffTimerText:SetText(READYSTR)
                    buffTimerText:SetTextColor(.1, 1, .1)
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
            iconFrame:SetTexture(iconPath)
        end

        -- All other buff timers
        for idx = 1, 40 do
            local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
            spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff("player", idx)
            if name == buffName then
                if count ~= nil and count > 1 then
                    countText:Show()
                    countText:SetText(tostring(count))
                else
                    countText:Hide()
                    countText:SetText("")
                end
            end
                
            -- TIMERS
            if name == buffName and expirationTime ~= nil then
                -- Buff is active -- 
                buffTimerText:Show()
                buffTimerTextBG:Show()
                
                mWarlock:radialButtonLayout()
                local minutes, seconds =  mWarlock:GetAuraTimeLeft(expirationTime)
                if minutes > 0 then
                    buffTimerText:SetText(string.format("%d:%d", minutes, seconds))
                else
                    buffTimerText:SetText(string.format("%ds", seconds))
                end
                buffTimerText:SetTextColor(.1, 1, .1)
                iconFrame:SetTexture(iconPath)
            else
                buffTimerTextBG:Hide()
            end
        end

        -- Hide the timer background when the timer text = READYSTR
        timerRdy = buffTimerText:GetText()
        if timerRdy == READYSTR or not timerRdy then
            buffTimerText:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)
            buffTimerTextBG:Hide()
        elseif timerRdy == NOSSSTR then
            mWarlock:radialButtonLayout()
            buffTimerTextBG:Show()
        else
            buffTimerTextBG:Show()
        end

        if isShardDependant then
            local soulShards = UnitPower("player", 7)
            if soulShards == 0 then
                buffTimerText:SetText(NOSSSTR)
                buffTimerText:SetTextColor(1, 0, 0)
                buffTimerText:SetPoint("TOP", iconFrame, "TOP", 0, 0)
            end
            
            if buffName == callDreadStealersSpellName and soulShards < 2 then
                buffTimerText:SetText(NOSSSTR)
                buffTimerText:SetTextColor(1, 0, 0)
                buffTimerText:SetPoint("TOP", iconFrame, "TOP", 0, 0)
            end
        end
    end)
    
    -- Now stores all these frames into tables for laying out in the radial fashion
    watcherCount = watcherCount+1
    watchers[watcherCount] = watcher
    buffTimerTexts[watcherCount] = buffTimerText
    buffTimerTextBGs[watcherCount] = buffTimerTextBG
    iconFrames[watcherCount] = iconFrame
    
end

---------------------------------------------------------------------------------------------------
-- Watcher radial layout.
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
        buffTimerTextBG = buffTimerTextBGs[x]
        buffTimerText = buffTimerTexts[x]
        iconFrame = iconFrames[x]
        timerRdy = buffTimerText:GetText()
        -- Move the watcher around the center of the frame
        watcher:Show()
        watcher:SetPoint("CENTER", MWarlockMainFrame, "CENTER", w, h)
       
        -- Now manage the timers texts so they're center icon when 
        -- READYSTR and on the bg when ticking
        -- We don't do ANY SHOW HIDE HERE!!
        if cosAng <= 0 and timerRdy ~= READYSTR then
            buffTimerTextBG:SetPoint("RIGHT", iconFrame, "LEFT", 0, 0)
            buffTimerText:SetPoint("CENTER", buffTimerTextBG, "LEFT", 0, 0)
        
        elseif cosAng == 0 and timerRdy ~= READYSTR then
            -- Bottom of the circle, we want to keep the text UNDER the icon here
            buffTimerTextBG:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)
            buffTimerText:SetPoint("CENTER", buffTimerTextBG, "CENTER", 0, 0)

        elseif timerRdy ~= READYSTR then
            buffTimerTextBG:SetPoint("LEFT", iconFrame, "RIGHT", 0, 0)
            buffTimerText:SetPoint("CENTER", buffTimerTextBG, "RIGHT", 0, 0)
        end
    end
end
---------------------------------------------------------------------------------------------------