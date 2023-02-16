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
demTree_specialisationData[powerSiphonSpellName]["iconPath"] = spellIcons[powerSiphonSpellName]
demTree_specialisationData[powerSiphonSpellName]["parentSpellIcon"] = spellIcons[demonicCoreSpellName]
demTree_specialisationData[powerSiphonSpellName]["parentSpellName"] = powerSiphonSpellName
demTree_specialisationData[powerSiphonSpellName]["skipBuff"] = nil
demTree_specialisationData[powerSiphonSpellName]["isShardDependant"] = false

demTree_specialisationData[summonDTSpellName] = {}
demTree_specialisationData[summonDTSpellName]["active"] = false
demTree_specialisationData[summonDTSpellName]["buffName"] = demonicPowerSpellName
demTree_specialisationData[summonDTSpellName]["iconPath"] = spellIcons[summonDTSpellName]
demTree_specialisationData[summonDTSpellName]["parentSpellIcon"] = spellIcons[demonicPowerSpellName]
demTree_specialisationData[summonDTSpellName]["parentSpellName"] = summonDTSpellName
demTree_specialisationData[summonDTSpellName]["skipBuff"] = nil
demTree_specialisationData[summonDTSpellName]["isShardDependant"] = false

demTree_specialisationData[summonVFSpellName] = {}
demTree_specialisationData[summonVFSpellName]["active"] = false
demTree_specialisationData[summonVFSpellName]["buffName"] = summonVFSpellName
demTree_specialisationData[summonVFSpellName]["iconPath"] = spellIcons[summonVFSpellName]
demTree_specialisationData[summonVFSpellName]["parentSpellIcon"] = spellIcons[summonVFSpellName]
demTree_specialisationData[summonVFSpellName]["parentSpellName"] = summonVFSpellName
demTree_specialisationData[summonVFSpellName]["skipBuff"] = nil
demTree_specialisationData[summonVFSpellName]["isShardDependant"] = false

demTree_specialisationData[summonSoulKeeperSpellName] = {}
demTree_specialisationData[summonSoulKeeperSpellName]["active"] = false
demTree_specialisationData[summonSoulKeeperSpellName]["buffName"] = summonSoulKeeperSpellName
demTree_specialisationData[summonSoulKeeperSpellName]["iconPath"] = spellIcons[summonSoulKeeperSpellName]
demTree_specialisationData[summonSoulKeeperSpellName]["parentSpellIcon"] = nil
demTree_specialisationData[summonSoulKeeperSpellName]["parentSpellName"] = nil
demTree_specialisationData[summonSoulKeeperSpellName]["skipBuff"] = nil
demTree_specialisationData[summonSoulKeeperSpellName]["isShardDependant"] = false

demTree_specialisationData[inquisitorsGazeSpellName] = {}
demTree_specialisationData[inquisitorsGazeSpellName]["active"] = false
demTree_specialisationData[inquisitorsGazeSpellName]["buffName"] = nil
demTree_specialisationData[inquisitorsGazeSpellName]["iconPath"] = spellIcons[inquisitorsGazeSpellName]
demTree_specialisationData[inquisitorsGazeSpellName]["parentSpellIcon"] = nil
demTree_specialisationData[inquisitorsGazeSpellName]["parentSpellName"] = nil
demTree_specialisationData[inquisitorsGazeSpellName]["skipBuff"] = nil
demTree_specialisationData[inquisitorsGazeSpellName]["isShardDependant"] = false

demTree_specialisationData[netherPortalSpellName] = {}
demTree_specialisationData[netherPortalSpellName]["active"] = false
demTree_specialisationData[netherPortalSpellName]["buffName"] = nil
demTree_specialisationData[netherPortalSpellName]["iconPath"] = spellIcons[netherPortalSpellName]
demTree_specialisationData[netherPortalSpellName]["parentSpellIcon"] = spellIcons[netherPortalSpellName]
demTree_specialisationData[netherPortalSpellName]["parentSpellName"] = netherPortalSpellName
demTree_specialisationData[netherPortalSpellName]["skipBuff"] = true
demTree_specialisationData[netherPortalSpellName]["isShardDependant"] = true

demTree_specialisationData[callDreadStealersSpellName] = {}
demTree_specialisationData[callDreadStealersSpellName]["active"] = false
demTree_specialisationData[callDreadStealersSpellName]["buffName"] = nil
demTree_specialisationData[callDreadStealersSpellName]["iconPath"] = spellIcons[callDreadStealersSpellName]
demTree_specialisationData[callDreadStealersSpellName]["parentSpellIcon"] = spellIcons[callDreadStealersSpellName]
demTree_specialisationData[callDreadStealersSpellName]["parentSpellName"] = callDreadStealersSpellName
demTree_specialisationData[callDreadStealersSpellName]["skipBuff"] = true
demTree_specialisationData[callDreadStealersSpellName]["isShardDependant"] = true

demTree_specialisationData[implosionSpellName] = {}
demTree_specialisationData[implosionSpellName]["active"] = false
demTree_specialisationData[implosionSpellName]["buffName"] = nil
demTree_specialisationData[implosionSpellName]["iconPath"] = spellIcons[implosionSpellName]
demTree_specialisationData[implosionSpellName]["parentSpellIcon"] = spellIcons[implosionSpellName]
demTree_specialisationData[implosionSpellName]["parentSpellName"] = implosionSpellName
demTree_specialisationData[implosionSpellName]["skipBuff"] = true
demTree_specialisationData[implosionSpellName]["isShardDependant"] = false