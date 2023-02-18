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

function mWarlock:syncDemonologyTalentTree()
    for spellName, _ in pairs(demTree_specialisationData) do
        local name, _, _, _, _, _, _, _ = GetSpellInfo(spellName)
        if name then
            demTree_specialisationData[spellName]["active"] = true
        end
    end
end

function mWarlock:getShardCount()
    return  UnitPower("player", 7)
end

function mWarlock:IsFelguardSummoned()
    local summonedPet = UnitCreatureFamily("pet")
    if summonedPet and summonedPet == "Felguard" then
      return true
    end
    return false
end
