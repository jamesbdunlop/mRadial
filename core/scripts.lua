function mRadial:SetMoveFrameScripts(frame)
    frame:SetScript("OnMouseDown", function(self, button)
        if not frame:IsMovable() or not frame:IsMouseEnabled() then
            return
        end

        if IsShiftKeyDown() and button == "LeftButton" then
            frame:StartMoving()
        end
    end)

    frame:SetScript("OnMouseUp", function(self, button)
        frame:StopMovingOrSizing()
        local playerName = UnitName("player")
        local playerSpec = GetSpecialization()
        local frameCache = PerPlayerPerSpecSavedVars[playerName][playerSpec]["framePositions"]
        local frameName = frame:GetName()
        local point, relativeTo, relativePoint, offsetX, offsetY = frame:GetPoint()
        frameCache[frameName] = {}
        frameCache[frameName]["point"] = point
        frameCache[frameName]["relativeTo"] = "UIParent"
        frameCache[frameName]["relativePoint"] = relativePoint
        frameCache[frameName]["x"] = offsetX
        frameCache[frameName]["y"] = offsetY
        frameCache[frameName]["sx"] = frame:GetWidth()
        frameCache[frameName]["sy"] = frame:GetHeight()
    end)
end

function mRadial:SetMountedFrameScripts(frame, alpha)
    frame:GetParent():RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:GetParent():SetScript("OnEvent", function(self, event, ...)
        -- Show the frame when entering combat
        if event == "PLAYER_REGEN_DISABLED" then
            mRadial:SetFrameVisibility(frame)
        end
    end)

    frame:GetParent():SetScript("OnUpdate", function(self, elapsed)
        mRadial:SetFrameVisibility(frame)
    end)
end

local plast = 0
function mRadial:SetPetFrameScripts(frame, spellName)
    frame:SetScript("OnUpdate", function(self, elapsed)
        plast = plast + elapsed
        if plast <= MR_INTERVAL then return end
        
        local currentCooldown = mRadial:DoSpellFrameCooldown(spellName, frame)
        local currentAura = mRadial:DoPetFrameAuraTimer(spellName, frame)
        if currentCooldown then
            mRadial:ShowFrame(frame.cooldownText)
            mRadial:SetFrameState_Active_Cooldown(frame)
        end

        if currentAura then 
            mRadial:ShowFrame(frame.cooldownText)
            mRadial:SetFrameState_Active_Cooldown(frame)
        end

        if not currentCooldown and not currentAura then
            mRadial:HideFrame(frame.cooldownText)
            mRadial:SetFrameState_Ready(frame)
        end

        mRadial:SetFrameVisibility(frame)
        plast = 0
    end)
end

local wlast = 0
function mRadial:SetWatcherScripts(frame, spellName, isUnitPowerDependant, powerType, powerMinCost, linkedSpell)
    frame:SetScript("OnUpdate", function(self, elapsed)
        wlast = wlast + elapsed
        if wlast <= MR_INTERVAL then return end
        
        ------------------------------------------
        -- Do we have enough power to use?
        local powerTextEnabled = MRadialSavedVariables["powerTextEnabled"] or MR_DEFAULT_POWERENABLED
        local canCast = true
        local currentPower = UnitPower("player", powerType)
        if isUnitPowerDependant and powerTextEnabled then
            mRadial:SetFrameState_Power(frame, powerType, powerMinCost, currentPower)
            if currentPower == 0 or currentPower < powerMinCost then
                canCast = false
            end
        end
        
        ------------------------------------------
        -- BASEFRAME STATE CHANGES HERE
        local currentDebuff = mRadial:DoDebuffTimer(spellName, frame, iconPath)
        if currentDebuff then 
            mRadial:SetFrameState_Active_Debuff(frame) 
        end

        local currentCooldown = mRadial:DoSpellFrameCooldown(spellName, frame)
        if currentCooldown and not currentDebuff then 
            mRadial:SetFrameState_Active_Cooldown(frame) 
        end
        
        if not currentCooldown and not currentDebuff and canCast then
            mRadial:SetFrameState_Ready(frame)
        else
            mRadial:ShowFrame(frame.readyText)
            frame.readyText:SetText(NOPOWER)        -- "X"
            frame.readyText:SetTextColor(1, 0, 0)   -- RED
        end

        ------------------------------------------
        -- LINKED WATCHER SPELLS
        local linkedIconPath, hasActiveBuff, scount, linkedSpellName
        if linkedSpell then 
            linkedIconPath, hasActiveBuff, scount = mRadial:SetFrameState_Active_Linked(frame, linkedSpell)
            linkedSpellName = linkedSpell[1] 
            local linkedSpellID = linkedSpell[2]
            
            mRadial:SetFrameState_Active_Linked(frame, linkedSpell)
            mRadial:DoLinkedTimer(linkedSpellName, frame, linkedIconPath)
            mRadial:SetFrameVisibility(frame)
        end

        -- TOTEM WATCHING
        for slot = 1, 4 do
            local haveTotem, totemName, startTime, duration, icon = GetTotemInfo(slot)
            if haveTotem and totemName == spellName then
                mRadial:DoTotemTimer(frame, startTime, duration, icon)
            end
        end

        -- Now set the count on the frame regardless.
        mRadial:SetFrameState_Count(frame, linkedSpell, linkedSpellID, hasActiveBuff, scount)

        -- Finally if we are out of range, override the whole lot.
        mRadial:SetFrameState_OOR(frame, spellName)

        wlast = 0
    end)
end
