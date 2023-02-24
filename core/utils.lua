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
    --- Trawl the entire spell book for pells.
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
            if spellName and spellID and not IsPassiveSpell(spellID) then
                -- print(spellName, icon, "active!")
                local spellInfo = {}
                      spellInfo['rank'] = rank
                      spellInfo['icon'] = icon
                      spellInfo['castingTime'] = castingTime --returns in milliseconds so we should do *.001
                      spellInfo['minRange'] = minRange
                      spellInfo['maxRange'] = maxRange
                      spellInfo['spellID'] = spellID
                spellData[spellName] = spellInfo
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

 
function mWarlock:syncSpec()
    local spellOrder = nil
    local spec = mWarlock:GetSpec()
    if mWarlock:IsWarlock() then 
        if spec == 1 then
            print("Affliction warlock detected!")
            return aff_spellOrder, mWarlock:getAllSpells()
        elseif spec == 2 then
            print("Demo warlock detected!")
            return demo_spellOrder, mWarlock:getAllSpells()
        else
            print("Destro warlock detected!")
            return destro_spellOrder, mWarlock:getAllSpells()
        end
    elseif mWarlock:IsPriest() then
        if spec == 3 then
            print("Shadow Priest detected!")
            return shadow_spellOrder, mWarlock:getAllSpells()
        end
    elseif mWarlock:IsShaman() then
        if spec == 1 then
            print("Shaman Noob detected!")
            return shaman_spellOrder, mWarlock:getAllSpells()
        end
    end
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
