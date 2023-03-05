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

function mRadial:checkHasSpell(spellName)
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

function mRadial:IsPriest()
    return UnitClass("player") == "Priest"
end

function mRadial:IsShaman()
    return UnitClass("player") == "Shaman"
end

function mRadial:GetSpec()
    -- Check if player has selected demonology as their spec
    return GetSpecialization()
end

function mRadial:GetSpecName()
    local currentSpec = GetSpecialization()
    local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec))
    return currentSpecName
end

function mRadial:BuffHasSpellParent()
end

function mRadial:TableContains(myTable, value)
    for _, v in ipairs(myTable) do
        if v[1] == value[1] then
            return true
        end
    end

    return false
end

function mRadial:getAllSpells(activeTable)
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
        if isKnown and isPassive then
            table.insert(active, {buffName, spellID})
        end
    end
    return active
end

function mRadial:GetAllActiveTalentTreeSpells()
    -- Parse the active talent tree for active spells, note all passive spells get cull here, if you want passtive use 
    -- mRadial:GetAllPassiveTalentTreeSpells()
    local activeSpellData = mRadial:GetTalentTreeSpellIDList()
    -- lower level classes might not have an active talent tree.
    if activeSpellData == nil then
        activeSpellData= {}
    end

    local active = {}
    for _, spellID in ipairs(activeSpellData) do
        local spellName, _, iconPath, _, minRange, maxRange, _, parentSpellIcon = GetSpellInfo(spellID)
        local isKnown
        if spellID == nil then
            isKnown = false
        else
            isKnown = IsPlayerSpell(spellID)
        end
        local isPassive = IsPassiveSpell(spellID)
        
        if isKnown and not isPassive then
            table.insert(active, {spellName, spellID})
        end
    end
    mRadial:getAllSpells(active)
    return active
end

function mRadial:getShardCount()
    return  UnitPower("player", 7)
end

function mRadial:hasPetSummoned()
    local summonedPet = UnitCreatureFamily("pet")
    if summonedPet then
      return true, summonedPet
    end

    return false, nil
end

function mRadial:IsFelguardSummoned()
    local isSummoned, summonedPet = mRadial:hasPetSummoned()
    if isSummoned and summonedPet == "Felguard" then
      return true
    end

    return false
end

function mRadial:IsSuccubusSummoned()
    local isSummoned, summonedPet = mRadial:hasPetSummoned()
    if isSummoned and summonedPet == "Succubus" or summonedPet == "Incubus" then
      return true
    end
    
    return false
end

function mRadial:IsFelhunterSummoned()
    local isSummoned, summonedPet = mRadial:hasPetSummoned()
    if isSummoned and summonedPet == "Felhunter" then
      return true
    end
    
    return false
end

function mRadial:IsVoidWalkerSummoned()
    local isSummoned, summonedPet = mRadial:hasPetSummoned()
    if isSummoned and summonedPet == "Voidwalker" then
      return true
    end
    
    return false
end

function mRadial:IsFelImpSummoned()
    local isSummoned, summonedPet = mRadial:hasPetSummoned()
    if isSummoned and summonedPet == "Fel Imp" or summonedPet == "Imp"  then
      return true
    end
    
    return false
end

function mRadial:syncTalentTree(treeTable)
    for spellName, _ in pairs(treeTable) do
        local name, _, _, _, _, _, _, _ = GetSpellInfo(spellName)
        if name then
            treeTable[spellName]["active"] = true
        end
    end
end

function mRadial:GetTableLen(table)
    local count = 0
    for idx, _ in ipairs(table) do
        count = count +1
    end
    return count
end


--- FUN STUFF

function addItemInfoToTable(itemName, itemInfo, data, ignoreSoulBound)
    local url = "https://www.wowhead.com/item="..itemInfo["itemID"]
    local finalurl = "|Hurl:" ..url .. "|h[" .. itemName .. "]|h"
    local isBound = itemInfo['isBound']
    if not ignoreSoulBound and isBound then
        table.insert(data, {itemName, itemInfo["iconFileID"], finalurl, url, itemInfo["hyperlink"]})
    elseif ignoreSoulBound and isBound then
    else
        table.insert(data, {itemName, itemInfo["iconFileID"], finalurl, url, itemInfo["hyperlink"]})
    end
end


function mRadial:listBagItems(ignoreSoulBound)
    BAGDUMPV1 = {}
    for bag = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemLink = C_Container.GetContainerItemLink(bag, slot)
            if itemLink then
                local itemName = GetItemInfo(itemLink)
                local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
                if itemName ~= nil and itemInfo ~= nil then
                    addItemInfoToTable(itemName, itemInfo, BAGDUMPV1, ignoreSoulBound)
                end
            end
        end
    end
    SendSystemMessage("Swapped to player inventory!")
    return BAGDUMPV1
end

function mRadial:listBankItems(ignoreSoulBound)
    BANKDUMPV1 = {}
    -- (You need to be at the bank for bank inventory IDs to return valid results) WTF!
    for bag = 6, 14 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemLink = C_Container.GetContainerItemLink(bag, slot)
            if itemLink then
                local itemName = GetItemInfo(itemLink)
                local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
                if itemName ~= nil and itemInfo ~= nil then
                    addItemInfoToTable(itemName, itemInfo, BANKDUMPV1, ignoreSoulBound)
                end
            end
        end
    end
    SendSystemMessage("Swapped to open bank bags!")
    return BANKDUMPV1
end

function mRadial:listBankReagentItems(ignoreSoulBound)
    BANKRDUMPV1 = {}
    -- (You need to be at the bank for bank inventory IDs to return valid results) WTF!
    for slot = 1, C_Container.GetContainerNumSlots(REAGENTBANK_CONTAINER) do
        local itemLink = C_Container.GetContainerItemLink(REAGENTBANK_CONTAINER, slot)
        if itemLink then
            local itemName = GetItemInfo(itemLink)
            local itemInfo = C_Container.GetContainerItemInfo(REAGENTBANK_CONTAINER, slot)
            if itemName ~= nil and itemInfo ~= nil then
                addItemInfoToTable(itemName, itemInfo, BANKRDUMPV1, ignoreSoulBound)
            end
        end
    end
    SendSystemMessage("Swapped to Bank reagent bag!")
    return BANKRDUMPV1
end

function mRadial:TestCast()
    SpellCast()
end
