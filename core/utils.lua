local mRadial = mRadial
local appName = "mRadial"
local L = LibStub("AceLocale-3.0"):GetLocale(appName, false) or nil

--------------
-- TIMER UTILS
function mRadial:GetAuraTimeLeft(expirationTime)
    if expirationTime == nil then
        return nil
    end
    local timeLeft = expirationTime - GetTime()
    local minutes = math.floor(timeLeft / 60)
    local seconds = math.floor(timeLeft - minutes * 60)
    return minutes, seconds
end

---------------------
-- ABILTY/SPELL UTILS
function mRadial:HasActiveBuff(buffName)
    for i = 1, 40 do
        local name, _, scount, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i)
        if name and name == buffName then
            return true, scount
        end
    end
    return false, 0
end

function mRadial:IsSpellUnitPowerDependant(spellID)
    local costInfo = GetSpellPowerCost(spellID)
    if costInfo[1] ~= nil then
        if costInfo[1]["name"] ~= "MANA" then
            return costInfo[1]["name"], costInfo[1]["minCost"]
        else
            return false, 0
        end
    end
    return false, 0
end

function mRadial:CheckHasPetSpell(spellName)
    local numPetSpells = HasPetSpells()
    if not numPetSpells then
        return false
    end

    local abilities = mRadial:GetPetAbilities()
    for petSpellName, _ in pairs(abilities) do
        if petSpellName == spellName then
            return true
        end
    end
    
    return false
end

function mRadial:IsActiveDebuff(spellName)
    local debuffCheck
    for idx = 1, 40 do
        local name, _, _, _, _, expirationTime, source, _, _, _, _, _, _, _, _ = UnitDebuff("target", idx)
        if name == spellName and source == "player" then 
            debuffCheck = expirationTime - GetTime()
            break
        end
    end
    
    return debuffCheck
end

function mRadial:IsPowerDependant(spellID)
    local costInfo = GetSpellPowerCost(spellID)
    local isUnitPowerDependant = false
    local powerMinCost = 0
    local powerType = 0
    
    if costInfo[1] == nil then 
        isUnitPowerDependant = false
    else 
        isUnitPowerDependant = true
        powerType = costInfo[1]["type"]
        powerMinCost = costInfo[1]["minCost"]
    end
    
    return isUnitPowerDependant, powerType, powerMinCost
end
---------------------
-- CLASS UTILS
function mRadial:IsWarlock()
    return UnitClass("player") == GetClassInfo(9)
end

function mRadial:IsPriest()
    return UnitClass("player") == GetClassInfo(5)
end

function mRadial:IsShaman()
    return UnitClass("player") == GetClassInfo(7)
end

function mRadial:IsDruid()
    return UnitClass("player") == GetClassInfo(11)
end

function mRadial:GetSpecName()
    local currentSpec = GetSpecialization()
    local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))
    return currentSpecName
end

function mRadial:GetPetAbilities()
    local petAbilities = {}
    local numPetSpells = HasPetSpells()
    if not numPetSpells then
        return {}
    end
    for i = 1, numPetSpells do
        local spellName, _, _ = GetSpellBookItemName(i, "pet")
        local spellTexture = GetSpellTexture(i, "pet")
        local isPassive = IsPassiveSpell(i, "pet")
        local contains = mRadial:TableContainsKey(petAbilities, spellName)
        if spellName and not isPassive and not contains and spellTexture ~= nil then
            petAbilities[spellName] = {}
            petAbilities[spellName]["spellName"] = spellName
            petAbilities[spellName]["spellIcon"] = spellTexture
        end
    end

    -- Special cases, such as the talent for the felguard on lock.
    if mRadial:IsWarlock() and mRadial:IsFelguardSummoned() and not mRadial:TableContainsKey(petAbilities, L["Opt_DemonicStrength"]) then
        petAbilities[L["Opt_DemonicStrength"]] = {}
        petAbilities[L["Opt_DemonicStrength"]]["spellName"] = L["Opt_DemonicStrength"]
        petAbilities[L["Opt_DemonicStrength"]]["spellIcon"] = string.format("%s/Ability_warlock_demonicempowerment.blp", ROOTICONPATH)
    end
    return petAbilities
