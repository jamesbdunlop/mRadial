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

mw_spellOrder = {
    powerSiphonSpellName,
    callDreadStealersSpellName,
    inquisitorsGazeSpellName,
    summonSoulKeeperSpellName,
    summonDTSpellName,
    netherPortalSpellName,
    grimFelGuardSpellName,
}

mw_specialisationData = {}
--buffName, _, _, iconPath, parentSpellIcon, parentSpellName, skipBuff, isShardDependant
mw_specialisationData[grimFelGuardSpellName] = {}
mw_specialisationData[grimFelGuardSpellName]["active"] = false
mw_specialisationData[grimFelGuardSpellName]["spellName"] = nil
mw_specialisationData[grimFelGuardSpellName]["iconPath"] = string.format("%s/Spell_shadow_summonfelguard.blp", rootIconPath)
mw_specialisationData[grimFelGuardSpellName]["parentSpellIcon"] = string.format("%s/Spell_shadow_summonfelguard.blp", rootIconPath)
mw_specialisationData[grimFelGuardSpellName]["parentSpellName"] = grimFelGuardSpellName
mw_specialisationData[grimFelGuardSpellName]["skipBuff"] = true
mw_specialisationData[grimFelGuardSpellName]["isShardDependant"] = true

mw_specialisationData[powerSiphonSpellName] = {}
mw_specialisationData[powerSiphonSpellName]["active"] = false
mw_specialisationData[powerSiphonSpellName]["spellName"] = demonicCoreSpellName
mw_specialisationData[powerSiphonSpellName]["iconPath"] = string.format("%s/Warlock_spelldrain.blp", rootIconPath)
mw_specialisationData[powerSiphonSpellName]["parentSpellIcon"] = string.format("%s/Ability_warlock_backdraft.blp", rootIconPath)
mw_specialisationData[powerSiphonSpellName]["parentSpellName"] = powerSiphonSpellName
mw_specialisationData[powerSiphonSpellName]["skipBuff"] = nil
mw_specialisationData[powerSiphonSpellName]["isShardDependant"] = false

mw_specialisationData[summonDTSpellName] = {}
mw_specialisationData[summonDTSpellName]["active"] = false
mw_specialisationData[summonDTSpellName]["spellName"] = demonicPowerSpellName
mw_specialisationData[summonDTSpellName]["iconPath"] = string.format("%s/Achievement_boss_argus_maleeredar.blp", rootIconPath)
mw_specialisationData[summonDTSpellName]["parentSpellIcon"] = string.format("%s/Inv_summondemonictyrant.blp", rootIconPath)
mw_specialisationData[summonDTSpellName]["parentSpellName"] = summonDTSpellName
mw_specialisationData[summonDTSpellName]["skipBuff"] = nil
mw_specialisationData[summonDTSpellName]["isShardDependant"] = false

mw_specialisationData[summonSoulKeeperSpellName] = {}
mw_specialisationData[summonSoulKeeperSpellName]["active"] = false
mw_specialisationData[summonSoulKeeperSpellName]["spellName"] = "Inquisitor's Gaze"
mw_specialisationData[summonSoulKeeperSpellName]["iconPath"] = string.format("%s/Spell_fel_elementaldevastation.blp", rootIconPath)
mw_specialisationData[summonSoulKeeperSpellName]["parentSpellIcon"] = nil
mw_specialisationData[summonSoulKeeperSpellName]["parentSpellName"] = nil
mw_specialisationData[summonSoulKeeperSpellName]["skipBuff"] = nil
mw_specialisationData[summonSoulKeeperSpellName]["isShardDependant"] = false

mw_specialisationData[inquisitorsGazeSpellName] = {}
mw_specialisationData[inquisitorsGazeSpellName]["active"] = false
mw_specialisationData[inquisitorsGazeSpellName]["spellName"] = nil
mw_specialisationData[inquisitorsGazeSpellName]["iconPath"] = string.format("%s/Inv_pet_inquisitoreye.blp", rootIconPath)
mw_specialisationData[inquisitorsGazeSpellName]["parentSpellIcon"] = nil
mw_specialisationData[inquisitorsGazeSpellName]["parentSpellName"] = nil
mw_specialisationData[inquisitorsGazeSpellName]["skipBuff"] = nil
mw_specialisationData[inquisitorsGazeSpellName]["isShardDependant"] = false

mw_specialisationData[netherPortalSpellName] = {}
mw_specialisationData[netherPortalSpellName]["active"] = false
mw_specialisationData[netherPortalSpellName]["spellName"] = nil
mw_specialisationData[netherPortalSpellName]["iconPath"] = string.format("%s/Inv_netherportal.blp", rootIconPath)
mw_specialisationData[netherPortalSpellName]["parentSpellIcon"] = string.format("%s/Inv_netherportal.blp", rootIconPath)
mw_specialisationData[netherPortalSpellName]["parentSpellName"] = netherPortalSpellName
mw_specialisationData[netherPortalSpellName]["skipBuff"] = true
mw_specialisationData[netherPortalSpellName]["isShardDependant"] = true

mw_specialisationData[callDreadStealersSpellName] = {}
mw_specialisationData[callDreadStealersSpellName]["active"] = false
mw_specialisationData[callDreadStealersSpellName]["spellName"] = nil
mw_specialisationData[callDreadStealersSpellName]["iconPath"] = string.format("%s/Spell_warlock_calldreadstalkers.blp", rootIconPath)
mw_specialisationData[callDreadStealersSpellName]["parentSpellIcon"] = string.format("%s/Spell_warlock_calldreadstalkers.blp", rootIconPath)
mw_specialisationData[callDreadStealersSpellName]["parentSpellName"] = callDreadStealersSpellName
mw_specialisationData[callDreadStealersSpellName]["skipBuff"] = true
mw_specialisationData[callDreadStealersSpellName]["isShardDependant"] = true