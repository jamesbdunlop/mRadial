-- ROOTICONPATH ="Interface/ICONS"

-- Gather only the spells we're interested in! It's bit hard codey but I don't care atm...
demTree_specialisationData = {}
--buffName, _, _, iconPath, parentSpellIcon, parentSpellName, skipBuff, isShardDependant

demTree_specialisationData[GRIMFELGUARD_SPELLNAME] = {}
demTree_specialisationData[GRIMFELGUARD_SPELLNAME]["active"]            = false
demTree_specialisationData[GRIMFELGUARD_SPELLNAME]["buffName"]          = false
demTree_specialisationData[GRIMFELGUARD_SPELLNAME]["iconPath"]          = false
demTree_specialisationData[GRIMFELGUARD_SPELLNAME]["parentSpellIcon"]   = spellIcons[GRIMFELGUARD_SPELLNAME]
demTree_specialisationData[GRIMFELGUARD_SPELLNAME]["parentSpellName"]   = GRIMFELGUARD_SPELLNAME
demTree_specialisationData[GRIMFELGUARD_SPELLNAME]["skipBuff"]          = true
demTree_specialisationData[GRIMFELGUARD_SPELLNAME]["isShardDependant"]  = true

demTree_specialisationData[POWERSIPHON_SPELLNAME] = {}
demTree_specialisationData[POWERSIPHON_SPELLNAME]["active"]             = false
demTree_specialisationData[POWERSIPHON_SPELLNAME]["buffName"]           = DEMONICCORE_SPELLNAME
demTree_specialisationData[POWERSIPHON_SPELLNAME]["iconPath"]           = spellIcons[POWERSIPHON_SPELLNAME]
demTree_specialisationData[POWERSIPHON_SPELLNAME]["parentSpellIcon"]    = spellIcons[DEMONICCORE_SPELLNAME]
demTree_specialisationData[POWERSIPHON_SPELLNAME]["parentSpellName"]    = POWERSIPHON_SPELLNAME
demTree_specialisationData[POWERSIPHON_SPELLNAME]["skipBuff"]           = false
demTree_specialisationData[POWERSIPHON_SPELLNAME]["isShardDependant"]   = false

demTree_specialisationData[SUMMONDT_SPELLNAME] = {}
demTree_specialisationData[SUMMONDT_SPELLNAME]["active"]                = false
demTree_specialisationData[SUMMONDT_SPELLNAME]["buffName"]              = DEMONICPOWER_SPELLNAME
demTree_specialisationData[SUMMONDT_SPELLNAME]["iconPath"]              = spellIcons[SUMMONDT_SPELLNAME]
demTree_specialisationData[SUMMONDT_SPELLNAME]["parentSpellIcon"]       = spellIcons[DEMONICPOWER_SPELLNAME]
demTree_specialisationData[SUMMONDT_SPELLNAME]["parentSpellName"]       = SUMMONDT_SPELLNAME
demTree_specialisationData[SUMMONDT_SPELLNAME]["skipBuff"]              = false
demTree_specialisationData[SUMMONDT_SPELLNAME]["isShardDependant"]      = false

demTree_specialisationData[SUMMONVF_SPELLNAME] = {}
demTree_specialisationData[SUMMONVF_SPELLNAME]["active"]                = false
demTree_specialisationData[SUMMONVF_SPELLNAME]["buffName"]              = SUMMONVF_SPELLNAME
demTree_specialisationData[SUMMONVF_SPELLNAME]["iconPath"]              = spellIcons[SUMMONVF_SPELLNAME]
demTree_specialisationData[SUMMONVF_SPELLNAME]["parentSpellIcon"]       = spellIcons[SUMMONVF_SPELLNAME]
demTree_specialisationData[SUMMONVF_SPELLNAME]["parentSpellName"]       = SUMMONVF_SPELLNAME
demTree_specialisationData[SUMMONVF_SPELLNAME]["skipBuff"]              = false
demTree_specialisationData[SUMMONVF_SPELLNAME]["isShardDependant"]      = false

demTree_specialisationData[SUMMONSOULKEEPER_SPELLNAME] = {}
demTree_specialisationData[SUMMONSOULKEEPER_SPELLNAME]["active"]            = false
demTree_specialisationData[SUMMONSOULKEEPER_SPELLNAME]["buffName"]          = SUMMONSOULKEEPER_SPELLNAME
demTree_specialisationData[SUMMONSOULKEEPER_SPELLNAME]["iconPath"]          = spellIcons[SUMMONSOULKEEPER_SPELLNAME]
demTree_specialisationData[SUMMONSOULKEEPER_SPELLNAME]["parentSpellIcon"]   = false
demTree_specialisationData[SUMMONSOULKEEPER_SPELLNAME]["parentSpellName"]   = false
demTree_specialisationData[SUMMONSOULKEEPER_SPELLNAME]["skipBuff"]          = false
demTree_specialisationData[SUMMONSOULKEEPER_SPELLNAME]["isShardDependant"]  = false

