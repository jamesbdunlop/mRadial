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

    local countText = watcher:CreateFontString(nil, "OVERLAY", "GameFontNormal")
          countText:SetSize(150, 150)
          countText:SetTextColor(0, 1, 1)
          countText:SetPoint("CENTER", iconFrame, "TOP", 0, 8)
          countText:SetFont("Fonts\\FRIZQT__.TTF", 25, "OUTLINE, MONOCHROME")
          
    local buffTimerTextBG = watcher:CreateTexture(nil, "BACKGROUND")
          buffTimerTextBG:SetSize(watcherFrameWidth/1.5, watcherFrameHeight/1.5)
          buffTimerTextBG:SetColorTexture(0, .25, 0, 1)

    local buffTimerText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          buffTimerText:SetSize(watcherFrameWidth*1.25, watcherFrameHeight)
          buffTimerText:SetTextColor(.1, 1, .1)
          buffTimerText:SetText(READYSTR)
          buffTimerText:SetFont("Fonts\\FRIZQT__.TTF", watcherFrameWidth/2, "OUTLINE, MONOCHROME")
    
    local cooldownText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          cooldownText:SetText(CD)
          cooldownText:SetAllPoints(watcher)
          cooldownText:SetFont("Fonts\\FRIZQT__.TTF", watcherFrameWidth/2, "OUTLINE, MONOCHROME")

    local readyText = watcher:CreateFontString(nil, "ARTWORK", "GameFontNormal")
          readyText:SetText(READYSTR)
          readyText:SetAllPoints(watcher)
          readyText:SetFont("Fonts\\FRIZQT__.TTF", watcherFrameWidth/3, "OUTLINE, MONOCHROME")
          readyText:SetTextColor(.1, 1, .1)

    -- Set the OnUpdate function for the frame
    watcher:SetScript("OnUpdate", function(self, elapsed)
        if parentSpellName ~= nil then
            iconFrame:SetTexture(parentSpellIcon)
        else
            iconFrame:SetTexture(iconPath)
        end 
        countText:Hide()
        if parentSpellName ~= nil then
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
                iconFrame:SetSize(25, 25)
            else
                cooldownText:Hide()
                iconFrame:SetAlpha(1)
                iconFrame:SetSize(defIconWidth, defIconHeight)
                readyText:Show()
            end
        end

        -- All other buff timers
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
            if name == buffName and expirationTime ~= nil then
                -- Buff is active -- 
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

        if isShardDependant then
            local soulShards = UnitPower("player", 7)
            if soulShards == 0 then
                readyText:SetText(NOSSSTR)
                readyText:SetTextColor(1, 0, 0)
                readyText:SetPoint("TOP", iconFrame, "TOP", 0, 0)
            end
            
            if buffName == callDreadStealersSpellName and soulShards < 2 then
                readyText:SetText(NOSSSTR)
                readyText:SetTextColor(1, 0, 0)
                readyText:SetPoint("TOP", iconFrame, "TOP", 0, 0)
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
        radialUDOffset = -10
        radialLROffset = -30
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