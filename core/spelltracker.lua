-- Some globals
watcherCount = 0
watchers = {}
buffTimerTexts = {}
buffTimerTextBGs = {}
iconFrames = {}
countFrames = {}
coolDownFrames = {}
readyFrames = {}

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

---------------------------------------------------------------------------------------------------
-- Spell watchers for timers/cooldowns.
READYTEXT = "RDY"

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
          iconFrame:SetPoint("CENTER", watcher, "CENTER", 0, 0)
          iconFrame:AddMaskTexture(watcher.mask)

    local countFontSize = MWarlockSavedVariables.countFontSize or 12
    local countText = watcher:CreateFontString(nil, "OVERLAY", "GameFontNormal")
          countText:SetTextColor(0, 1, 1)
          countText:SetPoint("CENTER", iconFrame, "TOP", 00, -15)
          
    local buffTimerTextBG = watcher:CreateTexture(nil, "BACKGROUND")
          buffTimerTextBG:SetColorTexture(0, .25, 0, 1)

    local buffTimerText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          buffTimerText:SetTextColor(.1, 1, .1)
          buffTimerText:SetText(READYSTR)
    
    local cooldownText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          cooldownText:SetText(CD)
          cooldownText:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)

    local readyText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          readyText:SetText(READYSTR)
          readyText:SetPoint("CENTER", watcher, "CENTER", 0, -10)
          readyText:SetTextColor(.1, 1, .1)

    -- Set the OnUpdate function for the frame
    watcher:SetScript("OnUpdate", function(self, elapsed)
        if IsMounted() then
            watcher:Hide()
            watcher.tex:Hide()
            iconFrame:Hide()
            readyText:Hide()
            countText:Hide()
            cooldownText:Hide()
        else
            watcher:Show()
            watcher.tex:Show()
            readyText:Show()
            iconFrame:Show()
            countText:Show()
            cooldownText:Show()
        end

        if parentSpellName ~= nil then
            iconFrame:SetTexture(parentSpellIcon)
        else
            iconFrame:SetTexture(iconPath)
        end 

        if parentSpellName ~= nil and not IsMounted() then
            -- COOLDOWNS FOR PARENT SPELLS
            local start, duration, enabled, modRate = GetSpellCooldown(parentSpellName)
            local remaining = start + duration - GetTime()
            local minutes = math.floor(remaining / 60)
            local seconds = math.floor(remaining - minutes * 60)
            if enabled ~= nil and remaining > 0 then
                cooldownText:Show()
                readyText:Hide()
                if minutes ~= nil and minutes > 0 then
                    cooldownText:SetText(string.format("%d:%d", minutes, seconds))
                else
                    cooldownText:SetText(string.format("%ds", seconds))
                end
                cooldownText:SetTextColor(1, .1, .1)
                iconFrame:SetAlpha(0.5)
            else
                cooldownText:Hide()
                iconFrame:SetAlpha(1)
                if not IsMounted() then
                    readyText:Show()
                end
            end
        end

        -- All other buff timers
        found = false
        local count = GetSpellCount(spellID)
        if count ~= 0 and not IsMounted() then
            countText:Show()
            countText:SetText(tostring(count))
            if buffName == summonSoulKeeperSpellName then
                readyText:Show()
            end
        else
            if buffName == summonSoulKeeperSpellName then
                readyText:Hide()
            end
        end

        for idx = 1, 40 do
            local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal,
            spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitBuff("player", idx)
            if name == buffName then
                if count ~= nil and count > 1 and expirationTime ~= nil then
                    countText:Show()
                    countText:SetText(tostring(count))
                else
                    countText:Hide()
                end
            end
            
            -- TIMERS
            if name ~= nil and name == buffName and expirationTime ~= nil then
                -- Buff is active -- 
                found = true
                buffTimerText:Show()
                buffTimerTextBG:Show()
                buffTimerText:SetTextColor(.1, 1, .1)
                buffTimerTextBG:SetTexture(iconPath)
                
                local minutes, seconds =  mWarlock:GetAuraTimeLeft(expirationTime)
                if minutes~= nil and minutes > 0 then
                    buffTimerText:SetText(string.format("%d:%d", minutes, seconds))
                elseif seconds > 0 then
                    buffTimerText:SetText(string.format("%ds", seconds))
                else
                    buffTimerText:Hide()
                    buffTimerTextBG:Hide()
                end
            end
        end
        if not found then
            buffTimerText:Hide()
            buffTimerTextBG:Hide()
        end
        if isShardDependant then
            local soulShards = UnitPower("player", 7)
            if soulShards == 0 then
                readyText:SetText(NOSSSTR)
                readyText:SetTextColor(1, 0, 0)
            else
                readyText:SetText(READYSTR)
                readyText:SetTextColor(0, 1, 0)
            end
            
            if buffName == callDreadStealersSpellName and soulShards < 2 then
                readyText:SetText(NOSSSTR)
                readyText:SetTextColor(1, 0, 0)
            else
                readyText:SetText(READYSTR)
                readyText:SetTextColor(0, 1, 0)
            end
        end
        mWarlock:radialButtonLayout()
    end)
    
    -- Now stores all these frames into tables for laying out in the radial fashion
    watcherCount = watcherCount+1
    watchers[watcherCount] = watcher
    buffTimerTexts[watcherCount] = buffTimerText
    buffTimerTextBGs[watcherCount] = buffTimerTextBG
    iconFrames[watcherCount] = iconFrame
    countFrames[watcherCount] = countText
    coolDownFrames[watcherCount] = cooldownText
    readyFrames[watcherCount] = readyText
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
    local countFontSize = MWarlockSavedVariables.countFontSize or 12
    local readyFontSize = MWarlockSavedVariables.readyFontSize or 12
    local coolDownFontSize = MWarlockSavedVariables.coolDownFontSize or 12
    MWarlockMainFrame:SetSize(radius*2, radius*2)

    local watcherFrameSize = MWarlockSavedVariables.watcherFrameSize or 55
    local defIconSize = watcherFrameSize*1.2

    local angleStep = math.pi / #watchers +spread
    for x = 1, #watchers do
        angle = (x-1)*angleStep + offset*math.pi
        local sinAng = math.sin(angle)
        local cosAng = math.cos(angle)
        local w = cosAng*radius
        local h = sinAng*radius
        watcher = watchers[x]
        watcher:SetSize(watcherFrameSize, watcherFrameSize)

        buffTimerTextBG = buffTimerTextBGs[x]
        buffTimerTextBG:SetSize(watcherFrameSize/1.5, watcherFrameSize/1.5)
        
        buffTimerText = buffTimerTexts[x]
        buffTimerText:SetSize(watcherFrameSize*1.25, watcherFrameSize)
        buffTimerText:SetFont(customFontPath, countFontSize, "OUTLINE, MONOCHROME")

        iconFrame = iconFrames[x]
        iconFrame:SetSize(watcherFrameSize*1.25, watcherFrameSize*1.25)

        countText = countFrames[x]
        countText:SetFont(customFontPath, countFontSize, "THICKOUTLINE")
        
        cooldownText = coolDownFrames[x]
        cooldownText:SetFont(customFontPath, coolDownFontSize, "THICKOUTLINE")
        
        readyText = readyFrames[x]
        readyText:SetFont(customFontPath, readyFontSize, "THICKOUTLINE")
        timerRdy = buffTimerText:GetText()
        -- Move the watcher around the center of the frame
        watcher:Show()
        watcher:SetPoint("CENTER", MWarlockMainFrame, "CENTER", w, h)
       
        -- Now manage the timers texts so they're center icon when 
        -- READYSTR and on the bg when ticking
        -- We don't do ANY SHOW HIDE HERE!!
        radialUDOffset = -10
        radialLROffset = -10
        buffTimerText:SetPoint("CENTER", buffTimerTextBG, "CENTER", 0, 0)
        if cosAng <= 0 and timerRdy ~= READYSTR then
            buffTimerTextBG:SetPoint("CENTER", iconFrame, "LEFT", radialLROffset, radialUDOffset)
        
        elseif cosAng == 0 and timerRdy ~= READYSTR then
            -- Bottom of the circle, we want to keep the text UNDER the icon here
            buffTimerTextBG:SetPoint("CENTER", iconFrame, "CENTER", 0, radialUDOffset)

        elseif timerRdy ~= READYSTR then
            buffTimerTextBG:SetPoint("CENTER", iconFrame, "RIGHT", radialLROffset*-1, radialUDOffset)
        end
    end
end
---------------------------------------------------------------------------------------------------