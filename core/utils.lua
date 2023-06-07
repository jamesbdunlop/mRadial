local mRadial = mRadial
local AceGUI = LibStub("AceGUI-3.0")

function mRadial:GetAuraTimeLeft(expirationTime)
    if expirationTime == nil then
        return nil
    end
    local timeLeft = expirationTime - GetTime()
    local minutes = math.floor(timeLeft / 60)
    local seconds = math.floor(timeLeft - minutes * 60)
    return minutes, seconds
end

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

function mRadial:CheckHasSpell(spellName)
    local name, _, _, _, _, _, _, _ = GetSpellInfo(spellName)
    if name then
        return true
    else
        return false
    end
end

function mRadial:IsWarlock()
    return UnitClass("player") == "Warlock"
end

function mRadial:GetSpecName()
    local currentSpec = GetSpecialization()
    local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))
    return currentSpecName
end

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

function mRadial:GetAllSpells(activeTable)
    local spellData = {}
    --- Trawl the entire spell book for spells.
    --- Sick of trying to figure out the most important! Going to leave this up to the user.
    local numTabs = GetNumSpellTabs()
    for i=2,numTabs do
        local name, _, offset, numSpells = GetSpellTabInfo(i)
        -- print("name: %s", name)
        if name == mRadial:GetSpecName() or name == UnitClass("player") then
            for x=offset+1, offset + numSpells do
                local spellName, rank, icon, castingTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(x, "spell")
                -- SOME WEIRD BUG WITH SHADOWFURY the names don't match??! Yet you print it and it's the same fkin name!
                if spellID == 30283 then
                    spellName = SHADOWFURY_SPELLNAME
                end
                if spellName and spellID then
                    if not mRadial:TableContains(activeTable, {spellName, spellID}) then
                        table.insert(activeTable, {spellName, spellID})
                    end
                end
    end end end
    return spellData
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
    -- Parse the active talent tree for active spells, note all passive spells get culled here, if you want passive use 
    -- mRadial:GetAllPassiveTalentTreeSpells()
    local activeSpellData = mRadial:GetTalentTreeSpellIDList()
    -- lower level classes might not have an active talent tree.
    if activeSpellData == nil then
        activeSpellData= {}
    end

    local active = {}
    for _, spellID in ipairs(activeSpellData) do
        local spellName, _, _, _, _, _, _, _ = GetSpellInfo(spellID)
        local isKnown
        if spellID == nil then
            isKnown = false
        else
            isKnown = IsPlayerSpell(spellID)
        end
        
        if isKnown and not mRadial:TableContains(active, {spellName, spellID}) then
            table.insert(active, {spellName, spellID})
        end
    end
    mRadial:GetAllSpells(active)
    return active
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
    if isSummoned and summonedPet == "Felguard" or summonedPet == "Wrathguard" then
      return true
    end

    return false
end

function mRadial:IsSuccubusSummoned()
    local isSummoned, summonedPet = mRadial:HasPetSummoned()
    if isSummoned and summonedPet == "Succubus" or summonedPet == "Incubus" then
      return true
    end
    
    return false
end

function mRadial:IsFelhunterSummoned()
    local isSummoned, summonedPet = mRadial:HasPetSummoned()
    if isSummoned and summonedPet == "Felhunter" then
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

function mRadial:GlobalFontPercentageChanged()
    -- print("Global font percentage changed!")
    mRadial:UpdateUI(false)
    mRadial:SetPetFramePosAndSize()
end

function mRadial:GetFromTable(spellName, activespells)
    for _, watcher in ipairs(activespells) do
        if watcher.spellName == spellName then
            return watcher
        end
    end
end