end

function mRadial:GetAllSpells(activeTable)
    --- Trawl the entire spell book for spells.
    --- Sick of trying to figure out the most important! Going to leave this up to the user.
    local numTabs = GetNumSpellTabs()
    for i=2,numTabs do
        local name, _, offset, numSpells = GetSpellTabInfo(i)
        if name == mRadial:GetSpecName() or name == UnitClass("player") then
            for x=offset+1, offset + numSpells do
                local spellName, rank, icon, castingTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(x, "spell")
                if spellID and spellName then
                    -- SOME WEIRD BUG WITH SHADOWFURY the names don't match??! 
                    -- Yet you print it and it's the same fkin name!
                    if spellID == 30283 then spellName = SHADOWFURY_SPELLNAME end
                    if spellName and spellID then
                        if not mRadial:TableContains(activeTable, {spellName, spellID}) then
                            table.insert(activeTable, {spellName, spellID})
                        end
                    end
                end
    end end end
end
 
function mRadial:GetTalentTreeSpellIDList()
    local list = {}

    local configID = C_ClassTalents.GetActiveConfigID()
    if configID == nil then return end

    local configInfo = C_Traits.GetConfigInfo(configID)
    if configInfo == nil then return end

    for _, treeID in ipairs(configInfo.treeIDs) do -- in the context of talent trees, there is only 1 treeID
        local nodes = C_Traits.GetTreeNodes(treeID)
        for i, nodeID in ipairs(nodes) do
            local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID)
            for _, entryID in ipairs(nodeInfo.entryIDs) do -- each node can have multiple entries (e.g. choice nodes have 2)
                local entryInfo = C_Traits.GetEntryInfo(configID, entryID)
                if entryInfo and entryInfo.definitionID then
                    local definitionInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)
                    if definitionInfo.spellID then
                        table.insert(list, definitionInfo.spellID)
                    end
                end
            end
        end
    end
    return list
end

function mRadial:GetAllPassiveTalentTreeSpells()
    local activeSpellData = mRadial:GetTalentTreeSpellIDList()
    local active = {}
    for _, spellID in ipairs(activeSpellData) do
        -- local spellName, skipBuff, buffName, isUnitPowerDependant, UnitPowerCount, isDebuff = unpack(spellInfo)
        local buffName, _, iconPath, _, minRange, maxRange, _, parentSpellIcon = GetSpellInfo(spellID)
        local isKnown
        if spellID == nil then
            isKnown = false
        else
            isKnown = IsPlayerSpell(spellID)
        end
        -- print("Creating watcher for %s", spellName)
        local isPassive = IsPassiveSpell(spellID)
        if isKnown and isPassive and not mRadial:TableContains(active, {buffName, spellID}) then
            table.insert(active, {buffName, spellID})
        end
    end
    return active
end

function mRadial:GetAllActiveTalentTreeSpells()
    if #MR_SPELL_CACHE > 0 then 
        return MR_SPELL_CACHE 
    end
    -- Parse the active talent tree for active spells, note all passive spells 
    -- get culled here, if you want passive use mRadial:GetAllPassiveTalentTreeSpells()
    local activeSpellData = mRadial:GetTalentTreeSpellIDList()
    -- lower level classes might not have an active talent tree.
    if activeSpellData == nil then activeSpellData= {} end
    -- Trawl the book first, as sometimes the talent tree will have abilities of the 
    -- same name and we don't get the right spellID's because of this, eg: Thrash for Druid. 
    mRadial:GetAllSpells(MR_SPELL_CACHE)
    for _, spellID in ipairs(activeSpellData) do
        local spellName, _, _, _, _, _, _, _ = GetSpellInfo(spellID)
        local isKnown
        if spellID == nil then
            isKnown = false
        else
            isKnown = IsPlayerSpell(spellID)
        end
        if isKnown and not mRadial:TableContains(MR_SPELL_CACHE, {spellName, spellID}) then
            table.insert(MR_SPELL_CACHE, {spellName, spellID})
        end
    end
    return MR_SPELL_CACHE
