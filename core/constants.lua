---------------------------------------------------------------------------------------------------
felstormSpellName = "Felstorm"
mw_shardFrameName = "MWShardFrame"
rootIconPath ="Interface/ICONS"
mediaPath = "Interface\\AddOns\\mWarlock\\media"
mainFrameName = "MWarlockBGFrame"
mainFrameIsMoving = false
---------------------------------------------------------------------------------------------------
-- Demo Spells of interest
powerSiphonSpellName = "Power Siphon" --264130
demonicCoreSpellName = "Demonic Core"
inquisitorsGazeSpellName = "Inquisitor's Gaze" --386334
summonSoulKeeperSpellName = "Summon Soulkeeper"
demonicPowerSpellName = "Demonic Power"
summonDTSpellName = "Summon Demonic Tyrant" --265187
summonVFSpellName = "Summon VileFiend" --264119
netherPortalSpellName = "Nether Portal" --26721
grimFelGuardSpellName = "Grimoire: Felguard" --111898
callDreadStealersSpellName = "Call Dreadstalkers" --104316

demo_spellOrder = {}
demo_spellOrder[powerSiphonSpellName] = 264130
demo_spellOrder[callDreadStealersSpellName] = 104316
demo_spellOrder[inquisitorsGazeSpellName] = 386334
demo_spellOrder[summonSoulKeeperSpellName] = nil
demo_spellOrder[summonDTSpellName] = 265187
demo_spellOrder[summonVFSpellName] = 264119
demo_spellOrder[netherPortalSpellName] = 267217
demo_spellOrder[grimFelGuardSpellName] = 111898

---------------------------------------------------------------------------------------------------
spellIcons = {}
-- Demo
spellIcons[powerSiphonSpellName] = string.format("%s/Warlock_spelldrain.blp", rootIconPath)
spellIcons[demonicCoreSpellName] = string.format("%s/Ability_warlock_backdraft.blp", rootIconPath)
spellIcons[callDreadStealersSpellName] = string.format("%s/Spell_warlock_calldreadstalkers.blp", rootIconPath)
spellIcons[inquisitorsGazeSpellName] = string.format("%s/Inv_pet_inquisitoreye.blp", rootIconPath)
spellIcons[summonSoulKeeperSpellName] = string.format("%s/Spell_fel_elementaldevastation.blp", rootIconPath)
spellIcons[summonDTSpellName] = string.format("%s/Achievement_boss_argus_maleeredar.blp", rootIconPath)
spellIcons[demonicPowerSpellName] = string.format("%s/Inv_summondemonictyrant.blp", rootIconPath)
spellIcons[summonVFSpellName] = string.format("%s/Inv_argusfelstalkermount.blp", rootIconPath)
spellIcons[netherPortalSpellName] = string.format("%s/Inv_netherportal.blp", rootIconPath)
spellIcons[grimFelGuardSpellName] = string.format("%s/Spell_shadow_summonfelguard.blp", rootIconPath)
spellIcons[callDreadStealersSpellName] = string.format("%s/Spell_warlock_calldreadstalkers.blp", rootIconPath)
-- Destro
-- Affy