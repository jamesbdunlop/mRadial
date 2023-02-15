-- rootIconPath ="Interface/ICONS"

-- Gather only the spells we're interested in! It's bit hard codey but I don't care atm...
demTree_specialisationData = {}
--buffName, _, _, iconPath, parentSpellIcon, parentSpellName, skipBuff, isShardDependant

demTree_specialisationData[grimFelGuardSpellName] = {}
demTree_specialisationData[grimFelGuardSpellName]["active"] = false
demTree_specialisationData[grimFelGuardSpellName]["buffName"] = nil
demTree_specialisationData[grimFelGuardSpellName]["iconPath"] = spellIcons[grimFelGuardSpellName]
demTree_specialisationData[grimFelGuardSpellName]["parentSpellIcon"] = spellIcons[grimFelGuardSpellName]
demTree_specialisationData[grimFelGuardSpellName]["parentSpellName"] = grimFelGuardSpellName
demTree_specialisationData[grimFelGuardSpellName]["skipBuff"] = true
demTree_specialisationData[grimFelGuardSpellName]["isShardDependant"] = true

demTree_specialisationData[powerSiphonSpellName] = {}
demTree_specialisationData[powerSiphonSpellName]["active"] = false
demTree_specialisationData[powerSiphonSpellName]["buffName"] = demonicCoreSpellName
demTree_specialisationData[powerSiphonSpellName]["iconPath"] = string.format("%s/Warlock_spelldrain.blp", rootIconPath)
demTree_specialisationData[powerSiphonSpellName]["parentSpellIcon"] = string.format("%s/Ability_warlock_backdraft.blp", rootIconPath)
demTree_specialisationData[powerSiphonSpellName]["parentSpellName"] = powerSiphonSpellName
demTree_specialisationData[powerSiphonSpellName]["skipBuff"] = nil
demTree_specialisationData[powerSiphonSpellName]["isShardDependant"] = false

demTree_specialisationData[summonDTSpellName] = {}
demTree_specialisationData[summonDTSpellName]["active"] = false
demTree_specialisationData[summonDTSpellName]["buffName"] = demonicPowerSpellName
demTree_specialisationData[summonDTSpellName]["iconPath"] = string.format("%s/Achievement_boss_argus_maleeredar.blp", rootIconPath)
demTree_specialisationData[summonDTSpellName]["parentSpellIcon"] = string.format("%s/Inv_summondemonictyrant.blp", rootIconPath)
demTree_specialisationData[summonDTSpellName]["parentSpellName"] = summonDTSpellName
demTree_specialisationData[summonDTSpellName]["skipBuff"] = nil
demTree_specialisationData[summonDTSpellName]["isShardDependant"] = false

demTree_specialisationData[summonVFSpellName] = {}
demTree_specialisationData[summonVFSpellName]["active"] = false
demTree_specialisationData[summonVFSpellName]["buffName"] = summonVFSpellName
demTree_specialisationData[summonVFSpellName]["iconPath"] = string.format("%s/Inv_argusfelstalkermount.blp", rootIconPath)
demTree_specialisationData[summonVFSpellName]["parentSpellIcon"] = string.format("%s/Inv_argusfelstalkermount.blp", rootIconPath)
demTree_specialisationData[summonVFSpellName]["parentSpellName"] = summonVFSpellName
demTree_specialisationData[summonVFSpellName]["skipBuff"] = nil
demTree_specialisationData[summonVFSpellName]["isShardDependant"] = false

demTree_specialisationData[summonSoulKeeperSpellName] = {}
demTree_specialisationData[summonSoulKeeperSpellName]["active"] = false
demTree_specialisationData[summonSoulKeeperSpellName]["buffName"] = summonSoulKeeperSpellName
demTree_specialisationData[summonSoulKeeperSpellName]["iconPath"] = string.format("%s/Spell_fel_elementaldevastation.blp", rootIconPath)
demTree_specialisationData[summonSoulKeeperSpellName]["parentSpellIcon"] = nil
demTree_specialisationData[summonSoulKeeperSpellName]["parentSpellName"] = nil
demTree_specialisationData[summonSoulKeeperSpellName]["skipBuff"] = nil
demTree_specialisationData[summonSoulKeeperSpellName]["isShardDependant"] = false

demTree_specialisationData[inquisitorsGazeSpellName] = {}
demTree_specialisationData[inquisitorsGazeSpellName]["active"] = false
demTree_specialisationData[inquisitorsGazeSpellName]["buffName"] = nil
demTree_specialisationData[inquisitorsGazeSpellName]["iconPath"] = string.format("%s/Inv_pet_inquisitoreye.blp", rootIconPath)
demTree_specialisationData[inquisitorsGazeSpellName]["parentSpellIcon"] = nil
demTree_specialisationData[inquisitorsGazeSpellName]["parentSpellName"] = nil
demTree_specialisationData[inquisitorsGazeSpellName]["skipBuff"] = nil
demTree_specialisationData[inquisitorsGazeSpellName]["isShardDependant"] = false

demTree_specialisationData[netherPortalSpellName] = {}
demTree_specialisationData[netherPortalSpellName]["active"] = false
demTree_specialisationData[netherPortalSpellName]["buffName"] = nil
demTree_specialisationData[netherPortalSpellName]["iconPath"] = string.format("%s/Inv_netherportal.blp", rootIconPath)
demTree_specialisationData[netherPortalSpellName]["parentSpellIcon"] = string.format("%s/Inv_netherportal.blp", rootIconPath)
demTree_specialisationData[netherPortalSpellName]["parentSpellName"] = netherPortalSpellName
demTree_specialisationData[netherPortalSpellName]["skipBuff"] = true
demTree_specialisationData[netherPortalSpellName]["isShardDependant"] = true

demTree_specialisationData[callDreadStealersSpellName] = {}
demTree_specialisationData[callDreadStealersSpellName]["active"] = false
demTree_specialisationData[callDreadStealersSpellName]["buffName"] = nil
demTree_specialisationData[callDreadStealersSpellName]["iconPath"] = string.format("%s/Spell_warlock_calldreadstalkers.blp", rootIconPath)
demTree_specialisationData[callDreadStealersSpellName]["parentSpellIcon"] = string.format("%s/Spell_warlock_calldreadstalkers.blp", rootIconPath)
demTree_specialisationData[callDreadStealersSpellName]["parentSpellName"] = callDreadStealersSpellName
demTree_specialisationData[callDreadStealersSpellName]["skipBuff"] = true
demTree_specialisationData[callDreadStealersSpellName]["isShardDependant"] = true