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

demo_spellOrder = {
    powerSiphonSpellName,
    callDreadStealersSpellName,
    inquisitorsGazeSpellName,
    summonSoulKeeperSpellName,
    summonDTSpellName,
    netherPortalSpellName,
    grimFelGuardSpellName,
}

demTree_specialisationData = {}
--buffName, _, _, iconPath, parentSpellIcon, parentSpellName, skipBuff, isShardDependant
demTree_specialisationData[grimFelGuardSpellName] = {}
demTree_specialisationData[grimFelGuardSpellName]["active"] = false
demTree_specialisationData[grimFelGuardSpellName]["spellName"] = nil
demTree_specialisationData[grimFelGuardSpellName]["iconPath"] = string.format("%s/Spell_shadow_summonfelguard.blp", rootIconPath)
demTree_specialisationData[grimFelGuardSpellName]["parentSpellIcon"] = string.format("%s/Spell_shadow_summonfelguard.blp", rootIconPath)
demTree_specialisationData[grimFelGuardSpellName]["parentSpellName"] = grimFelGuardSpellName
demTree_specialisationData[grimFelGuardSpellName]["skipBuff"] = true
demTree_specialisationData[grimFelGuardSpellName]["isShardDependant"] = true

demTree_specialisationData[powerSiphonSpellName] = {}
demTree_specialisationData[powerSiphonSpellName]["active"] = false
demTree_specialisationData[powerSiphonSpellName]["spellName"] = demonicCoreSpellName
demTree_specialisationData[powerSiphonSpellName]["iconPath"] = string.format("%s/Warlock_spelldrain.blp", rootIconPath)
demTree_specialisationData[powerSiphonSpellName]["parentSpellIcon"] = string.format("%s/Ability_warlock_backdraft.blp", rootIconPath)
demTree_specialisationData[powerSiphonSpellName]["parentSpellName"] = powerSiphonSpellName
demTree_specialisationData[powerSiphonSpellName]["skipBuff"] = nil
demTree_specialisationData[powerSiphonSpellName]["isShardDependant"] = false

demTree_specialisationData[summonDTSpellName] = {}
demTree_specialisationData[summonDTSpellName]["active"] = false
demTree_specialisationData[summonDTSpellName]["spellName"] = demonicPowerSpellName
demTree_specialisationData[summonDTSpellName]["iconPath"] = string.format("%s/Achievement_boss_argus_maleeredar.blp", rootIconPath)
demTree_specialisationData[summonDTSpellName]["parentSpellIcon"] = string.format("%s/Inv_summondemonictyrant.blp", rootIconPath)
demTree_specialisationData[summonDTSpellName]["parentSpellName"] = summonDTSpellName
demTree_specialisationData[summonDTSpellName]["skipBuff"] = nil
demTree_specialisationData[summonDTSpellName]["isShardDependant"] = false

demTree_specialisationData[summonSoulKeeperSpellName] = {}
demTree_specialisationData[summonSoulKeeperSpellName]["active"] = false
demTree_specialisationData[summonSoulKeeperSpellName]["spellName"] = "Inquisitor's Gaze"
demTree_specialisationData[summonSoulKeeperSpellName]["iconPath"] = string.format("%s/Spell_fel_elementaldevastation.blp", rootIconPath)
demTree_specialisationData[summonSoulKeeperSpellName]["parentSpellIcon"] = nil
demTree_specialisationData[summonSoulKeeperSpellName]["parentSpellName"] = nil
demTree_specialisationData[summonSoulKeeperSpellName]["skipBuff"] = nil
demTree_specialisationData[summonSoulKeeperSpellName]["isShardDependant"] = false

demTree_specialisationData[inquisitorsGazeSpellName] = {}
demTree_specialisationData[inquisitorsGazeSpellName]["active"] = false
demTree_specialisationData[inquisitorsGazeSpellName]["spellName"] = nil
demTree_specialisationData[inquisitorsGazeSpellName]["iconPath"] = string.format("%s/Inv_pet_inquisitoreye.blp", rootIconPath)
demTree_specialisationData[inquisitorsGazeSpellName]["parentSpellIcon"] = nil
demTree_specialisationData[inquisitorsGazeSpellName]["parentSpellName"] = nil
demTree_specialisationData[inquisitorsGazeSpellName]["skipBuff"] = nil
demTree_specialisationData[inquisitorsGazeSpellName]["isShardDependant"] = false

demTree_specialisationData[netherPortalSpellName] = {}
demTree_specialisationData[netherPortalSpellName]["active"] = false
demTree_specialisationData[netherPortalSpellName]["spellName"] = nil
demTree_specialisationData[netherPortalSpellName]["iconPath"] = string.format("%s/Inv_netherportal.blp", rootIconPath)
demTree_specialisationData[netherPortalSpellName]["parentSpellIcon"] = string.format("%s/Inv_netherportal.blp", rootIconPath)
demTree_specialisationData[netherPortalSpellName]["parentSpellName"] = netherPortalSpellName
demTree_specialisationData[netherPortalSpellName]["skipBuff"] = true
demTree_specialisationData[netherPortalSpellName]["isShardDependant"] = true

demTree_specialisationData[callDreadStealersSpellName] = {}
demTree_specialisationData[callDreadStealersSpellName]["active"] = false
demTree_specialisationData[callDreadStealersSpellName]["spellName"] = nil
demTree_specialisationData[callDreadStealersSpellName]["iconPath"] = string.format("%s/Spell_warlock_calldreadstalkers.blp", rootIconPath)
demTree_specialisationData[callDreadStealersSpellName]["parentSpellIcon"] = string.format("%s/Spell_warlock_calldreadstalkers.blp", rootIconPath)
demTree_specialisationData[callDreadStealersSpellName]["parentSpellName"] = callDreadStealersSpellName
demTree_specialisationData[callDreadStealersSpellName]["skipBuff"] = true
demTree_specialisationData[callDreadStealersSpellName]["isShardDependant"] = true