function mw_checkHasSpell(spellName)
    local name, _, _, _, _, _, _, _ = GetSpellInfo(spellName)
    if name then
        return true
    else
        return false
    end
end

function isCorrectClass()
    local playerClass = UnitClass("player")
    -- Check if the player's class is "Warlock"
    if playerClass == "Warlock" then
        print("~~~~~~~~~~~~~~~~~")
        print("Welcome to MWarlock!")
        print("~~~~~~~~~~~~~~~~~")
        return true
    end
    return false
end

function isCorrectSpec()
    -- Check if player has selected demonology as their spec
    local spec = GetSpecialization()
    if spec ~= 2 then
        return false
    end
    return true
end

function syncDemonologyTalentTree()
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

function mWarlock:shardtrack()
    -- SHARD TRACKING FRAMES
    local soulShards = mWarlock:getShardCount()
    
    -- Change the texture of the frame
    shardCounterFrame.shardsTex:SetTexture(string.format("%s\\shards_%d.blp", mediaPath, soulShards))

    -- Change the main frame bg if we're out of shards and not in moving mode..
    if soulShards == 0 and not mainFrameIsMoving then
        MWarlockMainFrame.tex:SetColorTexture(1, 0, 0, 0.09) -- red, 10% opacity
    elseif not mainFrameIsMoving then
        MWarlockMainFrame.tex:SetColorTexture(0, 0, 0, 0)
    end
end

function mWarlock:IsFelguardSummoned()
    local summonedPet = UnitCreatureFamily("pet")
    if summonedPet and summonedPet == "Felguard" then
      return true
    end
    return false
end