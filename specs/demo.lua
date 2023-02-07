rootIconPath ="Interface/ICONS"

-- Gather only the spells we're interested in! It's bit hard codey but I don't care atm...
powerSiphonSpellName = "Power Siphon" --264130
demonicCoreSpellName = "Demonic Core"

inquisitorsGazeSpellName = "Inquisitor's Gaze" --386334
summonSoulKeeperSpellName = "Summon Soulkeeper"

demonicPowerSpellName = "Demonic Power"
summonDTSpellName = "Summon Demonic Tyrant" --265187
netherPortalSpellName = "Nether Portal" --26721
grimFelGuardSpellName = "Grimoire: Felguard" --111898
callDreadStealersSpellName = "Call Dreadstalkers" --104316

dt_spellOrder = {
    powerSiphonSpellName,
    callDreadStealersSpellName,
    inquisitorsGazeSpellName,
    summonSoulKeeperSpellName,
    summonDTSpellName,
    netherPortalSpellName,
    grimFelGuardSpellName,
}

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

dt_specialisationData[powerSiphonSpellName] = {}
dt_specialisationData[powerSiphonSpellName]["active"] = false
dt_specialisationData[powerSiphonSpellName]["spellName"] = demonicCoreSpellName
dt_specialisationData[powerSiphonSpellName]["iconPath"] = string.format("%s/Warlock_spelldrain.blp", rootIconPath)
dt_specialisationData[powerSiphonSpellName]["parentSpellIcon"] = string.format("%s/Ability_warlock_backdraft.blp", rootIconPath)
dt_specialisationData[powerSiphonSpellName]["parentSpellName"] = powerSiphonSpellName
dt_specialisationData[powerSiphonSpellName]["skipBuff"] = nil
dt_specialisationData[powerSiphonSpellName]["isShardDependant"] = false

dt_specialisationData[summonDTSpellName] = {}
dt_specialisationData[summonDTSpellName]["active"] = false
dt_specialisationData[summonDTSpellName]["spellName"] = demonicPowerSpellName
dt_specialisationData[summonDTSpellName]["iconPath"] = string.format("%s/Achievement_boss_argus_maleeredar.blp", rootIconPath)
dt_specialisationData[summonDTSpellName]["parentSpellIcon"] = string.format("%s/Inv_summondemonictyrant.blp", rootIconPath)
dt_specialisationData[summonDTSpellName]["parentSpellName"] = summonDTSpellName
dt_specialisationData[summonDTSpellName]["skipBuff"] = nil
dt_specialisationData[summonDTSpellName]["isShardDependant"] = false

dt_specialisationData[summonSoulKeeperSpellName] = {}
dt_specialisationData[summonSoulKeeperSpellName]["active"] = false
dt_specialisationData[summonSoulKeeperSpellName]["spellName"] = "Inquisitor's Gaze"
dt_specialisationData[summonSoulKeeperSpellName]["iconPath"] = string.format("%s/Spell_fel_elementaldevastation.blp", rootIconPath)
dt_specialisationData[summonSoulKeeperSpellName]["parentSpellIcon"] = nil
dt_specialisationData[summonSoulKeeperSpellName]["parentSpellName"] = nil
dt_specialisationData[summonSoulKeeperSpellName]["skipBuff"] = nil
dt_specialisationData[summonSoulKeeperSpellName]["isShardDependant"] = false

dt_specialisationData[inquisitorsGazeSpellName] = {}
dt_specialisationData[inquisitorsGazeSpellName]["active"] = false
dt_specialisationData[inquisitorsGazeSpellName]["spellName"] = nil
dt_specialisationData[inquisitorsGazeSpellName]["iconPath"] = string.format("%s/Inv_pet_inquisitoreye.blp", rootIconPath)
dt_specialisationData[inquisitorsGazeSpellName]["parentSpellIcon"] = nil
dt_specialisationData[inquisitorsGazeSpellName]["parentSpellName"] = nil
dt_specialisationData[inquisitorsGazeSpellName]["skipBuff"] = nil
dt_specialisationData[inquisitorsGazeSpellName]["isShardDependant"] = false

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