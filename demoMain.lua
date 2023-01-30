local function isCorrectClass()
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

local function isCorrectSpec()
    -- Check if player has selected demonology as their spec
    local spec = GetSpecialization()
    if spec ~= 2 then
        return false
    end
    return true
end

-- Gather only the spells we're interested in! It's bit hard codey but I don't care atm...
powerSiphonSpellName = "Power Siphon" --264130
demonicCoreSpellName = "Demonic Core"
inquisitorsGazeSpellName = "Inquistor's Gaze" --386334
summonSoulKeeperSpellName = "Summon Soulkeeper"
summonDTSpellName = "Summon Demonic Tyrant" --265187
demonicPowerSpellName = "Demonic Power"
netherPortalSpellName = "Nether Portal" --26721
grimFelGuardSpellName = "Grimoire: Felguard" --111898
callDreadStealersSpellName = "Call Dreadstalkers" --104316
felstormSpellName = "Felstorm"

rootIconPath ="Interface/ICONS"

dt_specialisationData = {}
--buffName, _, _, iconPath, parentSpellIcon, parentSpellName, skipBuff, isShardDependant
dt_specialisationData[grimFelGuardSpellName] = {}
dt_specialisationData[grimFelGuardSpellName]["active"] = false
dt_specialisationData[grimFelGuardSpellName]["spellName"] = nil
dt_specialisationData[grimFelGuardSpellName]["iconPath"] = string.format("%s/Spell_shadow_summonfelguard.blp", rootIconPath)
dt_specialisationData[grimFelGuardSpellName]["parentSpellIcon"] = string.format("%s/Spell_shadow_summonfelguard.blp", rootIconPath)
dt_specialisationData[grimFelGuardSpellName]["parentSpellName"] = grimFelGuardSpellName
dt_specialisationData[grimFelGuardSpellName]["skipBuff"] = true
dt_specialisationData[grimFelGuardSpellName]["isShardDependant"] = true

dt_specialisationData[summonDTSpellName] = {}
dt_specialisationData[summonDTSpellName]["active"] = false
dt_specialisationData[summonDTSpellName]["spellName"] = demonicPowerSpellName
dt_specialisationData[summonDTSpellName]["iconPath"] = string.format("%s/Achievement_boss_argus_maleeredar.blp", rootIconPath)
dt_specialisationData[summonDTSpellName]["parentSpellIcon"] = string.format("%s/Inv_summondemonictyrant.blp", rootIconPath)
dt_specialisationData[summonDTSpellName]["parentSpellName"] = summonDTSpellName
dt_specialisationData[summonDTSpellName]["skipBuff"] = nil
dt_specialisationData[summonDTSpellName]["isShardDependant"] = false

dt_specialisationData[powerSiphonSpellName] = {}
dt_specialisationData[powerSiphonSpellName]["active"] = false
dt_specialisationData[powerSiphonSpellName]["spellName"] = demonicCoreSpellName
dt_specialisationData[powerSiphonSpellName]["iconPath"] = string.format("%s/Warlock_spelldrain.blp", rootIconPath)
dt_specialisationData[powerSiphonSpellName]["parentSpellIcon"] = string.format("%s/Ability_warlock_backdraft.blp", rootIconPath)
dt_specialisationData[powerSiphonSpellName]["parentSpellName"] = powerSiphonSpellName
dt_specialisationData[powerSiphonSpellName]["skipBuff"] = nil
dt_specialisationData[powerSiphonSpellName]["isShardDependant"] = false

dt_specialisationData[summonSoulKeeperSpellName] = {}
dt_specialisationData[summonSoulKeeperSpellName]["active"] = false
dt_specialisationData[summonSoulKeeperSpellName]["spellName"] = nil
dt_specialisationData[summonSoulKeeperSpellName]["iconPath"] = string.format("%s/Spell_fel_elementaldevastation.blp", rootIconPath)
dt_specialisationData[summonSoulKeeperSpellName]["parentSpellIcon"] = nil
dt_specialisationData[summonSoulKeeperSpellName]["parentSpellName"] = nil
dt_specialisationData[summonSoulKeeperSpellName]["skipBuff"] = nil
dt_specialisationData[summonSoulKeeperSpellName]["isShardDependant"] = false

dt_specialisationData[netherPortalSpellName] = {}
dt_specialisationData[netherPortalSpellName]["active"] = false
dt_specialisationData[netherPortalSpellName]["spellName"] = nil
dt_specialisationData[netherPortalSpellName]["iconPath"] = string.format("%s/Inv_netherportal.blp", rootIconPath)
dt_specialisationData[netherPortalSpellName]["parentSpellIcon"] = string.format("%s/Inv_netherportal.blp", rootIconPath)
dt_specialisationData[netherPortalSpellName]["parentSpellName"] = netherPortalSpellName
dt_specialisationData[netherPortalSpellName]["skipBuff"] = true
dt_specialisationData[netherPortalSpellName]["isShardDependant"] = true

dt_specialisationData[callDreadStealersSpellName] = {}
dt_specialisationData[callDreadStealersSpellName]["active"] = false
dt_specialisationData[callDreadStealersSpellName]["spellName"] = nil
dt_specialisationData[callDreadStealersSpellName]["iconPath"] = string.format("%s/Spell_warlock_calldreadstalkers.blp", rootIconPath)
dt_specialisationData[callDreadStealersSpellName]["parentSpellIcon"] = string.format("%s/Spell_warlock_calldreadstalkers.blp", rootIconPath)
dt_specialisationData[callDreadStealersSpellName]["parentSpellName"] = callDreadStealersSpellName
dt_specialisationData[callDreadStealersSpellName]["skipBuff"] = true
dt_specialisationData[callDreadStealersSpellName]["isShardDependant"] = true

local function checkDemonologyTalentTree()
    for spellName, _ in pairs(dt_specialisationData) do
        local name, _, _, _, _, _, _, _ = GetSpellInfo(spellName)
        if name then
            dt_specialisationData[spellName]["active"] = true
        end
    end
end

if(isCorrectClass())then
    ---------------------------------------------------
    createMainFrame()
    createShardCountFrame()
    createHandofGuldanFrame()
    createFelstormFrame()
    ---------------------------------------------------
    -- Create a frame to register events
    local f = CreateFrame("Frame")

    -- Register the event for when the player logs in
    f:RegisterEvent("PLAYER_LOGIN")

    -- Set the function to be called when the event fires
        -- ud = UpDown
        -- lr = leftRight
    udOffset = 20
    f:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_LOGIN" then
            if(isCorrectSpec)then
                checkDemonologyTalentTree()
                local lrOffset = 75
                for buffName, data in pairs(dt_specialisationData) do
                    --buffName, lr, ud, iconPath, parentSpellIcon, parentSpellName, skipBuff, isShardDependant
                    local active = data["active"]
                    if active then 
                        local iconPath = data["iconPath"]
                        local spellname = data["spellName"]
                        if spellname ~= nil then
                            buffName = spellname
                        end
                        local parentSpellIcon = data["parentSpellIcon"]
                        local parentSpellName = data["parentSpellName"]
                        local skipBuff = data["skipBuff"]
                        local isShardDependant = data["isShardDependant"]
                        addWatcher(buffName, 
                                lrOffset, 
                                udOffset, 
                                iconPath, 
                                parentSpellIcon, 
                                parentSpellName, 
                                skipBuff, 
                                isShardDependant)
                        udOffset = udOffset + 32
                    end
                end
            end
            MWarlockMainFrame:SetHeight(udOffset+60)
        end
    end)     
end
