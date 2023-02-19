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

function mWarlock:isCorrectClass()
    local playerClass = UnitClass("player")
    -- Check if the player's class is "Warlock"
    if playerClass == "Warlock" then
        return true
    end
    return false
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

function mWarlock:SyncSpec()
    local spec = mWarlock:GetSpec()
    local specData = nil
    local spellOrder = nil
    if spec == 1 then
        mWarlock:syncAfflictionTalentTree()
        spellOrder = aff_spellOrder
        specData = affTree_specialisationData
    elseif spec == 2 then
        mWarlock:syncDemonologyTalentTree()
        spellOrder = demo_spellOrder
        specData = demTree_specialisationData
    else
        mWarlock:syncDestructionTalentTree()
        spellOrder = destro_spellOrder
        specData = destro_specialisationData
    end

    return spellOrder, specData
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

function mWarlock:syncDemonologyTalentTree()
    for spellName, _ in pairs(demTree_specialisationData) do
        local name, _, _, _, _, _, _, _ = GetSpellInfo(spellName)
        if name then
            demTree_specialisationData[spellName]["active"] = true
        end
    end
end

function mWarlock:syncAfflictionTalentTree()
    for spellName, _ in pairs(affTree_specialisationData) do
        local name, _, _, _, _, _, _, _ = GetSpellInfo(spellName)
        if name then
            affTree_specialisationData[spellName]["active"] = true
        end
    end
end

function mWarlock:syncDestructionTalentTree()
    for spellName, _ in pairs(destro_specialisationData) do
        local name, _, _, _, _, _, _, _ = GetSpellInfo(spellName)
        if name then
            destro_specialisationData[spellName]["active"] = true
        end
    end
end