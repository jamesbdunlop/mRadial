function mWarlock:GetAuraTimeLeft(expirationTime)
    if expirationTime == nil then
        return nil
    end
    local timeLeft = expirationTime - GetTime()
    local minutes = math.floor(timeLeft / 60)
    local seconds = math.floor(timeLeft - minutes * 60)
    return minutes, seconds
end

function mWarlock:HasActiveBuff(buffName)
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i)
        if name and name == buffName then
            return true
        end
    end
    return false
end

function mWarlock:IsSpellUnitPowerDependant(spellID)
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

function mWarlock:checkHasSpell(spellName)
    local name, _, _, _, _, _, _, _ = GetSpellInfo(spellName)
    if name then
        return true
    else
        return false
    end
end

function mWarlock:IsWarlock()
    return UnitClass("player") == "Warlock"
end

function mWarlock:IsPriest()
    return UnitClass("player") == "Priest"
end

function mWarlock:IsShaman()
    return UnitClass("player") == "Shaman"
end

function mWarlock:isCorrectClass()
    -- Check if the player's class is "Warlock"
    if mWarlock:IsWarlock() then
        return true
    elseif mWarlock:IsPriest() then
        return true
    elseif mWarlock:IsShaman() then
        return true
    else
        return false
    end
end

function mWarlock:isCorrectSpec()
    -- Check if player has selected demonology as their spec
    local spec = GetSpecialization()
    if spec ~= 2 then
        return false
    end
    return true
end

function mWarlock:GetSpec()
    -- Check if player has selected demonology as their spec
    return GetSpecialization()
end

function mWarlock:GetSpecName()
    -- Check if player has selected demonology as their spec
    local spec = mWarlock:GetSpec()
    local specNames = {"Affliciton", "Demonology", "Destruction"}
    local specName = specNames[spec]
    return specName
end

function mWarlock:getSpecName()
    local currentSpec = GetSpecialization()
    local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"
    return currentSpecName
end

function mWarlock:BuffHasSpellParent()
end

function mWarlock:getAllSpells()
    local spellData = {}
    --- Trawl the entire spell book for spells.
    --- Sick of trying to figure out the most important! Going to leave this up to the user.
    local numTabs = GetNumSpellTabs()
    for i=1,numTabs do
        local name, _, offset, numSpells = GetSpellTabInfo(i)
        -- print("name: %s", name)
        for x=offset+1, offset + numSpells do
            local spellName, rank, icon, castingTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(x, "spell")
            -- SOME WEIRD BUG WITH SHADOWFURY the names don't match??! Yet you print it and it's the same fkin name!
            if spellID == 30283 then
                spellName = SHADOWFURY_SPELLNAME
            end
            if spellName and spellID then --and not IsPassiveSpell(spellID) then
                -- print(spellName, icon, "active!")
                local spellInfo = {}
                      spellInfo['rank'] = rank
                      spellInfo['icon'] = icon
                      spellInfo['castingTime'] = castingTime --returns in milliseconds so we should do *.001
                      spellInfo['minRange'] = minRange
                      spellInfo['maxRange'] = maxRange
                      spellInfo['spellID'] = spellID
                if name ~= mWarlock:getSpecName() and mWarlock:IsShaman() and name ~= "Shaman" then 
                    spellData[spellName] = nil
                else
                    spellData[spellName] = spellInfo
                end  
    end end end
    -- THIS IS A TEST OF THE BULLSHIT DYNAMIC SPELLS IN THE SPELL BOOK THAT SHOW AND HIDE THERE!!!
    spellData[DEATHBOLT_SPELLNAME] = {}
    local _, rank, icon, castingTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(DEATHBOLT_SPELLNAME)
    spellData[DEATHBOLT_SPELLNAME]['rank'] = rank
    spellData[DEATHBOLT_SPELLNAME]['icon'] = icon
    spellData[DEATHBOLT_SPELLNAME]['castingTime'] = castingTime --returns in milliseconds so we should do *.001
    spellData[DEATHBOLT_SPELLNAME]['minRange'] = minRange
    spellData[DEATHBOLT_SPELLNAME]['maxRange'] = maxRange
    spellData[DEATHBOLT_SPELLNAME]['spellID'] = spellID

    return spellData
end
 
function mWarlock:GetTalentTreeSpellIDList()
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

function mWarlock:GetAllPassiveTalentTreeSpells()
    local activeSpellData = mWarlock:GetTalentTreeSpellIDList()
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

function mWarlock:GetAllActiveTalentTreeSpells()
    local activeSpellData = mWarlock:GetTalentTreeSpellIDList()
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
    return active
end

function mWarlock:syncSpec()
    -- main loop to figure out if the spells in the constants are present and should be added 
    -- to the radial menu
    -- note: it would be good to use https://wowpedia.fandom.com/wiki/API_GetTalentInfo to get all avail talents
    -- check those against the spell book as being "active" and then offering these up as check boxes in the options for and opt in feature set.
    local spellOrder = nil
    local spec = mWarlock:GetSpec()
    if mWarlock:IsWarlock() then 
        if spec == 1 then
            print("Affliction warlock detected!")
            return aff_spellOrder, mWarlock:getAllSpells()
        elseif spec == 2 then
            print("Demo warlock detected!")
            return demo_spellOrder, mWarlock:GetTalentTreeSpellIDList()
        else
            print("Destro warlock detected!")
            return destro_spellOrder, mWarlock:getAllSpells()
        end
    elseif mWarlock:IsPriest() then
        if spec == 3 then
            print("Shadow Priest detected!")
            return shadow_spellOrder, mWarlock:GetTalentTreeSpellIDList()-- mWarlock:getAllSpells()
        end
    elseif mWarlock:IsShaman() then
        print("Shaman Noob detected!")
        return shaman_spellOrder, mWarlock:getAllSpells()
    end
    return spellOrder, mWarlock:getAllSpells()
end

function mWarlock:getShardCount()
    return  UnitPower("player", 7)
end

function mWarlock:hasPetSummoned()
    local summonedPet = UnitCreatureFamily("pet")
    if summonedPet then
      return true, summonedPet
    end

    return false, nil
end

function mWarlock:IsFelguardSummoned()
    local isSummoned, summonedPet = mWarlock:hasPetSummoned()
    if isSummoned and summonedPet == "Felguard" then
      return true
    end

    return false
end

function mWarlock:IsSuccubusSummoned()
    local isSummoned, summonedPet = mWarlock:hasPetSummoned()
    if isSummoned and summonedPet == "Succubus" or summonedPet == "Incubus" then
      return true
    end
    
    return false
end

function mWarlock:IsFelhunterSummoned()
    local isSummoned, summonedPet = mWarlock:hasPetSummoned()
    if isSummoned and summonedPet == "Felhunter" then
      return true
    end
    
    return false
end

function mWarlock:IsVoidWalkerSummoned()
    local isSummoned, summonedPet = mWarlock:hasPetSummoned()
    if isSummoned and summonedPet == "Voidwalker" then
      return true
    end
    
    return false
end

function mWarlock:IsFelImpSummoned()
    local isSummoned, summonedPet = mWarlock:hasPetSummoned()
    if isSummoned and summonedPet == "Fel Imp" then
      return true
    end
    
    return false
end

function mWarlock:syncTalentTree(treeTable)
    for spellName, _ in pairs(treeTable) do
        local name, _, _, _, _, _, _, _ = GetSpellInfo(spellName)
        if name then
            treeTable[spellName]["active"] = true
        end
    end
end