end

function mRadial:GetShardCount()
    return  UnitPower("player", 7)
end

function mRadial:HasPetSummoned()
    local summonedPet = UnitCreatureFamily("pet")
    if summonedPet then
      return true, summonedPet
    end

    return false, nil
end

function mRadial:IsFelguardSummoned()
    local isSummoned, summonedPet = mRadial:HasPetSummoned()
    if isSummoned and summonedPet == L["Opt_Felguard"] or summonedPet == L["Opt_Wrathguard"] then
      return true
    end

    return false
end

function mRadial:IsSuccubusSummoned()
    local isSummoned, summonedPet = mRadial:HasPetSummoned()
    if isSummoned and summonedPet == L["Opt_Succubus"] or summonedPet == L["Opt_Incubus"] then
      return true
    end
    
    return false
end

function mRadial:IsFelhunterSummoned()
    local isSummoned, summonedPet = mRadial:HasPetSummoned()
    if isSummoned and summonedPet == L["Opt_Felhunter"] then
      return true
    end
    
    return false
end

function mRadial:IsVoidWalkerSummoned()
    local isSummoned, summonedPet = mRadial:HasPetSummoned()
    if isSummoned and summonedPet == "Voidwalker" then
      return true
    end
    
    return false
end

function mRadial:IsFelImpSummoned()
    local isSummoned, summonedPet = mRadial:HasPetSummoned()
    if isSummoned and summonedPet == "Fel Imp" or summonedPet == "Imp"  then
      return true
    end
    
    return false
end

------------
-- LUA UTILS
function mRadial:TableContains(myTable, value)
    for _, v in ipairs(myTable) do
        if v[1] == value[1] then
            return true
        end
    end

    return false
end

function mRadial:OrderTableContains(myTable, watcher)
    for _, v in ipairs(myTable) do
        if v.spellName == watcher.spellName then
            return true
        end
    end

    return false
end

function mRadial:TableContainsKey(myTable, key)
    for tablekey, _ in pairs(myTable) do
        if tablekey == key then
            return true
        end
    end

    return false
end

function mRadial:GetWatcherFromTable(spellName, activespells)
    for _, watcher in ipairs(activespells) do
        if watcher.spellName == spellName then
            return watcher
        end
    end
end

function mRadial:GetFrame(frameName)
    for x=1, #MR_ALLFRAMES do
        local frame = MR_ALLFRAMES[x]
        if frame:GetName() == frameName then
            return frame
        end
    end
end

function mRadial:GetPetFrame(frameName)
    for x=1, #MR_CURRENTPETFRAMES do
        local frame = MR_CURRENTPETFRAMES[x]
        if frame:GetName() == frameName then
            return frame
        end
    end
end

--------------
-- FRAME UTILS
function mRadial:GlobalFontPercentageChanged()
    mRadial:UpdateUI(false)
    mRadial:CreatePetFrames()
end

function mRadial:GetWatcher(frameName)
    for x = 1, #MR_WATCHERFRAMES do
        local watcher = MR_WATCHERFRAMES[x]
        if watcher ~= nil and watcher.isWatcher and watcher:GetName() == frameName then
            return watcher, x
        end
    end
    return nil, -1
end

function mRadial:GetFrameByName(frameName)
    for x = 1, #MR_ALLFRAMES do
        local frame = MR_ALLFRAMES[x]
        if frame ~= nil and frame:GetName() == frameName then
            return true, frame
        end
    end
    return false, nil
end