demTree_specialisationData[INQUISITORSGAZE_SPELLNAME] = {}
demTree_specialisationData[INQUISITORSGAZE_SPELLNAME]["active"]             = false
demTree_specialisationData[INQUISITORSGAZE_SPELLNAME]["buffName"]           = false
demTree_specialisationData[INQUISITORSGAZE_SPELLNAME]["iconPath"]           = false
demTree_specialisationData[INQUISITORSGAZE_SPELLNAME]["parentSpellIcon"]    = spellIcons[INQUISITORSGAZE_SPELLNAME]
demTree_specialisationData[INQUISITORSGAZE_SPELLNAME]["parentSpellName"]    = INQUISITORSGAZE_SPELLNAME
demTree_specialisationData[INQUISITORSGAZE_SPELLNAME]["skipBuff"]           = false
demTree_specialisationData[INQUISITORSGAZE_SPELLNAME]["isShardDependant"]   = false

demTree_specialisationData[NETHERPORTAL_SPELLNAME] = {}
demTree_specialisationData[NETHERPORTAL_SPELLNAME]["active"]            = false
demTree_specialisationData[NETHERPORTAL_SPELLNAME]["buffName"]          = false
demTree_specialisationData[NETHERPORTAL_SPELLNAME]["iconPath"]          = spellIcons[NETHERPORTAL_SPELLNAME]
demTree_specialisationData[NETHERPORTAL_SPELLNAME]["parentSpellIcon"]   = spellIcons[NETHERPORTAL_SPELLNAME]
demTree_specialisationData[NETHERPORTAL_SPELLNAME]["parentSpellName"]   = NETHERPORTAL_SPELLNAME
demTree_specialisationData[NETHERPORTAL_SPELLNAME]["skipBuff"]          = true
demTree_specialisationData[NETHERPORTAL_SPELLNAME]["isShardDependant"]  = true

demTree_specialisationData[CALLDREADSTALKERS_SPELLNAME] = {}
demTree_specialisationData[CALLDREADSTALKERS_SPELLNAME]["active"]           = false
demTree_specialisationData[CALLDREADSTALKERS_SPELLNAME]["buffName"]         = false
demTree_specialisationData[CALLDREADSTALKERS_SPELLNAME]["iconPath"]         = spellIcons[CALLDREADSTALKERS_SPELLNAME]
demTree_specialisationData[CALLDREADSTALKERS_SPELLNAME]["parentSpellIcon"]  = spellIcons[CALLDREADSTALKERS_SPELLNAME]
demTree_specialisationData[CALLDREADSTALKERS_SPELLNAME]["parentSpellName"]  = CALLDREADSTALKERS_SPELLNAME
demTree_specialisationData[CALLDREADSTALKERS_SPELLNAME]["skipBuff"]         = true
demTree_specialisationData[CALLDREADSTALKERS_SPELLNAME]["isShardDependant"] = true

demTree_specialisationData[IMPLOSION_SPELLNAME] = {}
demTree_specialisationData[IMPLOSION_SPELLNAME]["active"]               = false
demTree_specialisationData[IMPLOSION_SPELLNAME]["buffName"]             = false
demTree_specialisationData[IMPLOSION_SPELLNAME]["iconPath"]             = spellIcons[IMPLOSION_SPELLNAME]
demTree_specialisationData[IMPLOSION_SPELLNAME]["parentSpellIcon"]      = spellIcons[IMPLOSION_SPELLNAME]
demTree_specialisationData[IMPLOSION_SPELLNAME]["parentSpellName"]      = IMPLOSION_SPELLNAME
demTree_specialisationData[IMPLOSION_SPELLNAME]["skipBuff"]             = true
demTree_specialisationData[IMPLOSION_SPELLNAME]["isShardDependant"]     = false

demTree_specialisationData[SHADOWFURY_SPELLNAME] = {}
demTree_specialisationData[SHADOWFURY_SPELLNAME]["active"]               = false
demTree_specialisationData[SHADOWFURY_SPELLNAME]["buffName"]             = false
demTree_specialisationData[SHADOWFURY_SPELLNAME]["iconPath"]             = spellIcons[SHADOWFURY_SPELLNAME]
demTree_specialisationData[SHADOWFURY_SPELLNAME]["parentSpellIcon"]      = spellIcons[SHADOWFURY_SPELLNAME]
demTree_specialisationData[SHADOWFURY_SPELLNAME]["parentSpellName"]      = SHADOWFURY_SPELLNAME
demTree_specialisationData[SHADOWFURY_SPELLNAME]["skipBuff"]             = true
demTree_specialisationData[SHADOWFURY_SPELLNAME]["isShardDependant"]     = false