function mRadial:UpdateActivePrimarySpells()
    -- Flush existing
    ACTIVEPRIMARYWATCHERS = {}
    mRadial:HideAllWatcherFrames()
    local spellBookSpells = {}
    local spellsInBook = mRadial:GetAllSpells(spellBookSpells)
    for x=1, #MR_WATCHERFRAMES   do
        -- -- Now we check for isActive (options toggles)
        local watcher = MR_WATCHERFRAMES[x]
        local isActive = MRadialSavedVariables["isActive".. watcher.spellName] or false
        local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(watcher.spellName)
        if spellID == nil then 
            spellKnown = false 
        else
            spellKnown = IsSpellKnown(spellID, false)
        end
        if not isKnown then
            spellKnown = mRadial:TableContains(spellBookSpells, {watcher.spellName, spellID})
        end
        if isActive and spellKnown then 
            ACTIVEPRIMARYWATCHERS[#ACTIVEPRIMARYWATCHERS+1] = watcher
            mRadial:ShowFrame(watcher)
            if not InCombatLockdown then
                watcher:GetParent():Show()
            end
        end
    end
    return ACTIVEPRIMARYWATCHERS
end

function mRadial:UpdateActiveSecondarySpells()
    -- Flush existing
    ACTIVESECONDARYWATCHERS = {}
    local hideSecondary = MRadialSavedVariables["hideSecondary"] 
    if hideSecondary == nil then hideSecondary = MR_DEFAULT_HIDESECONDARY end
    if hideSecondary then
        return
    end
    for x=1, #MR_WATCHERFRAMES do
        -- First we hide any and all watchers that may have been active.
        local watcher = MR_WATCHERFRAMES[x]
        local isActive = MRadialSavedVariables["isActive".. watcher.spellName] or false
        local isSecondaryActive = MRadialSavedVariables["isSecondaryActive".. watcher.spellName] or false
        local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(watcher.spellName)
        local spellKnown
        if spellID == nil then 
            spellKnown = false 
        else
            spellKnown = IsSpellKnown(spellID, false)
        end

        -- Now we check for isActive (options toggles)
        if isSecondaryActive and not isActive and spellKnown then 
            ACTIVESECONDARYWATCHERS[#ACTIVESECONDARYWATCHERS+1] = watcher 
            mRadial:ShowFrame(watcher)
            if not InCombatLockdown then
                watcher:Show()
            end
        end
    end
    return ACTIVESECONDARYWATCHERS
end

function mRadial:HideAllWatcherFrames()
    for x=1, #MR_WATCHERFRAMES do
        -- First we hide any and all watchers that may have been active.
        local watcher = MR_WATCHERFRAMES[x]
        mRadial:HideFrame(watcher)
        if not InCombatLockdown then
            watcher:GetParent():Hide()
        end
    end
end

function mRadial:ForceUpdateAllMoveableFramePositions()
    for x=1, #MR_ALLFRAMES do
        local frame = MR_ALLFRAMES[x]
        if not frame.isWatcher then
            mRadial:RestoreFrame(frame:GetName(), frame, false)
        end
    end
    mRadial:UpdateUI(false)
    mRadial:setShardTrackerFramesSize()
    mRadial:setOOSShardFramesSize()
    mRadial:SetPetFramePosAndSize()
end

function mRadial:RestoreFrame(frameName, frame, forceDefault, dx, dy)
    if forceDefault == nil then forceDefault = false end
    local playerName = UnitName("player")
    local playerSpec = GetSpecialization()
    local framePosData = PerPlayerPerSpecSavedVars[playerName][playerSpec]["framePositions"][frameName]
    
    if framePosData == nil or forceDefault then
        framePosData = {}
        local x = dx or 0
        local y = dy or 0
        framePosData["x"] = x
        framePosData["y"] = y
        framePosData["point"] = "CENTER"
        framePosData["relativeTo"] = "UIParent"
        framePosData["relativePoint"] = "CENTER"
        framePosData["size"] = {50, 50}
    end

    local x = framePosData["x"] or 0
    local y = framePosData["y"] or 0
    local point = framePosData["point"] or "CENTER"
    -- local relativeTo = framePosData["relativeTo"] or UIParent
    local relativePoint = framePosData["relativePoint"] or "CENTER"
    if not InCombatLockdown() then
        frame:SetPoint(tostring(point), UIParent, relativePoint, x, y)
    end
    
    local framesize = framePosData["size"]
    if framesize == nil then
        framePosData["size"] = {50, 50}
    end

    local sx = framePosData["size"][1] or 50
    local sy = framePosData["size"][2] or 50
    if not InCombatLockdown() then
        frame:SetSize(sx, sy)
    end
    -- WHY THE FUCK DOES THIS NOT WORK ANYMORE!!!!!??????
    -- frame:SetPoint(tostring(point), relativeTo, tostring(relativePoint), x, y)
    MRadialSavedVariables.framePositions[frameName] = framePosData
end

function mRadial:WatcherExists(frameName)
    for x = 1, #MR_WATCHERFRAMES do
        local watcher = MR_WATCHERFRAMES[x]
        if watcher ~= nil and watcher.isWatcher and watcher:GetName() == frameName then
            return true
        end
    end
    return false
end

-- PET
function mRadial:SetPetFramePosAndSize()
    local petFrameSize = MRadialSavedVariables["PetFramesSize"] or 45
    local fontPercentage = MRadialSavedVariables.FontPercentage or .5
    local customFontPath = MRadialSavedVariables['Font'] or MR_DEFAULT_FONT

    for _, frame in pairs(MR_CURRENTPETFRAMES) do
        mRadial:RestoreFrame(frame:GetName(), frame)
        if not InCombatLockdown() then
            frame:SetSize(petFrameSize, petFrameSize)
        end
        local pet_readyColor = MRadialSavedVariables.pet_readyColor or MR_DEFAULT_READYCOLOR
        local pet_countColor = MRadialSavedVariables.pet_countColor or MR_DEFAULT_COUNTCOLOR
        local pet_cdColor = MRadialSavedVariables.pet_cdColor or MR_DEFAULT_CDCOLOR
        
        local pet_readyFontSize = MRadialSavedVariables.pet_readyFontSize or MR_DEFAULT_PET_FONTSIZE
        local pet_countFontSize = MRadialSavedVariables.pet_countFontSize or MR_DEFAULT_PET_FONTSIZE
        local pet_coolDownFontSize = MRadialSavedVariables.pet_coolDownFontSize or MR_DEFAULT_PET_FONTSIZE

        local pet_readyUDOffset = MRadialSavedVariables.pet_readyUDOffset or MR_DEFAULT_READYUDOFFSET
        local pet_readyLROffset = MRadialSavedVariables.pet_readyLROffset or MR_DEFAULT_READYLROFFSET
        local pet_countUdOffset = MRadialSavedVariables.pet_countUdOffset or MR_DEFAULT_COUNTUDOFFSET
        local pet_countLROffset = MRadialSavedVariables.pet_countLROffset or MR_DEFAULT_COUNTLROFFSET
        local pet_cdUdOffset = MRadialSavedVariables.pet_cdUdOffset or MR_DEFAULT_CDUDOFFSET
        local pet_cdLROffset = MRadialSavedVariables.pet_cdLROffset or MR_DEFAULT_CDLROFFSET

        frame.readyText:SetFont(customFontPath, petFrameSize*fontPercentage+pet_readyFontSize, "THICKOUTLINE")
        frame.countText:SetFont(customFontPath, petFrameSize*fontPercentage+pet_countFontSize, "THICKOUTLINE")
        frame.cooldownText:SetFont(customFontPath, petFrameSize*fontPercentage+pet_coolDownFontSize, "OUTLINE, MONOCHROME")
        
        frame.readyText:SetPoint("CENTER", frame.iconFrame, "CENTER", pet_readyLROffset, pet_readyUDOffset)
        frame.readyText:SetTextColor(pet_readyColor[1], pet_readyColor[2], pet_readyColor[3])
        frame.countText:SetPoint("CENTER", frame.iconFrame, "CENTER", pet_countLROffset, pet_countUdOffset)
        frame.countText:SetTextColor(pet_countColor[1], pet_countColor[2], pet_countColor[3])
        frame.cooldownText:SetPoint("CENTER", frame.iconFrame, "CENTER", pet_cdLROffset, pet_cdUdOffset)
        frame.cooldownText:SetTextColor(pet_cdColor[1], pet_cdColor[2], pet_cdColor[3])
    end
end
